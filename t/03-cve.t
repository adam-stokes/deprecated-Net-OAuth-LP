#!perl -T
use strict;
use warnings;
use Test::More;
use Test::Mojo;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP CVE methods");

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

my $cve = $model->namespace('CVE')->by_sequence('2011-3188');
ok(defined($cve->title) && $cve->title =~ m/CVE-2011-3188/i);
ok(defined($cve->display_name));
ok(defined($cve->description));
ok(defined($cve->date_created));
ok(defined($cve->date_modified));
ok(defined($cve->status));
ok(defined($cve->url));

done_testing();
