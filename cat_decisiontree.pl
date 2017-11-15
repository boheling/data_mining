#!/usr/bin/perl
use strict;
use warnings;

use FindBin;

use AI::DecisionTree;
my $dtree = new AI::DecisionTree(
    noise_mode => 'pick_best'
);

my $train_file = "$FindBin::Bin/data/train_data.csv";
my $test_file  = "$FindBin::Bin/data/test_data.csv";
open my $train_set, '<', $train_file;

while ( chomp( my $train_obj = <$train_set> ) ) {
    my ($rating,    $date,       $unknown,   $Action,   $Adventure,
        $Animation, $Children,   $Comedy,    $Crime,    $Documentary,
        $Drama,     $Fantasy,    $Film_Noir, $Horror,   $Musical,
        $Mystery,   $Romance,    $Sci_Fi,    $Thriller, $War,
        $Western,   $occupation, $age,       $gender,   $zip_code
    ) = split ',', $train_obj;

    $dtree->add_instance(
        attributes => {
            date        => $date,
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
        result => "$rating"
    );
}

$dtree->train;

#print "Model:\n" . $nb->print_model;
#print "Model (with counts):\n" . $nb->print_model('with counts');
#write the model to a file (shorter than model->string->file)
#$nb->import_from_YAML_file('t/tmp1');

open my $test_set, '<', $test_file;
my $ident;
my $count;

while ( chomp( my $test_obj = <$test_set> ) ) {
    my ($rating,    $date,       $unknown,   $Action,   $Adventure,
        $Animation, $Children,   $Comedy,    $Crime,    $Documentary,
        $Drama,     $Fantasy,    $Film_Noir, $Horror,   $Musical,
        $Mystery,   $Romance,    $Sci_Fi,    $Thriller, $War,
        $Western,   $occupation, $age,       $gender,   $zip_code
    ) = split ',', $test_obj;

    my $result = $dtree->get_result(
        attributes => {
            date        => $date,
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
        }
    );
    $ident++ if $result == $rating;
    $count++;
}
print "The accuracy is ", $ident / $count, "\n";

__END__

=head1 NAME

  cat_decisiontree.pl - category and predict data by decision tree algorithm

=head1 SYNOPSIS

  perl get_proxy.pl [options]
    Options:
      -h,   --help, -?          brief help message
      -m,   --man               full documentation

=item full load run

  perl cat_decisiontree.pl

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

Bug report:
Something's wrong: attribute 'date' didn't split 12 instances into multiple buckets (95) at /usr/local/lib/perl5/site_perl/5.10.0/x86_64-linux-thread-multi/AI/DecisionTree.pm line 170, <$train_set> line 80000.

=cut
