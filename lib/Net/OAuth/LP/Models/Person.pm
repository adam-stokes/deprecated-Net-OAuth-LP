package Net::OAuth::LP::Models::Person;

# VERSION

use Moo;
use Method::Signatures;

with('Net::OAuth::LP::Models');

method find ($name) {
    $self->get($name);
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

=head2 B<query>

Queries a person or team resource.

    $p->query('~launchpad-user-or-team');

=cut
