package Net::OAuth::LP::Models::Bug;

# VERSION

use strictures 1;

# MODELS
use Net::OAuth::LP::Models::Activity;
use Net::OAuth::LP::Models::Attachments;
use Net::OAuth::LP::Models::CVE;
use Net::OAuth::LP::Models::Linkedbranches;
use Net::OAuth::LP::Models::Messages;
use Net::OAuth::LP::Models::Person;
use Net::OAuth::LP::Models::Tasks;
use Net::OAuth::LP::Models::Watches;
use Data::Dump qw[pp];

use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;

with('Net::OAuth::LP::Models');

has 'bug' => (is => 'rw');

has 'tasks' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::Tasks->new(
            c     => $self->c,
            tasks => $self->c->get($self->bug->bug_tasks_collection_link)
        );
    }
);

has 'messages' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::Messages->new(
            c        => $self->c,
            messages => $self->c->get($self->bug->messages_collection_link)
        );
    },
);

has 'activity' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::Activity->new(
            c        => $self->c,
            activity => $self->c->get($self->bug->activity_collection_link)
        );
    },
);

has 'attachments' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::Attachments->new(
            c => $self->c,
            attachments =>
              $self->c->get($self->bug->attachments_collection_link)
        );
    },
);

has 'watches' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::Watches->new(
            c       => $self->c,
            watches => $self->c->get($self->bug->bug_watches_collection_link)
        );
    },
);

has 'cves' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::CVE->new(
            c    => $self->c,
            cves => $self->c->get($self->bug->cves_collection_link)
        );
    },
);

has 'linkedbranches' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::Linkedbranches->new(
            c => $self->c,
            linkedbranches =>
              $self->c->get($self->bug->linked_branches_collection_link)
        );
    },
);

has 'owner' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        my $p = Net::OAuth::LP::Models::Person->new(c => $self->c);
        $p->find_by_link($self->bug->owner_link);
    },
);

has 'target_name' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {},
);

has 'status' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {},
);

has 'importance' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {},
);

method find ($bug_id) {
    my $resource_link = $self->c->__path_cons("bugs/$bug_id");
    $self->bug($self->c->get($resource_link));
}

method find_by_link ($resource_link) {
    $self->bug($self->c->get($resource_link));
}

method set_tags ($tags) {
    $self->c->update($self->bug->self_link, {'tags' => $tags});
}

method set_title ($title) {
    $self->c->update($self->bug->self_link, {'title' => $title});
}

method set_assignee ($assignee) {
    $self->c->update($self->bug->tasks->self_link,
        {'assignee_link' => $assignee->self_link});
}

method set_importance ($importance) {
    $self->c->update($self->bug->tasks->self_link,
        {'importance' => $importance});
}

method new_message ($msg) {
    $self->c->post(
        $self->bug->self_link,
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
    my $b = Net::OAuth::LP::Models::Bug->new(c => $c);
    $b->find(1);
    say $b->title;

=head1 ATTRIBUTES

=head2 B<activity>

=head2 B<attachments>

=head2 B<bug>

=head2 B<display_name>

=head2 B<heat>

=head2 B<id>

=head2 B<information_type>

=head2 B<linkedbranches>

=head2 B<name>

=head2 B<owner>

=head2 B<self_link>

=head2 B<tags>

=head2 B<tasks>

=head2 B<title>

=head2 B<watches>

=head2 B<web_link>

=head1 METHODS

=head2 B<new>

    my $b = Net::OAuth::LP::Models::Bug->new;

=head2 B<find>

    $b->find(1);

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
