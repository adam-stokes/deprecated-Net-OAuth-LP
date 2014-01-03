package Net::OAuth::LP::Model::Bug;

use Mojo::Base 'Net::OAuth::LP::Model';
use DDP;

sub bug_id {
    my ($self, $id) = @_;
    p $self;
    $self->get(sprintf("%s/bugs/%s", $self->api_url, $id));
}


1;
