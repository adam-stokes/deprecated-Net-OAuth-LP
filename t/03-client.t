#!perl -T
use strictures 1;
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing
diag("Testing LP General Client methods");

use_ok 'Net::OAuth::LP::Client';

done_testing;
