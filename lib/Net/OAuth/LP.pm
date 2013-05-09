package Net::OAuth::LP;

use namespace::autoclean;

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Privacy;
use MooseX::StrictConstructor;
use MooseX::Method::Signatures;

use Browser::Open qw[open_browser];
use HTTP::Request::Common;
use LWP::UserAgent;

use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0;

BEGIN {
    use version; our $VERSION = version->declare("v0.1.0");
}

has consumer_key => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => 'you-dont-know-me',
);

has access_token => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
    lazy    => 1,
);

has access_token_secret => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
    lazy    => 1,
);

has request_token_url => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://launchpad.net/+request-token',
    lazy    => 1,
);

has access_token_url => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://launchpad.net/+access-token',
    lazy    => 1,
);

has authorize_token_url => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://launchpad.net/+authorize-token',
    lazy    => 1,
);

has ua => (
    is      => 'ro',
    isa     => 'LWP::UserAgent',
    handles => {lwp_req => 'request',},
    default => sub { LWP::UserAgent->new() },
);

has api_url => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => q[https://api.launchpad.net/1.0]
);

###########################################################################
# Protected
###########################################################################
protected_method _nonce => sub {
    my @a = ('A' .. 'Z', 'a' .. 'z', 0 .. 9);
    my $nonce = '';
    for (0 .. 31) {
        $nonce .= $a[rand(scalar(@a))];
    }

    $nonce;
};

###########################################################################
# Public
###########################################################################
method login_with_creds {
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
    my $res = $self->lwp_req(POST $request->to_url,
        Content => $request->to_post_body);

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

    $res = $self->lwp_req(POST $request->to_url,
        Content => $request->to_post_body);
    die "Failed to get response" unless $res->is_success;
    $response =
      Net::OAuth->response('access token')->from_post_body($res->content);
    $self->access_token($response->token);
    $self->access_token_secret($response->token_secret);
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


