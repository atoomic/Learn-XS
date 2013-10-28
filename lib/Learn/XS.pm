package Learn::XS;
use strict;
use warnings;
use base Exporter::;
our @EXPORT = qw(xsort ixsort sxsort);

our $VERSION = '0.10';

use v5.14;

require XSLoader;
XSLoader::load( 'Learn::XS', $VERSION );

use Carp qw/croak/;
use Devel::Peek qw/Dump/;

test() unless caller();

sub test {
	my $i = Learn::XS::simple_integer(42);
	say $i;
	Dump($i);
	
	
	Learn::XS::dual();
	
	our $myerror;
	warn $myerror;
	#warn $main::myerror;
	warn $Learn::XS::myerror;
	
	
	return;
}

=pod
use constant ERR_MSG_NOLIST           => 'Need to provide a list';
use constant ERR_MSG_UNKNOWN_ALGO     => 'Unknown algorithm : ';
use constant ERR_MSG_NUMBER_ARGUMENTS => 'Bad number of arguments';

my $_mapping = {
    quick     => \&Sort::XS::quick_sort,
    heap      => \&Sort::XS::heap_sort,
    merge     => \&Sort::XS::merge_sort,
    insertion => \&Sort::XS::insertion_sort,
    perl      => \&_perl_sort,

    # string sorting
    quick_str     => \&Sort::XS::quick_sort_str,
    heap_str      => \&Sort::XS::heap_sort_str,
    merge_str     => \&Sort::XS::merge_sort_str,
    insertion_str => \&Sort::XS::insertion_sort_str,
    perl_str      => \&_perl_sort_str,
};
=cut



1;

__END__

=head1 NAME

Learn::XS - learn XS by sample

=head1 SYNOPSIS

=head1 ALGORITHMS

=head2 sub

=head1 BENCHMARK

=head1 CONTRIBUTE

You can contribute to this project via GitHub :
    https://github.com/atoomic/Learn-XS

=head1 TODO

=head1 AUTHOR

Nicolas R., E<lt>me@eboxr.comE<gt>

=head1 CONTRIBUTORS

Salvador Fandi–o

=head1 SEE ALSO

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by eboxr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
