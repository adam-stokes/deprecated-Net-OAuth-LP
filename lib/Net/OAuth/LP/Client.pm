package Net::OAuth::LP::Client;

use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw/ua consumer_key token token_secret api_v1 api_dev/);
use LWP::UserAgent;
use HTTP::Request::Common;
use File::Spec::Functions;
use strict;
use warnings;
use Net::OAuth::LP;
use JSON;
use URI;
use URI::QueryParam;
use URI::Encode;
use Data::Dumper;

sub new {
    my $class        = shift;
    my $consumer_key = shift;
    my $token        = shift;
    my $token_secret = shift;
    my %opts         = @_;

    $opts{ua} ||= LWP::UserAgent->new;
    $opts{consumer_key} = $consumer_key;
    $opts{token}        = $token;
    $opts{token_secret} = $token_secret;
    $opts{api_v1}       = q[https://api.launchpad.net/1.0];
    $opts{api_dev}      = q[https://api.launchpad.net/devel];

    my $self = bless \%opts, $class;
    return $self;
}

# lazy private
# url query builder
# TODO: Unexport at some point
sub __call {
    my $self    = shift;
    my $path    = shift;
    my $uri     = $self->__path_cons($path);
    my $request = Net::OAuth->request('protected resource')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => '',
        token            => $self->token,
        token_secret     => $self->token_secret,
        request_url      => $uri->as_string,
        request_method   => 'GET',
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => Net::OAuth::LP->_nonce
    );
    $request->sign;
    my $res = $self->ua->request(GET $request->to_url);

    if ($res->is_success) {
        return (decode_json($res->content), "Success", 0);
    }
    else {
        return (undef, "Failed to pull resource", 1);
    }
}

sub __query_from_hash {
    my $self   = shift;
    my ($params) = @_;
    my $uri    = URI->new;
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
  URI->new($self->api_v1 . "/$path", 'https');
}

sub _request {
  my $self = shift;
  my $response = $self->ua->request(@_);
}

# Happy happy client interfaces

sub me {
  my $self = shift;
  my $login = shift;
  $self->__call('~'.$login);

}

sub project {
  my $self = shift;
  my $project = shift;
  $self->__call($project);
}

sub bug {
    my $self   = shift;
    my $bug_link = shift;
    $self->__call($bug_link);
}

sub search {
  my $self = shift;
  my $path = shift;
  my $query = $self->__query_from_hash(@_);
  my $uri =  join("?",$path, $query);
  $self->__call($uri);
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

=head2 C<project>

    $lp->project('ubuntu');

=head2 C<search>

    $lp->search('ubuntu', { 'ws.op' => 'searchTasks',
                            'ws.size' => '10',
                            'status' => 'New' });


=cut

1; # End of Net::OAuth::LP::Client
