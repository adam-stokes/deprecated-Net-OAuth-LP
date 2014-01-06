package Net::OAuth::LP::Model;

use Mojo::Base 'Net::OAuth::LP::Client';

sub search {
    my ($self, $path, $segments) = @_;
    my $query = $self->__query_from_hash($segments);
    my $uri = join("?", $path, $query);
    $self->get($uri);
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Model - Base class for models

=head1 DESCRIPTION

Base Model Role

=head1 METHODS

=head2 B<search>

Performs a search request against the target distribution.

    $modal->search(
        'ubuntu',
        {   'ws.op'   => 'searchTasks',
            'ws.size' => '10',
            'status'  => 'New'
        }
    );

=head1 LICENSE AND COPYRIGHT

Copyright 2013-2014 Adam Stokes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut
