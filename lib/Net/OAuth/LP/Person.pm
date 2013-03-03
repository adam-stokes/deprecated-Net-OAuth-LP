package Net::OAuth::LP::Person;

use Modern::Perl '2013';
use autodie;
use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;
use MooseX::Privacy;
use Net::OAuth::LP::Client;
use Data::Dumper;

extends 'Net::OAuth::LP::Client';

has 'name' => (
    is     => 'rw',
    isa    => 'Str',
    reader => 'get_name',
    writer => 'set_name'
);

has 'display_name' => (
    is     => 'rw',
    isa    => 'Str',
    reader => 'get_display_name',
    writer => 'set_display_name'

);

has 'homepage_content' => (
    is     => 'rw',
    isa    => 'Str',
    reader => 'get_homepage_content',
    writer => 'set_homepage_content'
);

has 'ppas' => (
    is     => 'ro',
    isa    => 'Str',
    reader => 'get_ppas',
);

###########################################################################
# Protected
###########################################################################
sub description {
    my $self = shift;
    $self->get($self->person->{description});
}

protected_method set_description => sub { };

protected_method get_name => sub {
    my $self = shift;
    $self->get($self->person->{name});

};
protected_method set_name => sub { };
protected_method get_display_name => sub {
    my $self = shift;
    $self->get($self->person->{display_name});

};
protected_method set_display_name => sub { };
protected_method get_homepage_content => sub {
    my $self = shift;
    $self->get($self->person->{homepage_content});

};
protected_method set_homepage_content => sub { };

###########################################################################
# Public methods
###########################################################################
sub person {
    my $self  = shift;
    my $p_str = shift;
    $self->get('~' . $p_str);
}

=head1 NAME

Net::OAuth::LP::Person - Launchpad.net Person Entity

=head1 SYNOPSIS

Person representation

    my $person = Net::OAuth::LP::Person->new(person => $person_resource);

=head1 METHODS

    Nothing public but the accessors.

=cut

__PACKAGE__->meta->make_immutable;
1;    # End of Net::OAuth::LP::Person
