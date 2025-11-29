#!/usr/bin/env raku

use ICal::Grammar;

unit sub MAIN($file);

my $g = Grammar::ICal.new;
my $data = $file.IO.slurp;
my $m = $g.parse($data);
say $m;
