package Net::OAuth::LP::Models::Person;

# VERSION

use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use Data::Dump qw(pp);

with('Net::OAuth::LP::Models');

has 'person' => (
    is      => 'rw',
    isa     => HashRef,
    lazy    => 1,
    default => method { {} },
);

has 'display_name' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->person->{display_name};
    },
);

has 'description' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->person->{description};
    },
);

has 'emails' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->get(
            $self->person->{confirmed_email_addresses_collection_link});
    },
);

has 'karma' => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => method {
        $self->person->{karma};
    },
);

has 'ircnick' => (
    is      => 'rw',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->get($self->person->{irc_nicknames_collection_link});
    },
);

has 'name' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->person->{name};
    },
);

has 'recipes' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->get($self->person->{recipes_collection_link});
    },
);

has 'tz' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->person->{time_zone};
    },
);

has 'self_link' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->person->{self_link};
    },
);


method find ($name) {
    $self->person($self->get($name));
}

method find_by_link ($resource_link) {
    $self->person($self->get($resource_link));
}

method set_name ($name) {
    $self->update($self->self_link, {'name' => $name});
}

method set_description ($desc) {
    $self->update($self->self_link, {'description' => $desc});
}

method set_display_name ($desc) {
    $self->update($self->self_link, {'display_name' => $desc});
}

method get_assigned_bugs {
    $self->search(
        'ubuntu-advantage',
        {   'ws.op'    => 'searchTasks',
            'ws.size'  => 5,
            'assignee' => $self->self_link,
        },
    );
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Person - Person interface

=head1 DESCRIPTION

Model interface for retrieving/setting person/team information.

=head1 SYNOPSIS

    my $p = Net::OAuth::LP::Models::Person->new;
    $p->find('~adam-stokes');
    say $p->display_name;

=head1 ATTRIBUTES

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

=head1 METHODS

=head2 B<new>

    my $p = Net::OAuth::LP::Models::Person->new;

=head2 B<find>

Queries a person or team resource.

    $p->find('~launchpad-user-or-team');

=head2 B<set_name>

Set launchpad name

    $p->set_name('new-name');

=head2 B<set_description>

Set description

    $p->set_description('Im a real boy!');

=head2 B<set_display_name>

Sets display name

    $p->set_display_name('A Name');

=head2 B<get_assigned_bugs>

Gets bugs assigned to $person

    $p->get_assigned_bugs;

=cut
