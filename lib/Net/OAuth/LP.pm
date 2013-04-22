package Net::OAuth::LP;

use Modern::Perl '2013';
use Browser::Open qw[open_browser];
use Data::Dumper;
use File::Spec::Functions;
use HTTP::Request::Common;
use LWP::UserAgent;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Privacy;
use MooseX::StrictConstructor;
use namespace::autoclean;
use Net::OAuth;
use Carp;
use YAML qw[LoadFile DumpFile];
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0;

BEGIN {
  our $VERSION = '0.001006';
}

has cfg => (
    traits   => ['Hash'],
    is       => 'ro',
    isa      => 'HashRef',
    default  => sub { LoadFile catfile($ENV{HOME}, ".lp-auth.yml") },
    required => 1,
);

has request_token_url => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://launchpad.net/+request-token',
);

has access_token_url => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://launchpad.net/+access-token',
);

has authorize_token_url => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://launchpad.net/+authorize-token',
);

###########################################################################
# Protected
###########################################################################
protected_method ua => sub { LWP::UserAgent->new };

###########################################################################
# Public
###########################################################################
sub token {
    my $self = shift;
    $self->cfg->{access_token};
}

sub token_secret {
    my $self = shift;
    $self->cfg->{access_token_secret};
}

sub consumer_key {
    my $self = shift;
    $self->cfg->{consumer_key};
}

sub login_with_creds {
    my $self    = shift;
    my $request = Net::OAuth->request('consumer')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => '',
        request_url      => $self->request_token_url,
        request_method   => 'POST',
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => $self->_nonce,
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
        croak("Unable to get request token or secret");
    }

    say "Pulling authorization credentials.";

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
        DumpFile catfile($ENV{HOME}, '.lp-auth.yml'),
          { consumer_key        => $self->consumer_key,
            access_token        => $response->token,
            access_token_secret => $response->token_secret,
          };
    }
    else {
        croak("Unable to obtain access token and secret");
    }
}


# unexported helpers

# return nonce for signed request
sub _nonce {
    my @a = ('A' .. 'Z', 'a' .. 'z', 0 .. 9);
    my $nonce = '';
    for (0 .. 31) {
        $nonce .= $a[rand(scalar(@a))];
    }

    $nonce;
}
__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Net::OAuth::LP - Launchpad.net OAuth 1.0

=head1 SYNOPSIS

OAuth 1.0a authorization and client for Launchpad.net

    use Net::OAuth::LP;

    my $lp = Net::OAuth::LP->new;
    $lp->consumer_key('my-lp-app');

    # Authorize yourself
    $lp->login_with_creds;

=head1 ATTRIBUTES

L<Net::OAuth::LP> implements the following attributes:

=head2 C<consumer_key>

Holds the string that identifies your application.

    $lp->consumer_key('my-app-name');

=head1 METHODS

=head2 C<new>

    my $lp = Net::OAuth::LP->new;

=head2 C<login_with_creds>

    $lp->login_with_creds;

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

Copyright 2013 Adam Stokes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut


