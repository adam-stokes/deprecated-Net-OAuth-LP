package Net::OAuth::LP::Models;

# VERSION

use Moo::Role;
use Method::Signatures;

with('Net::OAuth::LP::Client');

method find         { }
method find_by_link { }

method search ($path, $segments) {
    my $query = $self->__query_from_hash($segments);
    my $uri = join("?", $path, $query);
    $self->get($uri);
}

method resource ($resource_link) {
    $self->get($resource_link);
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models - Base class for models

=head1 DESCRIPTION

Base Model Role

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