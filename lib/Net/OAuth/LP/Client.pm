package Net::OAuth::LP::Client;

use Modern::Perl '2013';
use autodie;
use Moose;
use MooseX::StrictConstructor;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common;
use File::Spec::Functions;
use Net::OAuth::LP;
use JSON;
use URI;
use URI::QueryParam;
use URI::Encode;
use Data::Dumper;
use Carp;

has consumer_key => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has token => (
	      is => 'rw',
	      isa => 'Str',
	      required => 1
);

has token_secret => (
		     is => 'rw',
		     isa => 'Str',
		     required => 1
);

has api_url => (
		is => 'rw',
		isa => 'Str',
		required => 1,
		default => q[https://api.staging.launchpad.net/1.0]
);

sub ua { LWP::UserAgent->new }

###########################################################################
# Assumed private and semi-private though nothing is enforced :\
###########################################################################
sub __query_from_hash {
    my $self     = shift;
    my ($params) = @_;
    my $uri      = URI->new;
    for my $param (keys $params) {
        $uri->query_param_append($param, $params->{$param});
    }
    $uri->query;
}

# construct path, if a resource link just provide as is.
sub __path_cons {
    my $self = shift;
    my $path = shift;
    if ($path =~ /api/) {
        return URI->new("$path", 'https');
    }
    URI->new($self->api_staging . "/$path", 'https');
}

sub __oauth_authorization_header {
    my ($self, $request) = @_;
    my $enc = URI::Encode->new({encode_reserved => 1});

    join(",",
        'OAuth realm="https://api.staging.launchpad.net"',
        'oauth_consumer_key="' . $request->consumer_key . '"',
        'oauth_token="' . $request->token . '"',
        'oauth_signature_method="PLAINTEXT"',
        'oauth_signature="' . $enc->encode($request->signature) . '"',
        'oauth_timestamp="' . $request->timestamp . '"',
        'oauth_nonce="' . $request->nonce . '"',
        'oauth_version="' . $request->version . '"');
}

sub _request {
    my ($self, $resource, $params, $method) = @_;
    my $uri     = $self->__path_cons($resource);
    my $request = Net::OAuth->request('protected resource')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => '',
        token            => $self->token,
        token_secret     => $self->token_secret,
        request_url      => $uri->as_string,
        request_method   => $method,
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => Net::OAuth::LP->_nonce
    );
    $request->sign;

    if ($method eq "POST") {
        my $res = $self->ua->request(POST $request->to_url,
            Content => $self->__query_from_hash($params));
        if ($res->is_success) {
            return decode_json($res->content);
        }
    }
    elsif ($method eq "PATCH") {

        # HTTP::Request::Common doesnt support PATCH verb
        my $_req =
          HTTP::Request->new(PATCH => $request->normalized_request_url);
        $_req->header('User-Agent'    => 'imafreakinninjai/1.0');
        $_req->header('Content-Type'  => 'application/json');
        $_req->header('Authorization' => $self->__oauth_authorization_header($request));
        $_req->content(encode_json($params));
        my $res = $self->ua->request($_req);

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
        my $res = $self->ua->request(GET $request->to_url);
        if ($res->is_success) {
            return decode_json($res->content);
        }
    }
    carp "Failed to pull resource";
}

###########################################################################
# Public methods
###########################################################################
sub get {
    my ($self, $resource) = @_;
    $self->_request($resource, undef, 'GET');
}

sub post {
  my ($self, $resource, $params) = @_;
  $self->_request($resource, $params, 'POST');
}

sub update {
  my ($self, $resource, $params) = @_;
  $self->_request($resource, $params, 'PATCH');
}

#################################
# Project Getters
#################################
sub project {
    my ($self, $project) = @_;
    $self->get($project);
}

#################################
# Person/Team Getters
#################################
sub person {
    my ($self, $login) = @_;
    $self->get('~' . $login);
}

#################################
# Bug Getters
#################################
sub bug {
    my $self          = shift;
    my $bug_id        = shift;
    my $resource_link = $self->__path_cons("/bugs/$bug_id");
    $self->get($resource_link);
}

#################################
# Bug Setters
#################################

sub bug_set_tags {
    my ($self, $resource, $existing_tags, $tags) = @_;

    # Merge new tags into existing and process a
    # -<tag> in order to remove a tag.
    # FIXME: Incomplete
    my $join_ref = [@$existing_tags, @$tags];
    my @filtered_lists = grep {!/^\-/} @$join_ref;
    $self->update($resource, {'tags' => \@filtered_lists});
}

sub bug_set_title {
    my ($self, $resource, $title) = @_;
    $self->update($resource, {'title' => $title});
}

#################################
# Resource Link getter
#################################
sub resource {
  my ($self, $resource_link) = @_;
  $self->get($resource_link);
}

#################################
# Search
#################################
sub search {
    my ($self, $path, $segments) = @_;
    my $query = $self->__query_from_hash($segments);
    my $uri = join("?", $path, $query);
    $self->get($uri);
}

=head1 NAME

Net::OAuth::LP::Client - Launchpad.net Client routines

=head1 SYNOPSIS

Client for performing query tasks.

    my $lp = Net::OAuth::LP::Client->new('consumer-key', 'access-token', 'access-token-secret');

    # Use your launchpad.net name in place of adam-stokes. You can figure that out by visiting
    # https://launchpad.net/~ and look at Launchpad Id.

    my ($person, $err, $ret) = $lp->me('adam-stokes');

=head1 METHODS

=head2 C<new>

    my $lp = Net::OAuth::LP::Client->new('consumerkey','accesstoken','accesstokensecret');

=head2 C<me>

    $lp->me('<lp name>');

=head2 C<bug>

    $lp->bug(1);

=head2 C<bug_msgs>

    my $bug = $lp->bug(1);
    $lp->bug_msgs($bug->{messages_collection_link});

=head2 C<bug_activity>

Return a log of modifications to bug

    my $bug = $lp->bug(1);
    $lp->bug_activity($bug->{activity_collection_link});

=head2 C<project>

    $lp->project('ubuntu');

=head2 C<search>

    $lp->search('ubuntu', { 'ws.op' => 'searchTasks',
                            'ws.size' => '10',
                            'status' => 'New' });


=cut

1;    # End of Net::OAuth::LP::Client
