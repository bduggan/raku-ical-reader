#!/usr/bin/env raku

grammar ICal {
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
        <tagvalue>?
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

my $test = ICal.new.parse(q:to/END/);
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
CALSCALE:GREGORIAN
X-WR-CALNAME:something here
BEGIN:VEVENT
UID:
DTSTAMP:19970714T170000Z
ORGANIZER;CN=John Doe:MAILTO:
ATTENDEE;RSVP=TRUE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;CN=Jane Doe:MAILTO:
DTSTART:19970714T170000Z
DTEND:19970715T035959Z
SUMMARY:Bastille Day Party
END:VEVENT
BEGIN:VEVENT
UID:
DTSTAMP:19970714T170000Z
ORGANIZER;CN=John Doe:MAILTO:
ATTENDEE;RSVP=TRUE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;CN=Jane Doe:MAILTO:
DTSTART:19970714T170000Z
DTEND:19970715T035959Z
SUMMARY:Bastille Day Party
END:VEVENT
END:VCALENDAR
END

say $test;
