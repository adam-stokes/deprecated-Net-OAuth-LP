package Net::OAuth::LP::Model::Bug;

use Mojo::Base 'Net::OAuth::LP::Model';

sub by_id {
    my ($self, $id) = @_;
    $self->get(sprintf("%s/bugs/%s", $self->api_url, $id));
}


1;
