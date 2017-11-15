#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use Config::Tiny;
use YAML qw(Dump Load DumpFile LoadFile);

use FindBin;
use lib "$FindBin::Bin/../lib";

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#
my $Config = Config::Tiny->new;
$Config = Config::Tiny->read("$FindBin::Bin/config.ini");

# Database init values
my $server   = $Config->{database}->{server};
my $port     = $Config->{database}->{port};
my $username = $Config->{database}->{username};
my $password = $Config->{database}->{password};
my $db       = $Config->{database}->{db};

my $init_sql = "$FindBin::Bin/table/table.sql";

my $man  = 0;
my $help = 0;

GetOptions(
    'help|?'     => \$help,
    'man'        => \$man,
    'server=s'   => \$server,
    'port=i'     => \$port,
    'db=s'       => \$db,
    'username=s' => \$username,
    'password=s' => \$password,
    'init_sql=s' => \$init_sql,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

#----------------------------------------------------------#
# call mysql
#----------------------------------------------------------#
my $cmd    = "mysql -h$server -P$port -u$username -p$password ";
my $drop   = "-e \"DROP DATABASE IF EXISTS $db;\"";
my $create = "-e \"CREATE DATABASE $db;\"";

print "#drop\n" . "$cmd $drop\n";
system("$cmd $drop");
print "#create\n" . "$cmd $create\n";
system("$cmd $create");
print "#init\n" . "$cmd $db < $init_sql\n";
system("$cmd $db < $init_sql");

__END__


=head1 NAME

    init_mirDB.pl - Initiate mirDB

=head1 SYNOPSIS

    init_mirDB.pl [options]
     Options:
       --help            brief help message
       --man             full documentation
       --server          MySQL server IP/Domain name
       --port            MySQL server port
       --db              database name
       --username        username
       --password        password
       --init_sql        init sql filename

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do someting
useful with the contents thereof.

=cut
