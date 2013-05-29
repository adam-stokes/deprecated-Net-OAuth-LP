package Net::OAuth::LP::Models;

# VERSION

use strictures 1;
use Moo::Role;
use Method::Signatures;

has 'c' => (is => 'rw',);

method find         { }
method find_by_link { }
method filter       { }

method search ($path, $segments) {
    my $query = $self->c->__query_from_hash($segments);
    my $uri = join("?", $path, $query);
    $self->c->get($uri);
}

method resource ($resource_link) {
    $self->c->get($resource_link);
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

=head2 B<find>

Override in extended models.

=head2 B<find_by_link>

Override in extended models.

=head2 B<search>

Performs a search request against the target distribution.

    $lp->search('ubuntu', { 'ws.op' => 'searchTasks',
                            'ws.size' => '10',
                            'status' => 'New' });

=head2 B<resource>

Access resource endpoints directly, however, once API is feature complete
this method shouldn't need to be referenced.

    $lp->resource('launchpad_resource_link');

=cut
