package Net::OAuth::LP;

use Mojo::Base -base;
use Mojo::UserAgent;

use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0;

our $VERSION = '0.017_1';

has ua => Mojo::UserAgent->new;
has consumer_key => 'im-a-key';
has access_token;
has access_token_secret;
has request_token_url => sub {
    my $self = shift;
    if ($self->staging) {
        'https://staging.launchpad.net/+request-token';
    }
    else {
        'https://launchpad.net/+request-token';
    }
};

has access_token_url => sub {
    if ($self->staging) {
        'https://staging.launchpad.net/+access-token';
    }
    else {
        'https://launchpad.net/+access-token';
    }
};

has authorize_token_url => sub {
    if ($self->staging) {
        'https://staging.launchpad.net/+authorize-token';
    }
    else {
        'https://launchpad.net/+authorize-token';
    }
};

has api_url => sub {
    if ($self->staging) {
        'https://api.staging.launchpad.net/1.0';
    }
    else {
        'https://api.launchpad.net/1.0';
    }
};

has staging => 0;


sub _nonce {
    my $self  = shift;
    my @a     = ('A' .. 'Z', 'a' .. 'z', 0 .. 9);
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

Copyright 2013-2014 Adam Stokes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


