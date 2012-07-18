#!/usr/bin/env perl

use 5.012;
use warnings;

my $history_path = "$ENV{'HOME'}/.zhistory";

die "Cannot locate file: $history_path" unless -e $history_path;

open(my $history_fh, '<', $history_path);

my $buffer_length = 0;
my %commands = ();

while(my $line = <$history_fh>) {
  chomp $line;
  if($line =~ /^:\s\d*:\d*;([^ ]*)/) {
    $commands{$1} += 1;
    $buffer_length = length $1 if length $1 > $buffer_length;
  }
}

close $history_fh;

for my $key (sort {$commands{$a} <=> $commands{$b}} keys %commands) {
  my $buffer = (length $key < $buffer_length) ? ' ' x ($buffer_length - length $key) : '';
  say "$key: $buffer \t $commands{$key}";
}

