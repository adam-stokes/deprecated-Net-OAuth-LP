package Net::OAuth::LP::Models::Person;

# VERSION

use strictures 1;
use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use Hash::AsObject;
use Data::Dump qw(pp);

with('Net::OAuth::LP::Models');

has 'resource' => (is => 'ro');

has 'attrs' => (is => 'rw');

method emails {
    $self->c->get($self->attrs->confirmed_email_addresses_collection_link);
}

method ircnick {
    $self->c->get($self->attrs->irc_nicknames_collection_link);
}

method recipes {
    $self->c->get($self->attrs->recipes_collection_link);
}

method fetch {
    $self->attrs($self->c->get($self->resource));
}

method find_by_link ($resource_link) {
    $self->c->get($resource_link);
}

method set_name ($name) {
    $self->c->update($self->attrs->self_link, {'name' => $name});
}

method set_description ($desc) {
    $self->c->update($self->attrs->self_link, {'description' => $desc});
}

method set_display_name ($desc) {
    $self->c->update($self->attrs->self_link, {'display_name' => $desc});
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

Net::OAuth::LP::Models::Person - Person model

=head1 DESCRIPTION

Model interface for retrieving/setting person/team information.

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');

    my $p = Net::OAuth::LP::Models::Person->new(c => $c, resource => '~adam-stokes');
    $p->fetch;
    say $p->attrs->display_name;

=head1 ATTRIBUTES

=head2 B<attrs>

Contains hash object of https://api.launchpad.net/1.0.html#person

=head1 METHODS

=head2 B<new>

    my $p =
      Net::OAuth::LP::Models::Person->new(c => $c, resource => 'lp-name');

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
