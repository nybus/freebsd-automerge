#!/usr/bin/perl -w

use strict;

while(<STDIN>) {
	chomp;
	next if /^#/;
	next if /^$/;
	print $_ . "\0";
}
