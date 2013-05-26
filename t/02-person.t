#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Person/Team retrieval");

use_ok 'Net::OAuth::LP::Models::Person';

my $person;

if (   defined($ENV{LP_CONSUMER_KEY})
    && defined($ENV{LP_ACCESS_TOKEN})
    && defined($ENV{LP_ACCESS_TOKEN_SECRET}))
{
    $person = Net::OAuth::LP::Models::Person->new(
        consumer_key        => $ENV{LP_CONSUMER_KEY},
        access_token        => $ENV{LP_ACCESS_TOKEN},
        access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET},
    );
}
else {
    $person = Net::OAuth::LP::Models::Person->new;
}

$person->staging(1);
$person->find('~adam-stokes');

ok($person->name eq 'adam-stokes');
ok($person->karma >= '1');
ok($person->display_name);

done_testing;
