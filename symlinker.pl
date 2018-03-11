#! /usr/bin/perl

use warnings; 
use strict; 
use Getopt::Long;

use Cwd 'abs_path';

my $out_path; 
my $help = 0; 
my $test = 0; 
GetOptions(
	'folder=s' => \$out_path, 
	'test' => \$test, 
	'h|help' => \$help, 
) or die "Mistaken input\n";

if($help || !defined($out_path)){
	print <<eof;
Usage: symlinker -folder=<string> <params>
This Script will copy all files in pics/script in your development version. On Linux it uses Symlinks. 
string contains the absolute Source Path where the file should be saved


e.g. if your ygopro folder is in c:\\ygopro you need to write "perl symlinker.pl -folder=c:\\ygopro"
(Tested only on Linux. There could be bugs on windows)
-test 		Get Output Informations
-h|help		Print these Message
eof

	exit(0);
}

my $abs_path = abs_path('.');
$out_path =~ s/~/$ENV{HOME}/g;

print "inPath: $abs_path\n"; 
print "outPath: $out_path\n"; 
foreach my $folder('pics', 'script'){
	
	foreach my $count(999999000..999999999){
		#my $count = 999999977;
		my $filename = "$count.jpg"; 
		$filename = "c$count.lua" if($folder eq 'script');
		my $result = symlink "$abs_path/$folder/$filename","$out_path/$folder/$filename";
		print "Result:$result from '$abs_path/$folder/$filename' to '$out_path/$folder/$filename'\n" if($test);
	}
}