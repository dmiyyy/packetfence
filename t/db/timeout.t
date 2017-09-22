=head1 NAME

schema

=cut

=head1 DESCRIPTION

test the latest schema of PacketFence
Requires the root db password to be set in the environmentally variable PF_TEST_DB_PASS

Example:

  PF_TEST_DB_PASS=passwd perl t/db/schema.t

=cut

use strict;
use warnings;
use lib '/usr/local/pf/lib';

BEGIN {
    #include test libs
    use lib qw(/usr/local/pf/t);
    #Module for overriding configuration paths
    use setup_test_config;
}

use pf::db;
use Test::More tests => 3;                      # last test to print

use Test::NoWarnings;

my $dbh  = eval {
    db_connect();
};

BAIL_OUT("Cannot connect to dbh") unless $dbh;

my $sth = $dbh->prepare("SELECT SLEEP(2) as sleep;");

$sth->execute();

my $row = $sth->fetchrow_hashref;

is($row->{sleep}, 0, "Sleep did not timeout");

$sth->finish;

db_disconnect();

db_set_max_statement_timeout(1);

$dbh = db_connect();

$sth = $dbh->prepare("SELECT SLEEP(2) as sleep;");

$sth->execute();

$row = $sth->fetchrow_hashref;

is($row->{sleep}, 1, "Sleep did timeout");

$sth->finish;

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2017 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;
