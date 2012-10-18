#!/usr/bin/perl -wW

use strict;
use Net::OpenSSH;
use Getopt::Long;

my $username;
my $password;
my $verbose;

GetOptions(
  'username=s' => \$username,
  'password=s' => \$password,
  'verbose' => \$verbose,
);

my $server = shift or die "No server specified.";
my $command = shift or die "No command specified.";
my @args = @ARGV;

if ($verbose) { 
  print "username is '$username'\n";
  print "password is '$password'\n";
  print "server is '$server'\n";
  print "command is '$command'\n";
  print "args are '@args'\n";
}

my $endpoint = '';

$endpoint .= $username if ($username);
$endpoint .= ":$password" if ($username and $password);
$endpoint .= "@" if ($username);
$endpoint .= $server;

if ($verbose) {
  print "Targeting endpoint '$endpoint'\n";
}

my $ssh = Net::OpenSSH->new($endpoint);
$ssh->error and die 'Cant ssh to $server: ' . $ssh->error;

my $output = $ssh->capture($command, @args); 
my @lines = split /\r?\n/, $output;

print map { "SSHCMD: $_\n" } @lines;

