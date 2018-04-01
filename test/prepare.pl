#! /usr/bin/perl

use warnings; 
use strict; 
use Getopt::Long; 
use File::Find;
use File::Copy;
use DBI;

use YAML 'LoadFile';
use Cwd 'abs_path';

my $path; 
my $help = 0;  
GetOptions(
	'folder=s' => \$path, 
	'h|help' => \$help, 
) or die "Mistaken input\n";

if($help || !defined($path)){
	print <<eof;
Usage: prepare --folder=<string> <params>
This Script takes all the .cdb and all scripts/pics and rename them like they should, based of the template.yaml
folder must be the path to ygopro without the leading /
e.g. C:/ygopro

(Tested only on Linux. There could be bugs on windows)
--h|help		Print these Message
eof
	exit(0);
}

$path =~ s/~/$ENV{HOME}/g;

my $pic_path = "$path/pics"; 
my $script_path = "$path/script";
my $livescript_path = "$path/expansions/live2017links/script";

my $ressources; 
if(-e 'read.yaml'){
	$ressources = LoadFile('read.yaml');
}else{
	$ressources = LoadFile('template.yaml');
}

my $abs_path = abs_path('.');
my @cdbs; 
find({ wanted => \&findCDBs, no_chdir=>1}, $abs_path);

#When the test.cdb not exist, create one by taking the first cdb
copy($cdbs[0], $abs_path.'/test.cdb');

my $dbargs = {'AutoCommit' => 1, 'PrintError' => 1};
my $dbh = DBI->connect("dbi:SQLite:dbname=$abs_path/test.cdb", "", "", $dbargs);

foreach my $file(@cdbs){
	if($file ne $abs_path.'/test.cdb'){
	$dbh->do('attach "'.$file.'" as toMerge');
	$dbh->do('insert or replace into datas select * from toMerge.datas');
	$dbh->do('insert or replace into texts select * from toMerge.texts');
	$dbh->do('detach toMerge');
	unlink $file; 
	}
}
while(my ($oldid, $newid) = each %{$ressources}){
	#Special Treatment for Link Monsters
	$dbh->do("update datas set type=97,def = 0 where type IN(67108865,67108897)");

	#Set Custom in Name and change the ids
	$dbh->do("update texts set name = name || '(Custom)', id = $newid where id=$oldid");
	$dbh->do("update datas set id = $newid where id=$oldid");
}
$dbh->do("delete from datas where id < 999999000");
$dbh->do("delete from texts where id < 999999000");
$dbh->disconnect();


while(my ($oldid, $newid) = each %{$ressources}){
	if(-e "$livescript_path/c$oldid.lua"){
		copy("$livescript_path/c$oldid.lua", "$abs_path/script/c$newid.lua");
	}else{
		copy("$script_path/c$oldid.lua", "$abs_path/script/c$newid.lua");
	}
	copy("$pic_path/$oldid.jpg", "$abs_path/pics/$newid.jpg");
}

sub findCDBs(){
	my $cdb = $File::Find::name; 
	if($cdb =~ m/.cdb/){
		push(@cdbs, $cdb);
	}
}