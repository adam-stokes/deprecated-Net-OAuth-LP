#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Bug retrieval");

use_ok 'Net::OAuth::LP::Models::Bug';

my $client;

if (   defined($ENV{LP_CONSUMER_KEY})
    && defined($ENV{LP_ACCESS_TOKEN})
    && defined($ENV{LP_ACCESS_TOKEN_SECRET}))
{
    $client = Net::OAuth::LP::Models::Bug->new(
        consumer_key        => $ENV{LP_CONSUMER_KEY},
        access_token        => $ENV{LP_ACCESS_TOKEN},
        access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET},
    );
}
else {
    $client = Net::OAuth::LP::Models::Bug->new;
}

$client->staging(1);
my $bug = $client;
$bug->find('859600');

ok($bug->id eq '859600');
ok(defined($bug->title) && ($bug->title =~ m/a title/i), 'verify title');
ok(defined($bug->description));
ok(defined($bug->owner));
ok(defined($bug->tags) && ref($bug->tags) eq "ARRAY");
ok(defined($bug->heat) && $bug->heat >= 0);

SKIP: {
    skip "No credentials so no POSTing", 1
      unless defined($ENV{LP_ACCESS_TOKEN});
    diag("Testing protected sources");
    my $temptitle = "a title " . time . rand();
    skip "Timeout", 1 if $client->bug_set_title($bug, $temptitle) > 0;
    $bug = $client->find('859600');
    ok($bug->{title} eq $temptitle, 'verify title setter');
}

done_testing;
