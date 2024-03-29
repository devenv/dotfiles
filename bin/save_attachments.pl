#!/usr/bin/perl
#
# Un-MIME regular message from stdin.
# Non-text version saved in directory ~/mail/MIME and proper indication is
# left in the dumped message. Text is otherwise dumped and deleted from there.
#
# Intended to be used with mailagent thanks to the following incantation rule:
#
# Mime-Version: /^\d/    { SAVE +mime; FEED ~/mail/unmime; RESYNC; REJECT };
#
# Options:
#   -e: pass the quoted-printable decoder over the message and that's it.
#    -x: translate chars not understood by some iso8859-1 fonts.
#    -X: translate all accents to non-accentuated letters (plain ASCII).

($me = $0) =~ s|.*/(.*)|$1|;

require "getopts.pl";
Getopts('exX');

$opt_x++ if $opt_X;        # -X implies -x

$TMPDIR = "/home/essl/att";

use MIME::Parser;

#------------------------------------------------------------
# dump_entity - idempotent routine for dumping an entity
#------------------------------------------------------------

sub dump_entity {
  my ($entity) = @_;
  my $IO;
  my $not_first_part = 0;
  
  # Print the header, converting accents if any
  my $head = $entity->head->original_text;
  $head =~ s/^(Subject:.*)/no_iso_markup($1)/me
    if $head =~ /^Subject:.*=\?iso-8859-1\?Q\?/mi;
  print $head, "\n";
  
  # Output the body:
  my @parts = $entity->parts;
  if (@parts) {            # multipart...
    my $i;
    foreach $i (0 .. $#parts) { # dump each part...
      dump_entity($parts[$i]);
    }
  } else {            # single part... 
    # Get MIME type, and display accordingly...
    my ($type, $subtype) = split('/', $entity->head->mime_type);
    #print STDERR "type - $type\n";
    
    my $body = $entity->bodyhandle;
    my $path = $body->path;
    if ($type =~ /^(text|message)$/ || -T $path) {     # text: display it...
      if ($IO = $body->open("r")) {
    print "\n" if $not_first_part++;
    print to_ascii($_) while (defined($_ = $IO->getline));
    $IO->close;
    
    # If message is text/message, chances that we did the right
    # thing are extremely high. So unlink the message if lying on
    # the disk... -- RAM, 19/11/96

    #unlink($path) or warn "$me: can't unlink $path: $!\n"
    #  if defined $path && -f $path;
    
      } else {            # d'oh!
    die "$me: couldn't find/open '$file': $!";
      }
    } else {            # binary: just summarize it...
      my $size = ($path ? (-s $path) : '???');
      print ">>> This is a non-text message, $size bytes long.\n";
      print ">>> It is stored in ", ($path ? "'$path'" : 'core'),".\n\n";
    }
  }
  print "\n";
  
  1;
}

#------------------------------------------------------------
# smart_pack
#------------------------------------------------------------
sub smart_pack {
  my ($hexa) = @_;
  my $val = hex($hexa);
  return "=$hexa" if $val >= 128; # We're smart right there!
  return pack('C', $val);
}

#------------------------------------------------------------
# no_accent
#------------------------------------------------------------
sub no_accent {
  local ($_) = @_;
  tr/\xab\xbb\xe0\xe2\xe7\xe8\xe9\xea\xee\xef\xf4\xf9\xfb/""aaceeeiiouu/;
  return $_;
}

#------------------------------------------------------------
# to_ascii
#------------------------------------------------------------
sub to_ascii {
  my ($l) = @_;
  return $l unless $opt_x;    # Don't loose info unless -x or -X
  $l =~ tr/\x92/'/ if $opt_x;    # ';
  $l = no_accent($l) if $opt_X;
  return $l;
}

#------------------------------------------------------------
# to_txt -- combines =xx packing with no_accent()
#------------------------------------------------------------
sub to_txt {
  my ($l) = @_;
  $l =~ s/=([\da-fA-F]{2})/pack('C', hex($1))/ge;
  return no_accent($l);
}

#------------------------------------------------------------
# no_iso_markup -- removes ugly ?iso-8859-1?Q escapes
#------------------------------------------------------------
sub no_iso_markup {
  local ($_) = @_;
  s/^(.*?)=\?iso-8859-1\?Q\?(.*)\?=/$1 . to_txt($2)/ie;
  s/_/ /g;
  return $_;
}

#------------------------------------------------------------
# unquote_stdin
#------------------------------------------------------------
sub unquote_stdin {
  local $_;
  my $encoded = 0;
  my $in_header = 1;
  while (<STDIN>) {
    $in_header = 0 if /^\s*$/;
    
    # All Subject: line with accents to be "un-mimed" as well.
    s/^(Subject:.*)/no_iso_markup($1)/e 
      if $in_header && /^Subject:.*=\?iso-8859-1\?Q\?/i;
    
    # Avoid decoding inlined uuencoded/btoa stuff... since they might
    # accidentally bear valid =xx escapes... The leading \w character
    # is there in case the thing is shar'ed...
    # Likewise, all the lines longer than 60 chars and with no space
    # in them are treated as being encoded iff they begin with M.

    $encoded = 1 if /^\w?begin\s+\d+\s+\S+\s*$/ || /^\w?xbtoa Begin\s*$/;
    $encoded = 0 if /^\w?end\s*$/ || /^\w?xbtoa End/;
    
    if ($encoded || (length > 60 && !/ / && /^M/)) {
      print $_;
    } else {
      # Can't use decode_qp from MIME::QuotedPrint because we might not
      # face a real quoted-printable message...
      # Inline an alternate  version.
      
      s/\s+(\r?\n)/$1/g;    # Trailing white spaces
      s/^=\r?\n//;        # Soft line breaks
      s/([^=])=\r?\n/$1/;    # Soft line breaks, but not for trailing == 
      s/=([\da-fA-F]{2})/smart_pack($1)/ge;    # Hehe
      print to_ascii($_);
    }
  }
  return 1;    # OK
}

#------------------------------------------------------------
# main
#------------------------------------------------------------

sub main {
  return &unquote_stdin if $opt_e;
  
  # Create a new MIME parser:
  my $parser = new MIME::Parser;
  
  # Create and set the output directory:
  $parser->output_dir($TMPDIR);
  
  # Read the MIME message:
  $entity = $parser->read(\*STDIN) or
    die "$me: couldn't parse MIME stream";
  
  # Dump it out:
  dump_entity($entity);
  unlink<$TMPDIR/msg-*.txt> or warn "can't unlink: $!\n";
}

exit(&main ? 0 : -1);
#------------------------------------------------------------
1;
#
# This bit below saves the message body to file, uncomment if wanted
#
#unlink</var/spool/mail/MIME/msg-*.txt> or warn "can't unlink: $!\n";
