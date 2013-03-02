#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use YAML qw[LoadFile];
use File::Spec::Functions;
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing

BEGIN {
    use_ok('Net::OAuth::LP') || print "Bail out!\n";
    my $lp = Net::OAuth::LP->new;
    ok(defined($lp), 'new() works');
    ok($lp->consumer_key('mykey') && $lp->consumer_key eq 'mykey',
        'consumer_key attr set/get ok');

    # Only handle authenticated tests if we have proper credentials
    if (-e catfile($ENV{HOME}, "/.lp-auth.yml")) {
        my $cfg = LoadFile catfile($ENV{HOME}, "/.lp-auth.yml");
        ok(ref($cfg) eq "HASH", "Config read works");
        use_ok('Net::OAuth::LP::Client') || print "Bail out!\n";

        my $lpc = Net::OAuth::LP::Client->new($cfg->{consumer_key},
            $cfg->{access_token}, $cfg->{access_token_secret});

        ok(defined($lpc), 'Client new() works');

        my ($prj, $err, $ret) = $lpc->project('ubuntu');
        ok(ref($prj) eq "HASH",  "got HASH project works");
        ok(exists $prj->{title}, "got project title");

        (my $person, $err, $ret) = $lpc->me('adam-stokes');
        ok(ref($person) eq "HASH", "got HASH Person");
        ok(exists $person->{name}, "got person name");
        is($person->{name}, 'adam-stokes', "got correct name");
    }
}

diag( "Testing Net::OAuth::LP $Net::OAuth::LP::VERSION, Perl $], $^X" );
done_testing();
