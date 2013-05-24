package Net::OAuth::LP;

use Moo;
use Method::Signatures;

use Browser::Open qw[open_browser];
use HTTP::Request::Common;
use LWP::UserAgent;

use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0;

# VERSION

has consumer_key => (
    is      => 'rw',
    isa     => method {},
    lazy    => 1,
    default => 'im-a-key',
);

has access_token => (
    is      => 'rw',
    isa     => method {},
    default => '',
    lazy    => 1,
);

has access_token_secret => (
    is      => 'rw',
    isa     => method {},
    default => '',
    lazy    => 1,
);

has request_token_url => (
    is      => 'ro',
    isa     => method {},
    default => method {
        if ($self->staging) {
            'https://staging.launchpad.net/+request-token';
        }
        else {
            'https://launchpad.net/+request-token';
        }
    },
    lazy => 1,
);

has access_token_url => (
    is      => 'ro',
    isa     => method {},
    default => method {
        if ($self->staging) {
            'https://staging.launchpad.net/+access-token';
        }
        else {
            'https://launchpad.net/+access-token';
        }
    },
    lazy => 1,
);

has authorize_token_url => (
    is      => 'ro',
    isa     => method {},
    default => method {
        if ($self->staging) {
            'https://staging.launchpad.net/+authorize-token';
        }
        else {
            'https://launchpad.net/+authorize-token';
        }
    },
    lazy => 1,
);

has api_url => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        if ($self->staging) {
            'https://api.staging.launchpad.net/1.0';
        }
        else {
            'https://api.launchpad.net/1.0';
        }
    },
);

has staging => (
    is      => 'rw',
    isa     => method {},
    default => 0,
);

###########################################################################
# Protected
###########################################################################
method _nonce {
    my @a = ('A' .. 'Z', 'a' .. 'z', 0 .. 9);
    my $nonce = '';
    for (0 .. 31) {
        $nonce .= $a[rand(scalar(@a))];
    }

    $nonce;
}

###########################################################################
# Public
###########################################################################
method login_with_creds {
    my $ua      = LWP::UserAgent->new();
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
    my $res =
      $ua->request(POST $request->to_url, Content => $request->to_post_body);

    die "Failed to get response" unless $res->is_success;
    my $response =
      Net::OAuth->response('request token')->from_post_body($res->content);
    my $_token        = $response->token;
    my $_token_secret = $response->token_secret;
    open_browser($self->authorize_token_url . "?oauth_token=" . $_token);

    print "Pulling authorization credentials.\n";

    $request = Net::OAuth->request('access token')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => '',
        token            => $_token,
        token_secret     => $_token_secret,
        request_url      => $self->access_token_url,
        request_method   => 'POST',
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => $self->_nonce
    );

    $request->sign;

    $res =
      $ua->request(POST $request->to_url, Content => $request->to_post_body);
    die "Failed to get response" unless $res->is_success;
    $response =
      Net::OAuth->response('access token')->from_post_body($res->content);
    $self->access_token($response->token);
    $self->access_token_secret($response->token_secret);
}

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

=head2 C<token>

Token received from authorized request

=head2 C<token_secret>

Token secret received from authorized request

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


