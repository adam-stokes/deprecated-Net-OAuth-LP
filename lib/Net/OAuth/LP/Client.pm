package Net::OAuth::LP::Client;
use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;
use MooseX::Method::Signatures;

use File::Spec::Functions;
use HTTP::Request::Common;
use HTTP::Request;
use JSON;

use URI::Encode;
use URI::QueryParam;
use URI;
use Util::Any -all;
use List::Compare;

extends 'Net::OAuth::LP';

###########################################################################
# Private
###########################################################################
method __query_from_hash ($params) {
    my $uri = URI->new;
    for my $param (keys $params) {
        $uri->query_param_append($param, $params->{$param});
    }
    $uri->query;
}

# construct path, if a resource link just provide as is.
method __path_cons ($path) {
    if ($path =~ /^http.*api/) {
        return URI->new("$path", 'https');
    }
    URI->new($self->api_url . "/$path", 'https');
}

method __oauth_authorization_header ($request) {
    my $enc = URI::Encode->new({encode_reserved => 1});
    join(",",
        'OAuth realm="https://api.launchpad.net"',
        'oauth_consumer_key="' . $request->consumer_key . '"',
        'oauth_token="' . $request->token . '"',
        'oauth_signature_method="PLAINTEXT"',
        'oauth_signature="' . $enc->encode($request->signature) . '"',
        'oauth_timestamp="' . $request->timestamp . '"',
        'oauth_nonce="' . $request->nonce . '"',
        'oauth_version="' . $request->version . '"');
}

###############################################################################
# protected
###############################################################################
method _request ($resource, $params, $method) {
    my $uri     = $self->__path_cons($resource);
    my $request = Net::OAuth->request('protected resource')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => '',
        token            => $self->access_token,
        token_secret     => $self->access_token_secret,
        request_url      => $uri->as_string,
        request_method   => $method,
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => $self->_nonce,
    );
    $request->sign;

    if ($method eq "POST") {
        my $_req =
          HTTP::Request->new(POST => $request->normalized_request_url);
        $_req->header(
            'Authorization' => $self->__oauth_authorization_header($request));
        $_req->content($self->__query_from_hash($params));
        my $res = $self->lwp_req($_req);
        die "Failed to POST: " . $res->{_msg} unless ($res->{_rc} == 201);
    }
    elsif ($method eq "PATCH") {

        # HTTP::Request::Common doesnt support PATCH verb
        my $_req =
          HTTP::Request->new(PATCH => $request->normalized_request_url);
        $_req->header('User-Agent'   => 'imafreakinninjai/1.0');
        $_req->header('Content-Type' => 'application/json');
        $_req->header(
            'Authorization' => $self->__oauth_authorization_header($request));
        $_req->content(encode_json($params));
        my $res = $self->lwp_req($_req);

        # For current Launchpad API 1.0 the response code is 209
        # (Initially in draft spec for PATCH, but, later removed
        # during final)
        # FIXME: Check for Proper response code 200 after 2015 when
        # API is expired.
        die $res->{_content} unless $res->{_rc} == 209;
        decode_json($res->content);
    }
    else {
        my $res = $self->lwp_req(GET $request->to_url);

        die $res->{_content} unless $res->is_success;
        decode_json($res->content);
    }
}

method get ($resource) {
    $self->_request($resource, undef, 'GET');
}


method post ($resource, $params) {
    $self->_request($resource, $params, 'POST');
}

method update ($resource, $params) {
    $self->_request($resource, $params, 'PATCH');
}

###############################################################################
# Public methods
###############################################################################

###################################
# Bug Getters
###################################
method bug ($bug_id) {
    my $resource_link = $self->__path_cons("bugs/$bug_id");
    $self->get($resource_link);
}

method bug_task ($resource_link) {
    $self->get($resource_link);
}

method bug_activity ($resource_link) {
    $self->get($resource_link);
}

###################################
# Bug Setters
###################################
method bug_set_tags ($resource, $tags) {
    my @idx = indexes {$_} @{$resource->{tags}};
    foreach my $index (@idx) {
        $resource->{tags}[$index];
    }

#    $self->update($resource->{self_link}, {'tags' => @{$clone_tags}});
}

method bug_set_title ($resource, $title) {
    $self->update($resource->{self_link}, {'title' => $title});
}

method bug_set_assignee ($resource, $assignee) {
    my $bug_task = $self->get($resource->{bug_tasks_collection_link});
    $self->update($bug_task->{self_link},
        {'assignee_link' => $assignee->{self_link}});
}

method bug_set_importance ($resource, $importance) {
    my $bug_task = $self->get($resource->{bug_tasks_collection_link});
    $self->update($bug_task->{self_link}, {'importance' => $importance});
}

method bug_new_message ($resource, $msg) {
    $self->post(
        $resource->{self_link},
        {   'ws.op'   => 'newMessage',
            'content' => $msg
        }
    );
}

###################################
# Person
###################################
method person ($name) {
    $self->get($name);
}

###################################
# Resource Link getter
###################################
method resource ($resource_link) {
    $self->get($resource_link);
}

###################################
# Search
###################################
method search ($path, $segments) {
    my $query = $self->__query_from_hash($segments);
    my $uri = join("?", $path, $query);
    $self->get($uri);
}


__PACKAGE__->meta->make_immutable;
1;                          # End of Net::OAuth::LP::Client


=head1 NAME

Net::OAuth::LP::Client - Launchpad.net Client routines

=head1 SYNOPSIS

Client for performing query tasks.

    my $lp = Net::OAuth::LP::Client->new(consumer_key => 'consumerkey',
                                         access_token => 'accesstoken',
                                         access_token_secret => 'accesstokensecret');

    # Use your launchpad.net name in place of adam-stokes. 
    # You can figure that out by visiting
    # https://launchpad.net/~/ and look at Launchpad Id.

    my $person = $lp->person('~adam-stokes');

=head1 METHODS

=head2 C<new>

    my $lp = Net::OAuth::LP::Client->new(consumer_key => 'consumerkey',
                                         access_token => 'accesstoken',
                                         access_token_secret => 'accesstokensecret');

=head2 C<post>

    Takes resource link and params, and performs
    POST on uri

    $lp->post('lp.net/bugs/1', { 'ws.op' => 'newMessage',
                                 'content' => "This is a message"});

=cut

=head2 C<bug>

    $lp->bug(1);

=head2 C<bug_set_tags>

    $lp->bug_set_tags($bug, ['tagA', 'tagB']);

=head2 C<bug_set_title>

Set title of bug

    $lp->bug_set_title($bug, 'A new title');

=head2 C<bug_new_message>

Add new message to bug

    $lp->bug_new_message($bug->{self_link}, "This is a comment");

=head2 C<bug_activity>

view bug activity

    $lp->bug_activity($resource);

=head2 C<bug_task>

view bug tasks

    $lp->bug_task($resource);

=head2 C<bug_set_importance>

    $lp->bug_set_importance($bug, 'Critical');

=head2 C<bug_set_assignee>

    $lp->bug_set_assignee($bug, $person_object);

=head2 C<person>

    $lp->person('lp-login');

=head2 C<search>

    $lp->search('ubuntu', { 'ws.op' => 'searchTasks',
                            'ws.size' => '10',
                            'status' => 'New' });

=head2 C<resource>

    $lp->resource('launchpad_resource_link');

=cut

