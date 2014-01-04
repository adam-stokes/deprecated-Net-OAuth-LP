package Net::OAuth::LP::Model::Bug;

use Mojo::Base 'Net::OAuth::LP::Model';

has 'bug';

sub by_id {
    my ($self, $id) = @_;
    $self->bug($self->get(sprintf("%s/bugs/%s", $self->api_url, $id)));
}

sub id {
    my $self = shift;
    return $self->bug->{id};
}

sub tasks {
    my $self = shift;
    return $self->get($self->bug->{bug_tasks_collection_link});
}

sub description {
    my $self = shift;
    return $self->bug->{description};
}

sub title {
    my $self = shift;
    return $self->bug->{title};
}

sub heat {
    my $self = shift;
    return $self->bug->{heat};
}

sub information_type {
    my $self = shift;
    return $self->bug->{information_type};
}

sub message_count {
    my $self = shift;
    return $self->bug->{message_count};
}

sub messages {
    my $self = shift;
    return $self->get($self->bug->{messages_collection_link});
}

sub tags {
    my $self = shift;
    return $self->bug->{tags};
}

sub owner {
    my $self = shift;
    return $self->get($self->bug->{owner_link});
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Model::Bug - Launchpad.net bug Interface

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new;
    $c->staging(1);

    my $bug = $c->namespace('Bug')->by_id(3);

    say "Title: ". $bug->title;
    say "Desc:  ". $bug->description;
    say "Heat:  ". $bug->heat;

=head1 DESCRIPTION

Bug model for Launchpad.net Bugs.

=head1 ATTRIBUTES

=head2 bug

Bug object.

=head1 METHODS

=head2 by_id

This needs to be called before any of the below methods. Takes a Bug ID number.

=head2 id

Returns bug number.

=head2 title

Returns title of bug.

=head2 tasks

Returns a list of entries in the tasks object.

=head2 owner

Returns creator of bug

=head2 messages

Returns bug messages associated with Bug.

=head2 message_count

Returns message count

=head2 heat

Returns heat/importance of bug

=head2 description

Returns bug description

=head2 information_type

Returns whether this bug is a public/private issue.

=head2 tags

Returns a list of Tags associated with bug.

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
