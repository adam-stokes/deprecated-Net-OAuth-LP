package Net::OAuth::LP::Models::Person;

# VERSION

use Moo;
use Method::Signatures;

with('Net::OAuth::LP::Models');

has 'person' => (
    is      => 'rw',
    isa     => method {},
    lazy    => 1,
    default => method { {} },
);

method find ($name) {
    $self->person($self->get($name));
}

method display_name {
    $self->person->{display_name};
}

method description {
    $self->person->{description};
}

method emails {
    $self->get($self->person->{confirmed_email_addresses_collection_link});
}

method karma {
    $self->person->{karma};
}

method ircnick {
    $self->get($self->person->{irc_nicknames_collection_link});
}

method name {
    $self->person->{name};
}

method recipes {
    $self->get($self->person->{recipes_collection_link});
}

method tz {
    $self->person->{time_zone};
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Person

=head1 DESCRIPTION

Person Model

=head1 METHODS

=head2 B<new>

    my $p = Net::OAuth::LP::Models::Person->new;

=head2 B<find>

Queries a person or team resource.

    $p->find('~launchpad-user-or-team');

=head2 B<display_name>

Return display name

=head2 B<description>

Return description

=head2 B<emails>

Return confirmed emails

=head2 B<karma>

Return karma

=head2 B<ircnick>

Return irc nickname

=head2 B<name>

Return launchpad name

=head2 B<recipes>

Return source recipes

=head2 B<tz>

Returns time_zone

=cut
