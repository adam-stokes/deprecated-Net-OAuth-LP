package Net::OAuth::LP::Client;

use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw/user_agent/);
use LWP::UserAgent;
use strict;
use warnings;
use Net::OAuth::LP;
use URI;
use URI::QueryParam;
use URI::Encode;

sub new {
  my $class = shift;
  my $consumer_key = shift;
  my $token = shift;
  my $token_secret = shift;
  my %opts = @_;

  $opts{user_agent} ||= LWP::UserAgent->new;
  my $self = bless \%opts, $class;
  return $self;
}

# lazy private
# url query builder
# TODO: Unexport at some point
sub _call {
    my $self    = shift;
    my $path    = shift;
    my $uri     = $self->_path_cons($path);
    my $yml     = LoadFile $self->cfg_file;
    my $request = Net::OAuth->request('protected resource')->new(
        consumer_key     => $yml->{consumer_key},
        consumer_secret  => '',
        token            => $yml->{access_token},
        token_secret     => $yml->{access_token_secret},
        request_url      => $uri->as_string(),
        request_method   => 'GET',
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => $self->_nonce
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

sub _query_from_hash {
    my $self   = shift;
    my ($params) = @_;
    my $uri    = URI->new;
    for my $param (keys $params) {
      $uri->query_param_append($param, $params->{$param});
    }
    $uri->query;
}

# construct path, if a resource link just provide as is.
sub _path_cons {
  my $self = shift;
  my $path = shift;
  if ($path =~ /api/) {
    return URI->new("$path", 'https');
  }
  URI->new($self->api_v1 . "/$path", 'https');
}

sub request {
  my $self = shift;
  my $response = $self->user_agent->request(@_);
}

# Happy happy client interfaces

sub me {
  my $self = shift;
  my $person = shift;
  $self->call($person);
}

sub project {
  my $self = shift;
  my $project = shift;
  $self->call($project);
}

sub bug {
    my $self   = shift;
    my $bug_link = shift;
    $self->call($bug_link);
}

sub search {
  my $self = shift;
  my $path = shift;
  my $query = $self->_query_from_hash(@_);
  my $uri =  join("?",$path, $query);
  $self->call($uri);
}
