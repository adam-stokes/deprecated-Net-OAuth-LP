package Net::OAuth::LP::Models::Tasks;

# VERSION

use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;

with('Net::OAuth::LP::Models');

has 'tasks' => (
    is      => 'rw',
);

method all {
  $self->tasks->{entries};
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Tasks - Bug Tasks Model

=head1 DESCRIPTION

Interface to setting/retrieving bug tasks information

=head1 SYNOPSIS

    my $tasks = Net::OAuth::LP::Models::Tasks->new(tasks => $b->tasks);
    say $tasks->all;

=head1 METHODS

=head2 B<new>

    my $tasks = Net::OAuth::LP::Models::Tasks->new(tasks => $bug->tasks);

=head2 B<all>

Returns all tasks results

    say $tasks->all;

=cut
