package Net::OAuth::LP::Model;

use Mojo::Base 'Net::OAuth::LP::Client';

sub search {
    my ($self, $path, $segments) = @_;
    my $query = $self->c->__query_from_hash($segments);
    my $uri = join("?", $path, $query);
    $self->get($uri);
}

sub get_bug {
  my ($self, $resource) = @_;
  $self->get($self->api_url . "/bugs/" . $resource);
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
