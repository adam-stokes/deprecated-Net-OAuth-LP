package Net::OAuth::LP::Model::Person;

use Mojo::Base 'Net::OAuth::LP::Model';

sub by_name {
    my ($self, $name) = @_;
    $self->get(sprintf("%s/%s", $self->api_url, $name));
}


1;
