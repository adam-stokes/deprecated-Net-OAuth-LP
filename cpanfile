requires 'Net::OAuth';
requires 'URI';
requires 'URI::Encode';
requires 'URI::QueryParam';
requires 'IO::Socket::SSL';
requires 'Mojolicious';
requires 'Class::Load';

on build => sub {
    requires 'Test::More';
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
};

on test => sub {
    requires 'indirect';
    requires 'multidimensional';
    requires 'bareword::filehandles';
};


