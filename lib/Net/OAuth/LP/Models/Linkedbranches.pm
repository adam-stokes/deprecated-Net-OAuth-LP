package Net::OAuth::LP::Models::Linkedbranches;

# VERSION

use strictures 1;
use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use List::Objects::WithUtils;
use Data::Dump qw(pp);

with('Net::OAuth::LP::Models');

has 'linkedbranches' => (is => 'rw',);

method entries {
  array(@{$self->linkedbranches->{entries}});
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Linkedbranches - Bug Linkedbranches Model

=head1 DESCRIPTION

Interface to setting/retrieving bug linkedbranches information

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');

    my $b = Net::OAuth::LP::Models::Bug->new(c => $c);
    $b->find(1);
    say $b->linkedbranches->all;

=head1 METHODS

=head2 B<new>

    my $linkedbranches = Net::OAuth::LP::Models::Linkedbranches->new(linkedbranches => $bug->linkedbranches);

=head2 B<all>

Returns all linkedbranches results

    say $linkedbranches->all;

=cut
