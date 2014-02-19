use 5.10.0;
use strict;
use warnings;
use IO::File;
use Furl;
use DBI;
use URL::Encode::XS;

my $dsn = $ENV{HRHMDB};
my $dbh = DBI->connect($dsn);

my $sth = $dbh->prepare("select band_id, bandname from bands");
$sth->execute;

my $http = new Furl;

while (my $row = $sth->fetchrow_arrayref) {
    my $band_id = $$row[0];
    my $bandname = $$row[1];
    $bandname =~ s| |_|g;
    my $res = $http->get("http://en.wikipedia.org/wiki/$bandname");
    IO::File->new("html/wikipedia/en/$band_id.html", 'w')->write($res->content);
}
$dbh->disconnect;

