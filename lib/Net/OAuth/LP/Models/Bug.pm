package Net::OAuth::LP::Models::Bug;

# VERSION

use Moo;
use Method::Signatures;

with('Net::OAuth::LP::Models');

###################################
# Bug Getters
###################################
method find ($bug_id) {
    my $resource_link = $self->__path_cons("bugs/$bug_id");
    $self->get($resource_link);
}

method bug_task ($resource_link) {
    $self->get($resource_link);
}

method bug_activity ($resource_link) {
    $self->get($resource_link);
}

###################################
# Bug Setters
###################################
method bug_set_tags ($resource, $tags) {
    $self->update($resource->{self_link}, {'tags' => $tags});
}

method bug_set_title ($resource, $title) {
    $self->update($resource->{self_link}, {'title' => $title});
}

method bug_set_assignee ($resource, $assignee) {
    my $bug_task = $self->get($resource->{bug_tasks_collection_link});
    $self->update($bug_task->{self_link},
        {'assignee_link' => $assignee->{self_link}});
}

method bug_set_importance ($resource, $importance) {
    my $bug_task = $self->get($resource->{bug_tasks_collection_link});
    $self->update($bug_task->{self_link}, {'importance' => $importance});
}

method bug_new_message ($resource, $msg) {
    $self->post(
        $resource->{self_link},
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
