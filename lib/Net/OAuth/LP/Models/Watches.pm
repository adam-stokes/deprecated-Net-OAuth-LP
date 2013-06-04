package Net::OAuth::LP::Models::Watches;

# VERSION

use strictures 1;
use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use List::Objects::WithUtils;

with('Net::OAuth::LP::Models');

has 'watches' => (is => 'rw',);

method entries {
  array(@{$self->watches->entries});
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Watches - Bug Watches Model

=head1 DESCRIPTION

Interface to setting/retrieving bug watches information

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');

    my $b = Net::OAuth::LP::Models::Bug->new(c => $c);
    $b->find(1);
    say $b->watches->all;

=head1 METHODS

In addition to those listed this object inherits methods from List::Objects::WithUtils.

=head2 B<new>

    my $watches = Net::OAuth::LP::Models::Watches->new(watches => $bug->watches);

=cut
