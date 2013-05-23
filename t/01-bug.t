#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Bug retrieval");

use_ok 'Net::OAuth::LP::Client';

ok(defined($ENV{LP_CONSUMER_KEY}), 'found consumer key')
  || BAIL_OUT("consumer key is required.");
ok(defined($ENV{LP_ACCESS_TOKEN}), 'found access token')
  || BAIL_OUT("access token is required.");
ok(defined($ENV{LP_ACCESS_TOKEN_SECRET}), 'found access token secret')
  || BAIL_OUT("access token secret required.");

my $client = Net::OAuth::LP::Client->new(
    consumer_key        => $ENV{LP_CONSUMER_KEY},
    access_token        => $ENV{LP_ACCESS_TOKEN},
    access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET},
);

$client->staging(1);
my $bug = $client->bug('859600');

ok($bug->{id} eq '859600');
ok(defined($bug->{title}));
ok(defined($bug->{description}));
ok(defined($bug->{owner_link}));
ok(defined($bug->{tags}));
ok(defined($bug->{heat}) && $bug->{heat} >= 0);

my $temptitle = "a title " . time . rand();
$client->bug_set_title($bug, $temptitle);
$bug = $client->bug('859600');
ok($bug->{title} eq $temptitle);

done_testing;
