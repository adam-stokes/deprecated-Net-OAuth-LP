#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Person/Team retrieval");

use_ok 'Net::OAuth::LP::Models::Person';

my $client;

if (   defined($ENV{LP_CONSUMER_KEY})
    && defined($ENV{LP_ACCESS_TOKEN})
    && defined($ENV{LP_ACCESS_TOKEN_SECRET}))
{
    $client = Net::OAuth::LP::Models::Person->new(
        consumer_key        => $ENV{LP_CONSUMER_KEY},
        access_token        => $ENV{LP_ACCESS_TOKEN},
        access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET},
    );
}
else {
    $client = Net::OAuth::LP::Models::Person->new;
}

$client->staging(1);
my $person = $client->find('~adam-stokes');

ok($person->{name} eq 'adam-stokes');
ok($person->{karma} >= '1');
ok($person->{is_ubuntu_coc_signer});
ok($person->{is_valid});

done_testing;
