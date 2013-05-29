package Net::OAuth::LP::Models::Messages;

# VERSION

use strictures 1;
use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use List::Objects::WithUtils;
use Data::Dump qw(pp);

with('Net::OAuth::LP::Models');

has 'messages' => (is => 'rw',);

method entries {
  array(@{$self->messages->{entries}});
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Messages - Bug Messages Model

=head1 DESCRIPTION

Interface to setting/retrieving bug messages information

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');

    my $b = Net::OAuth::LP::Models::Bug->new(c => $c);
    $b->find(1);
    say $b->messages->all;

=head1 METHODS

In addition to those listed this object inherits methods from List::Objects::WithUtils.

=head2 B<new>

    my $messages = Net::OAuth::LP::Models::Messages->new(messages => $bug->messages);

=cut
