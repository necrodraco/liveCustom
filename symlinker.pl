#! /usr/bin/perl

use warnings; 
use strict; 
use Getopt::Long;

use Cwd 'abs_path';

my $out_path; 
my $help = 0; 
GetOptions(
	'folder=s' => \$out_path, 
	'h|help' => \$help, 
) or die "Mistaken input\n";

if($help || !defined($out_path)){
	print <<eof;
Usage: symlinker -folder=<string>
This Script will copy all files in pics/script in your development version. On Linux it uses Symlinks. 
string contains the absolute Source Path where the file should be saved


e.g. if your ygopro folder is in c:\\ygopro you need to write "perl symlinker.pl -folder=c:\\ygopro"
(Tested only on Linux. There could be bugs on windows)
-h|help		Print these Message
eof

	exit(0);
}

my $abs_path = abs_path('.');

print "inPath: $abs_path\n"; 
print "outPath: $out_path\n"; 
foreach my $folder('pics', 'script'){
	
	foreach my $count(100000000..999999999){
		my $filename = "$count.jpg"; 
		$filename = "c$count.lua" if($folder eq 'script');
		symlink "$abs_path/$folder/$filename","$out_path/$folder/$filename";
	}
}