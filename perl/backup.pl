#!/usr/bin/perl 

use warnings;

@ARGV == 1 or die "Usage: ./backup.pl <filename>";

open $readfile, "<", "$ARGV[0]";
@content = <$readfile>;

$count = 0;


#@files = glob ".[0-9a-zA-Z_]*";  
@files = grep /\w+/, glob(".*");  #nicer way to do this

# print @files;
# for $file (@files){
# 	print $file."\n";
# 	while ( (grep (/.$ARGV[0].$count/, $file)) ){	
# 		print $file."\n";
#		$count++;
# 	}
# }

while ( (grep (/^.$ARGV[0].$count$/, @files)) ){
	$count++;
}
#nicer way to do this

open $writefile, ">", "\.$ARGV[0]\.$count";

print "@content\n";
print $writefile @content;


print "Backup of '$ARGV[0]' saved as '.$ARGV[0].$count'\n";