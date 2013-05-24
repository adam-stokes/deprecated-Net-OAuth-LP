package Net::OAuth::LP::Models;

# VERSION

use Moo::Role;
use Method::Signatures;

with('Net::OAuth::LP::Client');

method filter($criteria) {}

method find {}

method first {}

method all {}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models

=head1 DESCRIPTION

Base Model Role

=cut
