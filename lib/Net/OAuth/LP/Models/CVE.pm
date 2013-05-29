package Net::OAuth::LP::Models::CVE;

# VERSION

use strictures 1;
use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use List::Objects::WithUtils;
use Data::Dump qw(pp);

with('Net::OAuth::LP::Models');

has 'cves' => (is => 'rw',);

method entries {
  array(@{$self->cves->{entries}});
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::CVE - Bug CVE Model

=head1 DESCRIPTION

Interface to setting/retrieving bug CVE information

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');

    my $b = Net::OAuth::LP::Models::Bug->new(c => $c);
    $b->find(1);
    say $b->cves->all;

=head1 METHODS

=head2 B<new>

    my $cve = Net::OAuth::LP::Models::CVE->new(cves => $bug->CVE);

=head2 B<all>

Returns all CVE results

    say $cve->all;

=cut
