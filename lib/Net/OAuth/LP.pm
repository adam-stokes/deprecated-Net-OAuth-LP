package Net::OAuth::LP;

use strict;
use warnings;
use v5.18.0;
use Moo::Role;
use Method::Signatures;

use HTTP::Request::Common;
use LWP::UserAgent;

use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0;

our $VERSION = '0.017_1';

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
    default => method { 0 },
);

method _nonce {
    my @a = ('A' .. 'Z', 'a' .. 'z', 0 .. 9);
    my $nonce = '';
    for (0 .. 31) {
        $nonce .= $a[rand(scalar(@a))];
    }

    $nonce;
}

1;

=head1 NAME

Net::OAuth::LP - Launchpad.net OAuth 1.0

=head1 SYNOPSIS

OAuth 1.0a authorization and client for Launchpad.net

=head1 ATTRIBUTES

L<Net::OAuth::LP> implements the following attributes:

=head2 B<consumer_key>

Holds the string that identifies your application.

    $lp->consumer_key('my-app-name');

=head2 B<token>

Token received from authorized request

=head2 B<token_secret>

Token secret received from authorized request

=head1 AUTHOR

Adam 'battlemidget' Stokes, C<< <adamjs at cpan.org> >>

=head1 BUGS

Report bugs to https://github.com/battlemidget/Net-OAuth-LP/issues.

=head1 DEVELOPMENT

=head2 Repository

    http://github.com/battlemidget/Net-OAuth-LP

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::OAuth::LP

=head1 SEE ALSO

=over 4

=item * L<https://launchpad.net/launchpadlib>, "Python implementation"

=back

=head1 COPYRIGHT

Copyright 2013- Adam Stokes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


