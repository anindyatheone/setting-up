use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;

my $download_center_link = "http://www.yoyochinese.com/download-center";
my %items = ();

my $browser = LWP::UserAgent->new();
print "Getting links from download center...\n";
my $res = $browser->get($download_center_link);
if ( $res->is_success ) {
	print "Finding items to download...\n";
	my @matches = $res->content =~ /<a href="(.*?\.(?:pdf|zip))"/g;
	foreach my $match (@matches) {
		$items{$match} = 1;
	}
}

foreach my $link ( keys %items ) {
	 #$browser->proxy( 'http', 'http://172.17.1.18:8080' );    # proxy settings here!
	print "Going to download $link...\n";
	$res = $browser->get($link);
	my $filename = $link;
	$filename =~ s/.*?\/([^\/]+)$/$1/;
	if ( $res->is_success ) {
		print "Success! Saving to /Users/anindyam/yoyo/$filename ... ";
		open( BINFILE, ">/Users/anindyam/yoyo/$filename" ) || die;
		binmode BINFILE;
		print BINFILE $res->content;
		close BINFILE;
		print "Done!\n";
	}
	else {
		print Dumper $res;
		print " Failed\n";
	}
}

print "All done!\n";
