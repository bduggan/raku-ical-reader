grammar ICal::Grammar {
    rule TOP {
        ^ <ical> $
    }
    rule ical {
        <vcalendar>
    }
    rule vcalendar {
        'BEGIN:VCALENDAR'
        <version>
        <prodid>
        [ <other-tags>* % \n ]
        <vevent>*
        'END:VCALENDAR'
    }
    regex other-tags {
        <tagname>
        <?{
             "$<tagname>" ne "END"
        }>
        ':'
        [ <tagvalue> | $$ ]
    }
    token tagname {
        <-[:]>+
    }
    token tagvalue {
        <-[\n]>+
    }
    rule version {
      VERSION ':' \d '.' \d
    }
    rule prodid {
      PRODID ':' <-[\n]>+
    }
    rule vevent {
        'BEGIN:VEVENT'
        [ <other-tags>* % \n ]
        'END:VEVENT'
    }
}

class ICal::Actions {
  method TOP($/) {
    make $<ical>.made;
  }
  method ical($/) {
    make $<vcalendar>.made;
  }
  method vcalendar($/) {
    make %( events => $<vevent>.map({ $_.made }) );
  }
  method vevent($/) {
    make %( $<other-tags>.map({ |.made }) );
  }
  method other-tags($/) {
    with $<tagvalue> {
      if $<tagname> eq "DTSTART" | "DTSTAMP" {
        with $<tagvalue>.Str.lc {
          my $dt = DateTime.new(
            :year( .substr(0,4) ),
            :month( .substr(4,2) ),
            :day( .substr(6,2) ),
            :hour( .substr(9,2) ),
            :minute( .substr(11,2) ),
            :second( .substr(13,2) ),
          );
          make %( dtstart => $dt );
        }
      } else {
        make $<tagname>.Str => ( $<tagvalue>.Str);
     }
    } else {
      make $<tagname>.Str => "";
    }
  }
}

