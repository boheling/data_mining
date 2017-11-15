#!/usr/bin/perl
use strict;
use warnings;

use FindBin;

use AI::NaiveBayes1;
my $nb = AI::NaiveBayes1->new;

my $train_file = "$FindBin::Bin/data/train_data.csv";
my $test_file  = "$FindBin::Bin/data/test_data.csv";
open my $train_set, '<', $train_file;

while ( chomp( my $train_obj = <$train_set> ) ) {
    my ($rating,    $date,       $IMDb_URL, $unknown,   $Action,   $Adventure,
        $Animation, $Children,   $Comedy,    $Crime,    $Documentary,
        $Drama,     $Fantasy,    $Film_Noir, $Horror,   $Musical,
        $Mystery,   $Romance,    $Sci_Fi,    $Thriller, $War,
        $Western,   $occupation, $age,       $gender,   $zip_code
    ) = split ',', $train_obj;
    
    $nb->add_instances(
        attributes => {
            date        => $date,
            url         => $IMDb_URL,
            unknown     => $unknown,
            Action      => $Action,
            Adventure   => $Adventure,
            Animation   => $Animation,
            Children    => $Children,
            Comedy      => $Comedy,
            Crime       => $Crime,
            Documentary => $Documentary,
            Drama       => $Drama,
            Fantasy     => $Fantasy,
            Film_Noir   => $Film_Noir,
            Horror      => $Horror,
            Musical     => $Musical,
            Mystery     => $Mystery,
            Romance     => $Romance,
            Sci_Fi      => $Sci_Fi,
            Thriller    => $Thriller,
            War         => $War,
            Western     => $Western,
            occupation  => $occupation,
            age         => $age,
            gender      => $gender,
            zip_code    => $zip_code
        },
        label => "rating=$rating",
        cases => 1
    );
}
close $train_set;
$nb->train;

#print "Model:\n" . $nb->print_model;
#print "Model (with counts):\n" . $nb->print_model('with counts');
#write the model to a file (shorter than model->string->file)
#$nb->import_from_YAML_file('t/tmp1');

open my $test_set, '<', $test_file;
open my $test_result, '>', 'result';
my $ident;
my $count;

while ( chomp( my $test_obj = <$test_set> ) ) {
    my ($rating, $date,       $IMDb_URL, $unknown,   $Action,   $Adventure,
        $Animation, $Children,   $Comedy,    $Crime,    $Documentary,
        $Drama,     $Fantasy,    $Film_Noir, $Horror,   $Musical,
        $Mystery,   $Romance,    $Sci_Fi,    $Thriller, $War,
        $Western,   $occupation, $age,       $gender,   $zip_code
    ) = split ',', $test_obj;
    my $result = $nb->predict(
        attributes => {
            date        => $date,
            url         => $IMDb_URL,
            unknown     => $unknown,
            Action      => $Action,
            Adventure   => $Adventure,
            Animation   => $Animation,
            Children    => $Children,
            Comedy      => $Comedy,
            Crime       => $Crime,
            Documentary => $Documentary,
            Drama       => $Drama,
            Fantasy     => $Fantasy,
            Film_Noir   => $Film_Noir,
            Horror      => $Horror,
            Musical     => $Musical,
            Mystery     => $Mystery,
            Romance     => $Romance,
            Sci_Fi      => $Sci_Fi,
            Thriller    => $Thriller,
            War         => $War,
            Western     => $Western,
            occupation  => $occupation,
            age         => $age,
            gender      => $gender,
            zip_code    => $zip_code
        },
    );
    my $max = 0;
    my $max_label;
    foreach my $k ( keys( %{$result} ) ) {
        if ( $result->{$k} > $max ) {
            $max       = $result->{$k};
            $max_label = $k;
        }
    }
    $max_label =~ /rating=(\d)/;
    print $test_result "$1\n";
    $ident++ if $1 == $rating;
    $count++;
}
print "The accuracy is ", $ident / $count, "\n";
close $test_result;

__END__

=head1 NAME

  cat_naivebayes.pl - category and predict data by naivebayes algorithm

=head1 SYNOPSIS

  perl get_proxy.pl [options]
    Options:
      -h,   --help, -?          brief help message
      -m,   --man               full documentation

=item full load run

  perl cat_naivebayes.pl

=back

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
