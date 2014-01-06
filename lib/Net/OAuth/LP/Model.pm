package Net::OAuth::LP::Model;

use Mojo::Base 'Net::OAuth::LP::Client';
use Class::Load ':all';

sub namespace {
    my ($self, $name) = @_;
    my $model = "Net::OAuth::LP::Model::$name";
    return load_class($model)->new($self);
}

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

=head2 B<namespace>

    $model->namespace('Bug');

Sets model namespace of the Launchpad interface you want to
use. E.g. 'Bug' for bugs and 'Person' for person model.


=head2 B<search>

Performs a search request against the target distribution.

    $modal->search(
        'ubuntu',
        {   'ws.op'   => 'searchTasks',
            'ws.size' => '10',
            'status'  => 'New'
        }
    );

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
