use strict;
use utf8;

my $doc = 'access.log';
my @items;

open(my $var, "<", $doc) or die "doesn't work< $doc!";
while (my $row = <$var>)
{
	 if ($row =~ /^(\d+\.\d+\.\d+\.\d+)\s+([^\s])+\s+([^\s]+)\s+\[([^\s\]]+)\s+([^\s\]]+)\]\s+"(?:(GET|HEAD|POST)\s+)?([^"]+)"\s+(\d+)\s+\d+\s+"([^"]+)"\s+"([^"]+)"/) {
            push @items, { "ip" => $1, "blank" => $2, "user" => $3, "datetime" => $4, "timezone" => $5, "method" => $6, "request" => $7, "status" => $8, "referer" => $9, "user-agent" => $10,
		    "upload" => $row,
		    "block" => 0		
                };
        }
}
	foreach my $var (@items)
    	{
			if ($$var{'request'} =~ /^\/API/)
			{$$var{block}++;}

			if ($$var{'method'} eq "")
			{$$var{block}++}

			if (index($$var{'request'}, "x0") != -1)
			{$$var{block}++}

			if ($$var{'status'} == 181)
			{$$var{block}++;}   
			
			if ($$var{'user_agent'} =~ /^Python-urllib/)
			{$$var{block}++;}
   	 }

my $count = 0;
foreach my $key (sort {$b->{block} <=> $a->{block}} @items)
{
	print "$$key{block}, $$key{upload} \n";
	$count=$count+1;
	if ($count>=50) {last;}
}
