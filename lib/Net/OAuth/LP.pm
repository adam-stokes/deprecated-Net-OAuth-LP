package Net::OAuth::LP;

use strict;
use warnings;
use File::Spec::Functions;
use Log::Log4perl qw[:easy];
use LWP::UserAgent;
use HTTP::Request::Common;
use Browser::Open qw[open_browser];
use Net::OAuth;
use YAML qw[LoadFile DumpFile];
use JSON;
use Carp ();
use URI;
use Data::Dumper;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0;

our $VERSION = '0.20132702';

BEGIN {
  my $ua = LWP::UserAgent->new;
  *_UA = sub () { $ua };
}

sub new {
    my $class = shift;

    # Default attrs
    my $attrs = {};
    $attrs->{cfg_file}            = catfile($ENV{HOME}, '.lp-auth.yml');
    $attrs->{consumer_key}        = '';
    $attrs->{request_token_url}   = q[https://launchpad.net/+request-token];
    $attrs->{access_token_url}    = q[https://launchpad.net/+access-token];
    $attrs->{authorize_token_url} = q[https://launchpad.net/+authorize-token];
    $attrs->{api_v1}              = q[https://api.launchpad.net/1.0];
    $attrs->{api_dev}             = q[https://api.launchpad.net/devel];
    $attrs->{ua} = _UA;

    my $self = {%$attrs, @_};
    bless $self, $class;
    return $self;
}

sub cfg_file { @_ > 1 ? $_[0]->{cfg_file} = $_[1] : $_[0]->{cfg_file} }
sub api_v1   { @_ > 1 ? $_[0]->{api_v1}   = $_[1] : $_[0]->{api_v1} }
sub api_dev  { @_ > 1 ? $_[0]->{api_dev}  = $_[1] : $_[0]->{api_dev} }
sub ua  { @_ > 1 ? $_[0]->{ua}  = $_[1] : $_[0]->{ua} }

sub consumer_key {
    @_ > 1 ? $_[0]->{consumer_key} = $_[1] : $_[0]->{consumer_key};
}

sub request_token_url {
    @_ > 1 ? $_[0]->{request_token_url} = $_[1] : $_[0]->{request_token_url};
}

sub access_token_url {
    @_ > 1 ? $_[0]->{access_token_url} = $_[1] : $_[0]->{access_token_url};
}

sub authorize_token_url {
    @_ > 1
      ? $_[0]->{authorize_token_url} = $_[1]
      : $_[0]->{authorize_token_url};
}

sub login_with_creds {
    my $self    = shift;
    my $request = Net::OAuth->request('consumer')->new(
        consumer_key       => $self->consumer_key,
        consumer_secret    => '',
        request_url        => $self->request_token_url,
        request_method     => 'POST',
        signature_method   => 'PLAINTEXT',
        timestamp          => time,
        nonce              => $self->_nonce,
    );

    $request->sign;
    my $res = $self->ua->request(POST $request->to_url,
        Content => $request->to_post_body);
    my $token;
    my $token_secret;
    if ($res->is_success) {
        my $response =
          Net::OAuth->response('request token')
          ->from_post_body($res->content);
        $token        = $response->token;
        $token_secret = $response->token_secret;
        open_browser($self->authorize_token_url . "?oauth_token=" . $token);
    }
    else {
        Carp::croak("Unable to get request token or secret");
    }

    print "Waiting for 20 seconds to authorize.\n";
    sleep(20);

    $request = Net::OAuth->request('access token')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => '',
        token            => $token,
        token_secret     => $token_secret,
        request_url      => $self->access_token_url,
        request_method   => 'POST',
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => $self->_nonce
    );

    $request->sign;

    $res = $self->ua->request(POST $request->to_url,
        Content => $request->to_post_body);

    if ($res->is_success) {
        my $response =
          Net::OAuth->response('access token')->from_post_body($res->content);
        umask 0177;
        DumpFile $self->cfg_file,
          { consumer_key        => $self->consumer_key,
            access_token        => $response->token,
            access_token_secret => $response->token_secret,
          };
    }
    else {
        Carp::croak("Unable to obtain access token and secret");
    }


}

sub call {
    my $self    = shift;
    my $path    = shift;
    my $uri     = URI->new($self->api_v1."/$path", 'https');
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
        return decode_json($res->content);
    }
    else {
        Carp::croak("Could not pull resource");
    }
}

sub _nonce {
    my @a = ('A' .. 'Z', 'a' .. 'z', 0 .. 9);
    my $nonce = '';
    for (0 .. 31) {
        $nonce .= $a[rand(scalar(@a))];
    }

    $nonce;
}

=head1 NAME

Net::OAuth::LP - Launchpad.net OAuth 1.0

=head1 SYNOPSIS

OAuth 1.0a authorization and client for Launchpad.net

Perhaps a little code snippet.

    use Net::OAuth::LP;

    my $lp = Net::OAuth::LP->new;
    $lp->consumer_key('my-lp-app');

    # Authorize yourself
    $lp->login_with_creds;

    # Perform client call
    $lp->call('~adam-stokes');

=head1 ATTRIBUTES

L<Net::OAuth::LP> implements the following attributes:

=head2 C<consumer_key>

Holds the string that identifies your application.

=head1 METHODS

=head2 C<new>

    my $lp = Net::OAuth::LP->new;

=head2 C<login_with_creds>

    $lp->login_with_creds;

=head2 C<call>

    $lp->call('~adam-stokes');

=head1 AUTHOR

Adam 'battlemidget' Stokes, C<< <adam.stokes at ubuntu.com> >>

=head1 BUGS

Report bugs to https://github.com/battlemidget/Net-OAuth-LP/issues.

=head1 DEVELOPMENT

=head2 Repository

    http://github.com/battlemidget/Net-OAuth-LP

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::OAuth::LP

=head1 LICENSE AND COPYRIGHT

Copyright 2013 =Adam Stokes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1;    # End of Net::OAuth::LP
