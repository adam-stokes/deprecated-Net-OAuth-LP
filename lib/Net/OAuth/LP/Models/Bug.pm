package Net::OAuth::LP::Models::Bug;

use strict;
use warnings;

# MODELS
use Net::OAuth::LP::Models::Activity;
use Net::OAuth::LP::Models::Attachments;
use Net::OAuth::LP::Models::CVE;
use Net::OAuth::LP::Models::Linkedbranches;
use Net::OAuth::LP::Models::Messages;
use Net::OAuth::LP::Models::Person;
use Net::OAuth::LP::Models::Tasks;
use Net::OAuth::LP::Models::Watches;

use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;

with('Net::OAuth::LP::Models');

has 'resource' => (
    is       => 'ro',
    isa      => Int,
    required => 1
);

has 'attrs' => (is => 'rw');

method fetch {
    $self->attrs(
        $self->c->get($self->c->api_url . "/bugs/" . $self->resource));
}

method tasks {
    Net::OAuth::LP::Models::Tasks->new(
        c     => $self->c,
        tasks => $self->c->get($self->attrs->bug_tasks_collection_link)
    );
}

method messages {
    Net::OAuth::LP::Models::Messages->new(
        c        => $self->c,
        messages => $self->c->get($self->attrs->messages_collection_link)
    );
}

method activity {
    Net::OAuth::LP::Models::Activity->new(
        c        => $self->c,
        activity => $self->c->get($self->attrs->activity_collection_link)
    );
}

method attachments {
    Net::OAuth::LP::Models::Attachments->new(
        c           => $self->c,
        attachments => $self->c->get($self->attrs->attachments_collection_link)
    );
}

method watches {
    Net::OAuth::LP::Models::Watches->new(
        c       => $self->c,
        watches => $self->c->get($self->attrs->bug_watches_collection_link)
    );
}

method cves {
    Net::OAuth::LP::Models::CVE->new(
        c    => $self->c,
        cves => $self->c->get($self->attrs->cves_collection_link)
    );
}

method linkedbranches {
    Net::OAuth::LP::Models::Linkedbranches->new(
        c => $self->c,
        linkedbranches =>
          $self->c->get($self->attrs->linked_branches_collection_link)
    );
}

method owner {
    $self->c->get($self->attrs->owner_link);
}

method set_tags ($tags) {
    $self->c->update($self->attrs->self_link, {'tags' => $tags});
}

method set_title ($title) {
    $self->c->update($self->attrs->self_link, {'title' => $title});
}

method set_assignee ($assignee) {
    $self->c->update($self->attrs->tasks->self_link,
        {'assignee_link' => $assignee->self_link});
}

method set_importance ($importance) {
    $self->c->update($self->attrs->tasks->self_link,
        {'importance' => $importance});
}

method new_message ($msg) {
    $self->c->post(
        $self->attrs->self_link,
        {   'ws.op'   => 'newMessage',
            'content' => $msg
        }
    );
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Bug - Bug model

=head1 DESCRIPTION

Interface to setting/retrieving bug information

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');
    my $b = Net::OAuth::LP::Models::Bug->new(c => $c, resource => 1);
    $b->fetch;
    say $b->attrs->title;

=head1 ATTRIBUTES

=head2 B<attrs>

    Contains hash object of https://api.launchpad.net/1.0.html#bug

=head2 B<resource>

=head1 METHODS

=head2 B<new>

    my $b = Net::OAuth::LP::Models::Bug->new(c => $c, resource => 1);

=head2 B<tasks>

=head2 B<messages>

=head2 B<activity>

=head2 B<attachments>

=head2 B<watches>

=head2 B<cves>

=head2 B<linkedbranches>

=head2 B<owner>

=head2 B<set_tags>

    $b->set_tags(['tagA', 'tagB']);

=head2 B<set_title>

Set title(aka summary) of bug

    $b->set_title('A new title');

=head2 B<new_message>

Adds a new message to the bug.

    $b->new_message("This is a comment");

=head2 B<set_importance>

Sets priority ['Critical', 'High', 'Medium', 'Low']

    $b->set_importance('Critical');

=head2 B<set_assignee>

Sets the assignee of bug.

    $person->find('~adam-stokes');
    $b->set_assignee($person);

=cut
