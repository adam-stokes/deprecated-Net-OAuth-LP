#!perl -T
use strict;
use warnings;
use Test::More;
use Test::Mojo;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Person,Team methods");

use_ok 'Net::OAuth::LP::Client';
use_ok 'Net::OAuth::LP::Model';

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
my $model = Net::OAuth::LP::Model->new($c);

my $person = $model->namespace('Person')->by_name('~adam-stokes');

ok($person->name eq 'adam-stokes');
ok(defined($person->karma) && $person->karma >= '0');
ok(defined($person->display_name));
ok(defined($person->description));
ok(defined($person->date_created));
ok(defined($person->gpg_keys));
ok(defined($person->irc_nicks));
ok(defined($person->is_team));
ok(defined($person->is_ubuntu_coc_signer));
ok(defined($person->is_valid));
ok(defined($person->ppas) && ref($person->ppas) eq "ARRAY");
ok(defined($person->private));
ok(defined($person->source_recipes));
ok(defined($person->ssh_keys) && ref($person->ssh_keys) eq "ARRAY");
ok(defined($person->time_zone) || !defined($person->time_zone));
ok(defined($person->web_link));

# SKIP: {
#     skip "No credentials so no POSTing", 2
#       unless defined($ENV{LP_ACCESS_TOKEN});
#     diag("Testing protected sources");
#     my $randomname = "me-".rand();
#     ok($person->set_display_name($randomname));
#     ok($person->set_description('woooooooooooo'.rand()));
# }

done_testing();
