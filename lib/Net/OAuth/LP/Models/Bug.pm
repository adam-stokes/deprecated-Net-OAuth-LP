package Net::OAuth::LP::Models::Bug;

# VERSION

use Net::OAuth::LP::Models::Tasks;

use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;

with('Net::OAuth::LP::Models');

has 'bug' => (
    is      => 'rw',
    isa     => HashRef,
    lazy    => 1,
    default => method { {} },
);

has 'tasks' => (
    is      => 'ro',
    lazy    => 1,
    default => method {
        Net::OAuth::LP::Models::Tasks->new(
            c     => $self->c,
            tasks => $self->c->get($self->bug->{bug_tasks_collection_link})
        );
    }
);

has 'activity' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->c->get($self->bug->{activity_collection_link});
    },
);

has 'attachments' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->c->get($self->bug->{attachments_collection_link});
    },
);

has 'watches' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->c->get($self->bug->{bug_watches_collection_link});
    },
);

has 'can_expire' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{can_expire};
    },
);

has 'cves' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->c->get($self->bug->{cves_collection_link});
    },
);

has 'description' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->bug->{description};
    },
);

has 'heat' => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => method {
        $self->bug->{heat};
    },
);

has 'information_type' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->bug->{information_type};
    },
);

has 'branches' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        self->c->get($self->bug->{linked_branches_collection_link});
    },
);

has 'owner' => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    default => method {
        $self->c->get($self->bug->{owner_link});
    },
);

has 'title' => (
    is      => 'rw',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->bug->{title};
    },
);

has 'tags' => (
    is      => 'ro',
    isa     => ArrayRef,
    lazy    => 1,
    default => method {
        $self->bug->{tags};
    },
);

has 'id' => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => method {
        $self->bug->{id};
    },
);

has 'web_link' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->bug->{web_link};
    },
);

has 'self_link' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => method {
        $self->bug->{self_link};
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
    $self->c->update($self->self_link, {'tags' => $tags});
}

method set_title ($title) {
    $self->c->update($self->self_link, {'title' => $title});
}

method set_assignee ($assignee) {
    $self->c->update($self->bug->tasks->{self_link},
        {'assignee_link' => $assignee->self_link});
}

method set_importance ($importance) {
    $self->c->update($self->bug->tasks->{self_link},
        {'importance' => $importance});
}

method new_message ($msg) {
    $self->c->post(
        $self->self_link,
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
    say $b->description;

=head1 ATTRIBUTES

=head2 B<activity>

=head2 B<attachments>

=head2 B<branches>

=head2 B<bug>

=head2 B<display_name>

=head2 B<heat>

=head2 B<id>

=head2 B<information_type>

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
