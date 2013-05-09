package Net::OAuth::LP::Client;

use namespace::autoclean;

use Moose;
use MooseX::Privacy;
use MooseX::StrictConstructor;
use MooseX::Method::Signatures;

use Carp;
use Data::Dumper;
use File::Spec::Functions;
use HTTP::Request::Common;
use HTTP::Request;
use JSON;
use autodie;

use URI::Encode;
use URI::QueryParam;
use URI;

extends 'Net::OAuth::LP';

###########################################################################
# Private
###########################################################################
private_method __query_from_hash => sub {
    my $self     = shift;
    my ($params) = @_;
    my $uri      = URI->new;
    for my $param (keys $params) {
        $uri->query_param_append($param, $params->{$param});
    }
    $uri->query;
};

# construct path, if a resource link just provide as is.
private_method __path_cons => sub {
    my $self = shift;
    my $path = shift;
    if ($path =~ /^http.*api/) {
        return URI->new("$path", 'https');
    }
    URI->new($self->api_url . "/$path", 'https');
};

private_method __oauth_authorization_header => sub {
    my ($self, $request) = @_;
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
};

###############################################################################
# protected
###############################################################################
protected_method _request => sub {
    my ($self, $resource, $params, $method) = @_;
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
        nonce            => Net::OAuth::LP->_nonce
    );
    $request->sign;

    if ($method eq "POST") {
        my $res = $self->request(POST $request->to_url,
            Content => $self->__query_from_hash($params));
        if ($res->is_success) {
            return decode_json($res->content);
        }
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
        my $res = $self->request($_req);

        # For current Launchpad API 1.0 the response code is 209
        # (Initially in draft spec for PATCH, but, later removed
        # during final)
        # FIXME: Check for Proper response code 200 after 2015 when
        # API is expired.
        if ($res->{_rc} == 209) {
            return decode_json($res->content);
        }
    }
    else {
        my $res = $self->lwp_req(GET $request->to_url);
        print Dumper($res);

        if ($res->is_success) {
            return decode_json($res->content);
        }
    }
};

protected_method get => sub {
    my ($self, $resource) = @_;
    $self->_request($resource, undef, 'GET');
};

protected_method post => sub {
    my ($self, $resource, $params) = @_;
    $self->_request($resource, $params, 'POST');
};

protected_method update => sub {
    my ($self, $resource, $params) = @_;
    $self->_request($resource, $params, 'PATCH');
};

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
sub bug_set_tags {
    my ($self, $resource, $tags) = @_;

    # Merge new tags into existing and process a
    # -<tag> in order to remove a tag.
    # FIXME: Incomplete
    my $join_ref = [@$resource->{tags}, @$tags];
    my @filtered_lists = grep { !/^\-/ } @$join_ref;
    $self->update($resource->{self_link}, {'tags' => \@filtered_lists});
}

sub bug_set_title {
    my ($self, $resource, $title) = @_;
    $self->update($resource->{self_link}, {'title' => $title});
}

sub bug_set_assignee {
    my ($self, $resource, $assignee) = @_;
    my $bug_task = $self->get($resource->{bug_tasks_collection_link});
    $self->update($bug_task->{self_link},
        {'assignee_link' => $assignee->{self_link}});
}

sub bug_set_importance {
    my ($self, $resource, $importance) = @_;
    my $bug_task = $self->get($resource->{bug_tasks_collection_link});
    $self->update($bug_task->{self_link}, {'importance' => $importance});
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
1;                # End of Net::OAuth::LP::Client


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

=head2 C<bug>

    $lp->bug(1);

=head2 C<bug_set_tags>

    $lp->bug_set_tags($bug, ['tagA', 'tagB']);

=head2 C<bug_set_title>

Set title of bug

    $lp->bug_set_title($bug, 'A new title');

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

