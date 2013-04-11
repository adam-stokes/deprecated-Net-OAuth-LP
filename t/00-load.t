#!perl -T
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

    # Only handle authenticated tests if we have proper credentials
    if (-e catfile($ENV{HOME}, "/.lp-auth.yml")) {
        my $cfg = LoadFile catfile($ENV{HOME}, "/.lp-auth.yml");
        ok(ref($cfg) eq "HASH", "Config read works");
        use_ok('Net::OAuth::LP::Client') || print "Bail out!\n";

        my $lpc = Net::OAuth::LP::Client->new;

        ok(defined($lpc), 'Client new() works');

    }
}

diag( "Testing Net::OAuth::LP $Net::OAuth::LP::VERSION, Perl $], $^X" );
done_testing();
