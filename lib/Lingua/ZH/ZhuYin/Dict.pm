package Lingua::ZH::ZhuYin::Dict;

use warnings;
use strict;

=head1 NAME

Lingua::ZH::ZhuYin::Dict - The backend dictionary for converting zhuyin

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use DBI qw(:sql_types);
use DBD::SQLite;

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Lingua::ZH::ZhuYin::Dict;

    my $zhuyin = Lingua::ZH::ZhuYin::Dict::QueryZuyin($word);
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 new

=cut

sub new {
    my $class = shift;
    my $dictFile = shift || 'moedict.db';
    my $self = {
	dictFile = $dictFile,
	dbh => undef,
    };
    if ( -f $dictFile ) {
	my $dsn = "dbi:SQLite:dbname=$dictFile";
	$self->{dbh} = DBI->connect($dsn, "","");
    }
    bless ($self, $class);
    return($self);
}

=head2 QueryZhuyin

=cut

sub QueryZhuyin {
    my $self = shift;
    my $word = shift;

    return unless $self->{dbh};

    my @zhuyins;
    my $sth = $self->{dbh}->prepare("SELECT zhuyin from moedict WHERE word = ?");
    $sth->execute($word) || die DBI::err.": ".$DBI::errstr;
    while (my $hash_ref = $sth->fetchrow_hashref) {
	push @zhuyins, $hash_ref->{zhuyin};
    }
    return @zhuyins;
}

=head1 AUTHOR

Cheng-Lung Sung, C<< <clsung at cpan.org> >>

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Cheng-Lung Sung, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Lingua::ZH::ZhuYin::Dict
