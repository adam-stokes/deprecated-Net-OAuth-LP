package Net::OAuth::LP::Archive;

use Modern::Perl '2013';
use autodie;
use Data::Dumper;
use Moose;
use MooseX::Privacy;
use MooseX::StrictConstructor;
use Net::OAuth::LP::Client;
use URI;
use namespace::autoclean;

extends 'Net::OAuth::LP::Client';

has distro => (
    is      => 'ro',
    isa     => 'Str',
    default => 'ubuntu'
);

has archive_name => (
    is      => 'ro',
    isa     => 'Str',
    default => 'primary'
);

###############################################################################
# Protected
###############################################################################
protected_method _archive_path_cons => sub {
    my $self          = shift;
    my $_distro       = shift;
    my $_archive_name = shift;

    URI->new($self->api_url . "/$_distro/+archive/$_archive_name", 'https');
};

###############################################################################
# Public methods
###############################################################################
sub archive {
    my $self = shift;
    my $_cons =$self->_archive_path_cons($self->distro, $self->archive_name); 
    say Dumper($_cons);
    $self->get($_cons);
}

=head1 NAME

Net::OAuth::LP::Archive - Launchpad.net Archive Entity

=head1 SYNOPSIS

Person representation

    my $query = Net::OAuth::LP::Archive->new;
    $query->archive;

=head1 METHODS

    info

=cut

__PACKAGE__->meta->make_immutable;
1;                                              # End of Net::OAuth::LP::Archive
