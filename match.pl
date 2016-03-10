#!/usr/bin/perl -w

# $Id: match.pl,v 1.3 2012/09/04 00:52:12 rmon Exp $

use strict;

use Getopt::Long;

use Data::Dumper;

my $mode = '';
my $subj = '';

GetOptions(
	"mode|m=s" => \$mode,
	"subj=s" => \$subj,
);

sub usage {
    print STDERR <<"_EOT_";
Usage: match.pl --mode=match --subj=file
Usage: match.pl --mode=stale --subj=file
_EOT_
    exit(1);
}

if(!$subj) { usage(); }

boot();

sub boot {
	my $actual = ls($subj);

	my $legacy = {};
	foreach my $fn (@ARGV) {
		up($fn, $legacy);
	}

	my $obsolete = {};
	while(<STDIN>) {
		chomp;
		next if /^#/;
		next if /^$/;
		my ($hash, $path) = split(/ /, $_, 2);
		if(defined($legacy->{$_})) {
#			my ($hash, $path) = split(/ /, $_, 2);
			if(defined($actual->{$path})) {
				print $path, "\n" if($mode eq 'match');
			} else {
				print $path, "\n" if($mode eq 'stale');
			}
		}
		$obsolete->{$path}++;
	}

#	print "\n";
	foreach my $path (sort(keys %{$actual})) {
		if(!defined($obsolete->{$path})) {
			print $path, "\n" if($mode eq 'match');
		}
	}

}

sub ls {
	my $fn = shift;

	my %map = ();
	open(my $is, '<', $fn) or die $!;
	while(<$is>) {
		chomp;
		next if /^#/;
		next if /^$/;
		my ($hash, $path) = split(/ /, $_, 2);
		$map{$path}++;
	}
	close($is);

	return \%map;
}

sub up {
	my $fn = shift;
	my $map = shift;
	open(my $is, '<', $fn) or die $!;
	while(<$is>) {
		chomp;
		next if /^#/;
		next if /^$/;
		$map->{$_}++;
	}
	close($is);
}
