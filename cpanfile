requires 'Browser::Open';
requires 'HTTP::Request';
requires 'HTTP::Request::Common';
requires 'JSON';
requires 'LWP::UserAgent';
requires 'Log::Log4perl';
requires 'Modern::Perl';
requires 'Moose';
requires 'Moose::Util::TypeConstraints';
requires 'MooseX::Privacy';
requires 'MooseX::StrictConstructor';
requires 'Net::OAuth';
requires 'URI';
requires 'URI::Encode';
requires 'URI::QueryParam';
requires 'YAML';
requires 'autodie';
requires 'namespace::autoclean';

on configure => sub {
    requires 'inc::Module::Install';
};

on test => sub {
    requires 'Test::More';
    requires 'perl', '5.006';
};
