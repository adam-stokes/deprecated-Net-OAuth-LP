#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Bug retrieval");

use_ok 'Net::OAuth::LP::Models::Bug';

my $bug;

if (   defined($ENV{LP_CONSUMER_KEY})
    && defined($ENV{LP_ACCESS_TOKEN})
    && defined($ENV{LP_ACCESS_TOKEN_SECRET}))
{
    $bug = Net::OAuth::LP::Models::Bug->new(
        consumer_key        => $ENV{LP_CONSUMER_KEY},
        access_token        => $ENV{LP_ACCESS_TOKEN},
        access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET},
    );
}
else {
    $bug = Net::OAuth::LP::Models::Bug->new;
}

$bug->staging(1);
$bug->find('859600');

ok($bug->id eq '859600');
ok(defined($bug->title) && ($bug->title =~ m/a title/i), 'verify title');
ok(defined($bug->description));
ok(defined($bug->owner));
ok(defined($bug->tags) && ref($bug->tags) eq "ARRAY");
ok(defined($bug->heat) && $bug->heat >= 0);
ok(ref($bug->attachments) eq "HASH");
ok(ref($bug->tasks) eq "HASH");
ok(ref($bug->activity) eq "HASH");
ok(ref($bug->watches) eq "HASH");
ok(JSON::is_bool($bug->can_expire));

SKIP: {
    skip "No credentials so no POSTing", 1
      unless defined($ENV{LP_ACCESS_TOKEN});
    diag("Testing protected sources");
    my $temptitle = "a title " . time . rand();
    skip "Timeout", 1 if $bug->set_title($temptitle) > 0;
    $bug->find('859600');
    ok($bug->title eq $temptitle, 'verify title setter');
}

done_testing;