use 5.006;
use strict;
use warnings FATAL => 'all';
use inc::Module::Install;

name 'Net-OAuth-LP';
all_from 'lib/Net/OAuth/LP.pm';
author q{=Adam Stokes <adam.stokes@ubuntu.com>};
license 'perl';

perl_version 5.006;

tests_recursive('t');

resources(
    homepage => 'http://astokes.org/Net-OAuth-LP',

    #IRC        => 'irc://irc.perl.org/#Net-OAuth-LP',
    license    => 'http://dev.perl.org/licenses/',
    repository => 'git://github.com/battlemidget/Net-OAuth-LP.git',
    bugtracker => 'https://github.com/battlemidget/Net-OAuth-LP/issues',
);

configure_requires('Module::Install' => 0,);

build_requires('Test::More' => 0,);

requires(
    'Log::Log4perl'         => 0,
    'YAML'                  => 0,
    'JSON'                  => 0,
    'LWP::UserAgent'        => 0,
    'Net::OAuth'            => 0,
    'HTTP::Request::Common' => 0,
    'Browser::Open'         => 0
);

install_as_cpan;
auto_install;
WriteAll;
