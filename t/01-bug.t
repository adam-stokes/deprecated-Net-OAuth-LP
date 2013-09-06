#!perl -T
use common::sense;
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
my $bug = Net::OAuth::LP::Models::Bug->new(c => $c, resource => '859600');
$bug->fetch;

ok($bug->attrs->id eq '859600');
ok(defined($bug->attrs->title) && ($bug->attrs->title =~ m/Please convert gnome-keyring to multiarch/i), 'verify title');
ok(defined($bug->attrs->description));
ok(defined($bug->attrs->tags) && ref($bug->attrs->tags) eq "ARRAY");
ok(defined($bug->attrs->heat) && $bug->attrs->heat >= 0);
ok(defined($bug->owner));
ok(ref($bug->messages) eq "Net::OAuth::LP::Models::Messages");
ok(ref($bug->attachments) eq "Net::OAuth::LP::Models::Attachments");
ok(ref($bug->activity) eq "Net::OAuth::LP::Models::Activity");
ok(ref($bug->watches) eq "Net::OAuth::LP::Models::Watches");
ok(ref($bug->linkedbranches) eq "Net::OAuth::LP::Models::Linkedbranches");
ok(ref($bug->cves) eq "Net::OAuth::LP::Models::CVE");
ok(JSON::is_bool($bug->attrs->can_expire));

SKIP: {
    skip "No credentials so no POSTing", 1
      unless defined($ENV{LP_ACCESS_TOKEN});
    diag("Testing protected sources");
    my $temptitle = "a title " . time . rand();
    skip "Timeout", 1 if $bug->set_title($temptitle) > 0;
    $bug->fetch;
    ok($bug->attrs->title eq $temptitle, 'verify title setter');
}

done_testing();
