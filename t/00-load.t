#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing

use_ok 'Net::OAuth::LP';
use_ok 'Net::OAuth::LP::Client';

done_testing;
