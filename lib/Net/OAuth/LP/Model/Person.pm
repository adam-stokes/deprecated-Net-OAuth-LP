package Net::OAuth::LP::Model::Person;

use Mojo::Base 'Net::OAuth::LP::Model';

has 'person';

sub by_name {
    my ($self, $name) = @_;
    $self->person($self->get(sprintf("%s/%s", $self->api_url, $name)));
}

sub name {
    my $self = shift;
    return $self->person->{name};
}

sub karma {
    my $self = shift;
    return $self->person->{karma};
}

sub display_name {
    my $self = shift;
    return $self->person->{display_name};
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Model::Person - Launchpad.net person interface

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new;
    $c->staging(1);

    my $person = $c->namespace('Person')->by_name('~adam-stokes');

    say "Name: ". $person->name;

=head1 DESCRIPTION

Person model for Launchpad.net.

=head1 METHODS

=head2 by_name

This needs to be called before any of the below methods. Takes a login id number.

e.g. ~adam-stokes

=head2 name

Returns person name.

=head2 karma

Returns person karma.

=head2 display_name

Returns friendly display name, usually first and last name.

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

