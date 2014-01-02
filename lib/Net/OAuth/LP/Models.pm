package Net::OAuth::LP::Models;

use strict;
use warnings;
use Moo::Role;
use Method::Signatures;

has 'c' => (is => 'rw',);

method fetch         { }
method fetch_by_link { }

method search ($path, $segments) {
    my $query = $self->c->__query_from_hash($segments);
    my $uri = join("?", $path, $query);
    $self->c->get($uri);
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models - Base class for models

=head1 DESCRIPTION

Base Model Role

=head1 ATTRIBUTES

=head2 B<c>

Client attribute to perform authenticated requests.

=head1 METHODS

=head2 B<fetch>

Override in extended models to get a resource by item.

=head2 B<fetch_by_link>

Override in extended models to get a resource by resource link.

=head2 B<search>

Performs a search request against the target distribution.

    $modal->search(
        'ubuntu',
        {   'ws.op'   => 'searchTasks',
            'ws.size' => '10',
            'status'  => 'New'
        }
    );

=cut
