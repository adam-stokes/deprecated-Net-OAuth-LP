#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Watches methods");

use_ok 'Net::OAuth::LP::Client';
use_ok 'Net::OAuth::LP::Models::Bug';

my $c;

if (   defined($ENV{LP_CONSUMER_KEY})
    && defined($ENV{LP_ACCESS_TOKEN})
    && defined($ENV{LP_ACCESS_TOKEN_SECRET}))

{
    $c = Net::OAuth::LP::Client->new(
        consumer_key        => $ENV{LP_CONSUMER_KEY},
        access_token        => $ENV{LP_ACCESS_TOKEN},
        access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET},
    );
}
else {
    $c = Net::OAuth::LP::Client->new;
}

$c->staging(1);
my $bug = Net::OAuth::LP::Models::Bug->new(c => $c);
$bug->find('859600');
foreach ($bug->watches->entries->all) {
    ok(defined($_->{remote_bug}));
}

done_testing;
