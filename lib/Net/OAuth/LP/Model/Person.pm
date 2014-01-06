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

sub date_created {
    my $self = shift;
    return $self->person->{date_created};
}

sub description {
    my $self = shift;
    return $self->person->{description};
}

sub gpg_keys {
    my $self = shift;
    my $gpg_keys = $self->get($self->person->{gpg_keys_collection_link});
    return $gpg_keys->{entries};
}

sub irc_nicks {
    my $self = shift;
    my $irc_nicks = $self->get($self->person->{irc_nicknames_collection_link});
    return $irc_nicks->{entries};
}

sub is_team {
    my $self = shift;
    return $self->person->{is_team};
}

sub is_ubuntu_coc_signer {
    my $self = shift;
    return $self->person->{is_ubuntu_coc_signer};
}

sub is_valid {
    my $self = shift;
    return $self->person->{is_valid};
}

sub ppas {
    my $self = shift;
    my $ppas = $self->get($self->person->{ppas_collection_link});
    return $ppas->{entries};
}

sub private {
    my $self = shift;
    return $self->person->{private};
}

sub source_recipes {
    my $self = shift;
    my $s_recipes = $self->get($self->person->{recipes_collection_link});
    return $s_recipes->{entries};
}

sub ssh_keys {
    my $self = shift;
    my $ssh_keys = $self->get($self->person->{sshkeys_collection_link});
    return $ssh_keys->{entries};

}

sub time_zone {
    my $self = shift;
    return $self->person->{time_zone};
}

sub web_link {
    my $self = shift;
    return $self->person->{web_link};
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Model::Person - Launchpad.net person interface

=head1 SYNOPSIS

    use Net::OAuth::LP::Client;
    use Net::OAuth::LP::Model;
    my $c = Net::OAuth::LP::Client->new;
    $c->staging(1);

    my $model = Net::OAuth::LP::Model->new($c);
    my $person = $model->namespace('Person')->by_name('~adam-stokes');

    say "Name: ". $person->name;

=head1 DESCRIPTION

Person model for Launchpad.net.

=head1 ATTRIBUTES

=head2 person

Holds person object.

=head1 METHODS

=head2 by_name

This needs to be called before any of the below methods. Takes a login
id, e.g. ~adam-stokes

=head2 name

Returns person name.

=head2 karma

Returns person karma.

=head2 display_name

Returns friendly display name

=head2 date_created

Returns date person registered

=head2 description

Returns description blob

=head2 gpg_keys

Returns list a gpg keys registered

=head2 irc_nicks

Returns list of irc nicks

=head2 is_team

Returns whether collection is a person or team

=head2 is_ubuntu_coc_signer

Returns if person signed Ubuntu COC

=head2 is_valid

Returns if person is valid and not a deactivated account

=head2 ppas

Returns list of ppas associated

=head2 private

Returns if person or team is registered as private

=head2 source_recipes

Returns recipe collection of package builds

=head2 ssh_keys

Returns list of public ssh keys

=head2 time_zone

Returns persons time zone

=head2 web_link

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

