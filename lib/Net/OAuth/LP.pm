package Net::OAuth::LP;

use Mojo::Base -base;
use Mojo::UserAgent;

use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0;

our $VERSION = '0.017_3';

has 'ua' => sub { my $self = shift; Mojo::UserAgent->new };
has 'consumer_key' => 'im-a-key';
has 'access_token';
has 'access_token_secret';
has staging => 0;

sub request_token_url {
    my $self = shift;
    if ($self->staging) {
        'https://staging.launchpad.net/+request-token';
    }
    else {
        'https://launchpad.net/+request-token';
    }
}

sub access_token_url {
    my $self = shift;
    if ($self->staging) {
        'https://staging.launchpad.net/+access-token';
    }
    else {
        'https://launchpad.net/+access-token';
    }
}

sub authorize_token_url {
    my $self = shift;
    if ($self->staging) {
        'https://staging.launchpad.net/+authorize-token';
    }
    else {
        'https://launchpad.net/+authorize-token';
    }
}

sub api_url {
    my $self = shift;
    if ($self->staging) {
        'https://api.staging.launchpad.net/1.0';
    }
    else {
        'https://api.launchpad.net/1.0';
    }
}

sub _nonce {
    my $self  = shift;
    my @a     = ('A' .. 'Z', 'a' .. 'z', 0 .. 9);
    my $nonce = '';
    for (0 .. 31) {
        $nonce .= $a[rand(scalar(@a))];
    }
    return $nonce;
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

=head2 B<access_token>

Token received from authorized request

=head2 B<access_token_secret>

Token secret received from authorized request

=head2 B<staging>

Boolean to interact with staging server or production.

=head2 B<ua>

A L<Mojo::UserAgent>.

=head1 METHODS

=head2 B<access_token_url>

OAuth Access token url

=head2 B<authorize_token_url>

OAuth Authorize token url

=head2 B<request_token_url>

OAuth Request token url

=head2 B<api_url>

API url for doing the client interactions with launchpad.net

=head1 AUTHOR

Adam Stokes, C<< <adamjs at cpan.org> >>

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

Copyright 2013-2014 Adam Stokes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


