#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP Bug methods");

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
my $o = Net::OAuth::LP::Models::Bug->new(c => $c);
$o->find('859600');

ok($o->bug->id eq '859600');
ok(defined($o->bug->title) && ($o->bug->title =~ m/a title/i), 'verify title');
ok(defined($o->bug->description));
ok(defined($o->owner));
ok(defined($o->bug->tags) && ref($o->bug->tags) eq "ARRAY");
ok(defined($o->bug->heat) && $o->bug->heat >= 0);
ok(ref($o->messages) eq "Net::OAuth::LP::Models::Messages");
ok(ref($o->attachments) eq "Net::OAuth::LP::Models::Attachments");
ok(ref($o->activity) eq "Net::OAuth::LP::Models::Activity");
ok(ref($o->watches) eq "Net::OAuth::LP::Models::Watches");
ok(ref($o->linkedbranches) eq "Net::OAuth::LP::Models::Linkedbranches");
ok(ref($o->cves) eq "Net::OAuth::LP::Models::CVE");
ok(JSON::is_bool($o->bug->can_expire));

SKIP: {
    skip "No credentials so no POSTing", 1
      unless defined($ENV{LP_ACCESS_TOKEN});
    diag("Testing protected sources");
    my $temptitle = "a title " . time . rand();
    skip "Timeout", 1 if $o->bug->set_title($temptitle) > 0;
    $o->bug->find('859600');
    ok($o->bug->title eq $temptitle, 'verify title setter');
}

done_testing;
