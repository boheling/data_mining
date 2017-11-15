#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use Config::Tiny;
use YAML qw(Dump Load DumpFile LoadFile);

use Bio::Seq;
use Bio::SeqIO;
use Text::CSV_XS;
use Encode qw(encode decode);

use FindBin;
use lib "$FindBin::Bin/lib";
use DmDB;

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

# data source files
my $rating_file;
my $occupation_file;
my $user_file;
my $item_file;
my $test_file;

my $man  = 0;
my $help = 0;

GetOptions(
    'help|?'            => \$help,
    'man'               => \$man,
    'rating_file=s'     => \$rating_file,
    'occupation_file=s' => \$occupation_file,
    'user_file=s'       => \$user_file,
    'item_file=s'       => \$item_file,
    'test_file=s'       => \$test_file,
    'db=s'              => \$db,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

#----------------------------------------------------------#
# init objects
#----------------------------------------------------------#

# DBIx::Class interface to database, the $*_rs are resultset objects
my $schema = DmDB->connect( "dbi:mysql:$db:$server", $username, $password );
my $rating_rs     = $schema->resultset('rating');
my $occupation_rs = $schema->resultset('occupation');
my $user_rs       = $schema->resultset('user');
my $item_rs       = $schema->resultset('item');
my $test_rs       = $schema->resultset('test');

#----------------------------------------------------------#
# Get data and store them to database
#----------------------------------------------------------#
print "Read out new sequences\n";

#----------------------------------------------------------#
# Load rating table
#----------------------------------------------------------#
if ($rating_file) {
    open my $rating_in, '<', $rating_file;
    my $count = 0;
    while ( my $rating_obj = <$rating_in> ) {
        chomp $rating_obj;
        my ( $user_id, $item_id, $rating ) = split '\t', $rating_obj;
        $rating_rs->update_or_create(
            {   user_id => $user_id,
                item_id => $item_id,
                rating  => $rating,
            },
        ) and $count++;
        print "Inserting $user_id...\n";
    }
    print "insert $count rating objects, done!\n";
    close $rating_in;
}

#----------------------------------------------------------#
# Load occupation table
#----------------------------------------------------------#
if ($occupation_file) {
    open my $occupation_in, '<', $occupation_file;
    my $count = 0;
    while ( my $occupation_obj = <$occupation_in> ) {
        chomp $occupation_obj;
        my $occupation = $occupation_obj;
        $occupation_rs->update_or_create(
            {   
                occupation => $occupation,
            },
        ) and $count++;
    }
    print "insert $count occupation objects, done!\n";
    close $occupation_in;
}

#----------------------------------------------------------#
# Load user table
#----------------------------------------------------------#
if ($user_file) {
    open my $user_in, '<', $user_file;
    my $count = 0;
    while ( my $user_obj = <$user_in> ) {
        chomp $user_obj;
        my ( $user_id, $age, $gender, $occupation, $zip_code ) = split '\|', $user_obj;
        my $occ_row = $occupation_rs->find(
            {
                occupation  => $occupation,
            },
        ) or die "Can not find occupation $occupation in user id $user_id!\n";
        $zip_code=~s/(\w).*/$1/;
        my $age_range = $age;
        if($age<25){
            $age_range='<25';
        }
        elsif($age<35){
            $age_range='25-35';
        }
        elsif($age<45){
            $age_range='35-45';
        }
        elsif($age<55){
            $age_range='45-55';
        }
        else{
            $age_range='>55';
        }
        $user_rs->update_or_create(
            {   user_id    => $user_id,
                age        => $age_range,
                gender     => $gender,
                occupation => $occ_row->occ_id,
                zip_code   => $zip_code,
            },
        ) and $count++;
        print "Inserting $user_id...\n";
    }
    print "insert $count user objects, done!\n";
    close $user_in;
}

#----------------------------------------------------------#
# Load item table
#----------------------------------------------------------#
if ($item_file) {
    open my $item_in, '<', $item_file;
    my $count = 0;
    while ( my $item_obj = <$item_in> ) {
        chomp $item_obj;
        my ( $item_id, $movie_title, $release_date, $video_release_date,
       $IMDb_URL, $_unknown, $_Action, $Adventure, $Animation, $Children,
       $Comedy, $Crime, $Documentary, $Drama, $Fantasy, $Film_Noir, $Horror,
       $Musical, $Mystery, $Romance, $Sci_Fi, $Thriller, $War, $Western) = split '\|', $item_obj;
        $release_date =~ s/.*(\d{4})/$1/;
        my $url = ($IMDb_URL=~/\/M\//)? 'M':'N';
        my $data_range = $release_date;
        if($release_date<1940){
            $data_range='20-40';
        }
        elsif($release_date<1950){
            $data_range='40-50';
        }
        elsif($release_date<1960){
            $data_range='50-60';
        }
        elsif($release_date<1970){
            $data_range='60-70';
        }
        elsif($release_date<1980){
            $data_range='70-80';
        }
        elsif($release_date<1990){
            $data_range='80-90';
        }
        elsif($release_date<1992){
            $data_range='90-92';
        }
        elsif($release_date<1993){
            $data_range='92';
        }
        elsif($release_date<1994){
            $data_range='93';
        }
        elsif($release_date<1995){
            $data_range='94';
        }
        elsif($release_date<1996){
            $data_range='95';
        }
        elsif($release_date<1997){
            $data_range='96';
        }
        elsif($release_date<1998){
            $data_range='97';
        }
        else{
            $data_range='98-now';
        }
        $item_rs->update_or_create(
            {   item_id => $item_id,
                movie_title => $movie_title,
                release_date  => $data_range,
                video_release_date  => $video_release_date,
                IMDb_URL  => $url,
                _unknown  => $_unknown,
                _Action  => $_Action,
                Adventure  => $Adventure,
                Animation  => $Animation,
                Children  => $Children,
                Comedy  => $Comedy,
                Crime  => $Crime,
                Documentary  => $Documentary,
                Drama  => $Drama,
                Fantasy  => $Fantasy,
                Film_Noir  => $Film_Noir,
                Horror  => $Horror,
                Musical  => $Musical,
                Mystery  => $Mystery,
                Romance  => $Romance,
                Sci_Fi  => $Sci_Fi,
                Thriller  => $Thriller,
                War  => $War,
                Western  => $Western,
            },
        ) 
        and $count++;
        print "Inserting $item_id...\n";
    }
    print "insert $count item objects, done!\n";
    close $item_in;
}

#----------------------------------------------------------#
# Load rating table
#----------------------------------------------------------#
if ($test_file) {
    open my $test_in, '<', $test_file;
    my $count = 0;
    while ( my $test_obj = <$test_in> ) {
        chomp $test_obj;
        my ( $user_id, $item_id ) = split '\t', $test_obj;
        $test_rs->update_or_create(
            {   user_id => $user_id,
                item_id => $item_id,
            },
        ) and $count++;
        print "Inserting $user_id...\n";
    }
    print "insert $count test objects, done!\n";
    close $test_in;
}

exit;

__END__

perl load_data.pl --rating_file=data/train
perl load_data.pl --occupation_file=data/u.occupation
perl load_data.pl --user_file=data/u.user
perl load_data.pl --item_file=data/u.item
perl load_data.pl --rating_file=data/train --occupation_file=data/u.occupation --user_file=data/u.user --item_file=data/u.item --test_file=data/test