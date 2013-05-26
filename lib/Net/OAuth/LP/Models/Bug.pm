package Net::OAuth::LP::Models::Bug;

# VERSION

use Moo;
use Method::Signatures;

with('Net::OAuth::LP::Models');

has 'bug' => (
    is      => 'rw',
    isa     => method {},
    lazy    => 1,
    default => method { {} },
);

has 'tasks' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->get($self->bug->{bug_tasks_collection_link});
    }
);

has 'activity' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->get($self->bug->{activity_collection_link});
    },
);

has 'attachments' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->get($self->bug->{attachments_collection_link});
    },
);

has 'watches' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->get($self->bug->{bug_watches_collection_link});
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
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->get($self->bug->{cves_collection_link});
    },
);

has 'description' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{description};
    },
);

has 'heat' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{heat};
    },
);

has 'information_type' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{information_type};
    },
);

has 'branches' => (
    is => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        self->get($self->bug->{linked_branches_collection_link});
    },
);

has 'owner' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->get($self->bug->{owner_link});
    },
);

has 'title' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{title};
    },
);

has 'tags' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{tags};
    },
);

has 'id' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{id};
    },
);

has 'web_link' => (
    is      => 'ro',
    isa     => method {},
    lazy    => 1,
    default => method {
        $self->bug->{web_link};
    },
);

method find ($bug_id) {
    my $resource_link = $self->__path_cons("bugs/$bug_id");
    $self->bug($self->get($resource_link));
}

method set_tags ($tags) {
    $self->update($self->bug->{self_link}, {'tags' => $tags});
}

method set_title ($title) {
    $self->update($self->bug->{self_link}, {'title' => $title});
}

method set_assignee ($assignee) {
    $self->update($self->bug->tasks->{self_link},
        {'assignee_link' => $assignee->{self_link}});
}

method set_importance ($importance) {
    $self->update($self->bug->tasks->{self_link}, {'importance' => $importance});
}

method new_message ($msg) {
    $self->post(
        $self->bug->{self_link},
        {   'ws.op'   => 'newMessage',
            'content' => $msg
        }
    );
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Bug

=head1 DESCRIPTION

Bug Model

=head1 METHODS

=head2 B<new>

    my $b = Net::OAuth::LP::Models::Bug->new;


=head2 B<find>

    my $bug = $b->find(1);

=head2 B<bug_set_tags>

    $lp->bug_set_tags($bug, ['tagA', 'tagB']);

=head2 B<bug_set_title>

Set title(aka summary) of bug

    $lp->bug_set_title($bug, 'A new title');

=head2 B<bug_new_message>

Adds a new message to the bug.

    $lp->bug_new_message($bug, "This is a comment");

=head2 B<bug_activity>

Views bug activity

    $lp->bug_activity($resource_link);

=head2 B<bug_task>

View bug tasks

    $lp->bug_task($resource);

=head2 B<bug_set_importance>

Sets priority ['Critical', 'High', 'Medium', 'Low']

    $lp->bug_set_importance($bug, 'Critical');

=head2 B<bug_set_assignee>

Sets the assignee of bug.

    my $person = $lp->person('~adam-stokes');
    $lp->bug_set_assignee($bug, $person);

=cut
