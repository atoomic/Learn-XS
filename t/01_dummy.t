#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Learn::XS ();

use Data::Dumper qw/Dumper/;
use Devel::Peek qw/Dump/;

ok 'todo';

# make test TEST_VERBOSE=1

{
	note "simple integer";
	
	for my $v ( 0 .. 2, 42 ) {
		my $i = Learn::XS::simple_integer($v);
		is $i => $v, "$i = $v";
		is int($i) => int($v), "int: $i = $v";
		is scalar($i) => scalar($v), "scalar: $i = $v";
	}

	for my $v ( undef, {}, [] ) {
		my $i = Learn::XS::simple_integer(undef);
		is $i => undef, 'return undef with invalid data';
	}
}

{
	note "simple string";
	
	for my $v ( qw{abcd something cherry 43_54 42abc} ) {
		my $s = Learn::XS::simple_string($v);
		is $s => $v, "simple_string($v)";
		
		my $c = Learn::XS::first_char($v);
		my $first = substr($v, 0, 1);
		is $c => $first, "first letter of $v is $first";		
	
		# warn Dump Learn::XS::first_char($c);	
	}
	is Learn::XS::first_char('') => undef, 'first_char("") => undef';
	is Learn::XS::first_char(undef) => undef, 'first_char(undef) => undef';
	
}

{
	note "to_arrayref";
	my @tests = (
		1,
		'abcd',
		[ 1..3 ],		
	);
	foreach my $t ( @tests ) {
		is_deeply  Learn::XS::to_arrayref($t) => [ $t ], "to_arrayref";
	}
}

{
	note "array_to_hashref";

	is_deeply Learn::XS::array_to_hash([ 'k1' => 1, 'k2' => 2]) => { 'k1' => 1, 'k2' => 2 }, "'k1' => 1, 'k2' => 2";
	is_deeply Learn::XS::array_to_hash([ 'k1' => 1, 'k2' => 2, 567]) => undef, "incorrect number elements";	
}

{
	# hash keys -> array
	my $input = { 'k1' => 1, 'k42' => 42};
	
#	my $keys = Learn::XS::hash_keys($input);
#	is_deeply [ sort @keys ] => [ sort keys %input], "get hash keys";
}

# TODO
# - Makefile with perlcc ( on a branch ? )
# - re-read the build scripts
# - run perlcc manually on a dummy script
# - hash keys to array 

{
	note "get_dual";
	
	my $v = Learn::XS::get_dual();
	
	is int($v) => 42, "int(get_dual())";
	is scalar($v) => 'universe', "scalar(get_dual())";
}


done_testing;
