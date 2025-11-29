use ICal::Grammar;
use ICal::Actions;

my $g = ICal::Grammar.new;
my $actions = ICal::Actions.new;

my $parse = $g.parse($*IN.slurp, :$actions);

my $out = $parse.made;
for $out<events>.list -> $e {
  say "--";
  unless $e<dtstart> // $e<dtstamp> {
    say "No dtstart or dtstamp for event";
    next;
  }
  my $dt = $e<dtstart> // $e<dtstamp>;
  say $dt ~ " " ~ ( $e<summary> // "No summary for " ~ $e.Hash.raku );
}
