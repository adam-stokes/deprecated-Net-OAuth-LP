#!perl -T
use common::sense;
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Person,Team methods");

use_ok 'Net::OAuth::LP::Client';
use_ok 'Net::OAuth::LP::Models::Person';

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
my $person = Net::OAuth::LP::Models::Person->new(c => $c, resource => '~adam-stokes');
$person->fetch;

ok($person->attrs->name eq 'adam-stokes');
ok(defined($person->attrs->karma) && $person->attrs->karma >= '0');
ok($person->attrs->display_name);

SKIP: {
    skip "No credentials so no POSTing", 2
      unless defined($ENV{LP_ACCESS_TOKEN});
    diag("Testing protected sources");
    my $randomname = "me-".rand();
    ok($person->set_display_name($randomname));
    ok($person->set_description('woooooooooooo'.rand()));
}

done_testing();
