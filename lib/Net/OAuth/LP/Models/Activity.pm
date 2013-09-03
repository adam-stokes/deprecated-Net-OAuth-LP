package Net::OAuth::LP::Models::Activity;

use strictures 1;
use Moo;
use Types::Standard qw(Str Int ArrayRef HashRef);
use Method::Signatures;
use List::Objects::WithUtils;

with('Net::OAuth::LP::Models');

has 'activity' => (is => 'rw',);

method entries {
  array(@{$self->activity->entries});
}

1;

__END__

=head1 NAME

Net::OAuth::LP::Models::Activity - Bug Activity Model

=head1 DESCRIPTION

Interface to setting/retrieving bug activity information

=head1 SYNOPSIS

    my $c = Net::OAuth::LP::Client->new(consumer_key => 'blah',
                                        access_token => 'fdsafsda',
                                        access_token_secret => 'fdsafsda');

    my $b = Net::OAuth::LP::Models::Bug->new(c => $c);
    $b->find(1);
    say $b->activity->all;

=head1 ATTRIBUTES

=head2 B<activity>

=head1 METHODS

=head2 B<new>

    my $activity = Net::OAuth::LP::Models::Activity->new(activity => $bug->activity);

=head2 B<all>

Returns all activity results

    say $activity->all;

=cut
