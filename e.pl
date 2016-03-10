#!/usr/bin/perl -w

# $Id: e.pl,v 1.1 2012/09/03 23:02:45 rmon Exp $

use strict;

use Getopt::Long;

my $print0 = undef;

GetOptions(
	"0" => \$print0,
);

my $eol = $print0 ? "\0" : "\n";

while(<STDIN>) {
	chomp;
	next if /^#/;
	next if /^$/;
	if(-f $_) {
		print $_, $eol;
	}
}
