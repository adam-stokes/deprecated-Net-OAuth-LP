#!perl -T
use strict;
use warnings FATAL => 'all';
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
my $model = Net::OAuth::LP::Models::Person->new(c => $c);
$model->find('~adam-stokes');

ok($model->person->name eq 'adam-stokes');
ok(defined($model->person->karma) && $model->person->karma >= '0');
ok($model->person->display_name);

SKIP: {
    skip "No credentials so no POSTing", 2
      unless defined($ENV{LP_ACCESS_TOKEN});
    diag("Testing protected sources");
    my $randomname = "me-".rand();
    ok($model->set_display_name($randomname));
    ok($model->set_description('woooooooooooo'.rand()));
}


done_testing;
