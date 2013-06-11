package Net::OAuth::LP::Models::Attachments;

# VERSION

use strictures 1;
use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use List::Objects::WithUtils;

with('Net::OAuth::LP::Models');

has 'attachments' => (is => 'rw',);

method entries {
  array(@{$self->attachments->entries});
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Attachments - Bug Attachments Model

=head1 DESCRIPTION

Interface to setting/retrieving bug attachments information

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');

    my $b = Net::OAuth::LP::Models::Bug->new(c => $c);
    $b->find(1);
    say $b->attachments->all;

=head1 ATTRIBUTES

=head2 B<attachments>

=head1 METHODS

=head2 B<new>

    my $attachments = Net::OAuth::LP::Models::Attachments->new(attachments => $bug->attachments);

=head2 B<all>

Returns all attachments results

    say $attachments->all;

=cut
