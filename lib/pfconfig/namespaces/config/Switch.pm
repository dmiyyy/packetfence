package pfconfig::namespaces::config::Switch;

use strict;
use warnings;

use pfconfig::namespaces::config;
use Config::IniFiles;
use Data::Dumper;

use base 'pfconfig::namespaces::config';

sub init {
  my ($self) = @_;
  $self->{file} = "/usr/local/pf/conf/switches.conf";
  $self->{child_resources} = [
    'resource::default_switch',
  ]
}

sub build_child {
  my ($self) = @_;

  my %tmp_cfg = %{$self->{cfg}}; 

  $tmp_cfg{'127.0.0.1'} = {
      id                => '127.0.0.1',
      type              => 'PacketFence',
      mode              => 'production',
      SNMPVersionTrap   => '1',
      SNMPCommunityTrap => 'public'
  };

  foreach my $section_name (keys %tmp_cfg){
    unless($section_name eq "default"){
      foreach my $element_name (keys %{$tmp_cfg{default}}){
        unless (exists $tmp_cfg{$section_name}{$element_name}){
          $tmp_cfg{$section_name}{$element_name} = $tmp_cfg{default}{$element_name};
        }
      }
    }
  }


  foreach my $switch ( values %tmp_cfg ) {

      # transforming uplink and inlineTrigger to arrays
      foreach my $key (qw(uplink inlineTrigger)) {
          my $value = $switch->{$key} || "";
          $switch->{$key} = [ split /\s*,\s*/, $value ];
      }

      # transforming vlans and roles to hashes
      my %merged = ( Vlan => {}, Role => {}, AccessList => {} );
      foreach my $key ( grep {/(Vlan|Role|AccessList)$/} keys %{$switch} ) {
          next unless my $value = $switch->{$key};
          if ( my ( $type_key, $type ) = ( $key =~ /^(.+)(Vlan|Role|AccessList)$/ ) ) {
              $merged{$type}{$type_key} = $value;
          }
      }
      $switch->{roles}        = $merged{Role};
      $switch->{vlans}        = $merged{Vlan};
      $switch->{access_lists} = $merged{AccessList};
      $switch->{VoIPEnabled} = (
          $switch->{VoIPEnabled} =~ /^\s*(y|yes|true|enabled|1)\s*$/i
          ? 1
          : 0
      );
      $switch->{mode} = lc( $switch->{mode} );
      $switch->{'wsUser'} ||= $switch->{'htaccessUser'};
      $switch->{'wsPwd'} ||= $switch->{'htaccessPwd'} || '';
      foreach my $cli_default (qw(EnablePwd Pwd User)) {
          $switch->{"cli${cli_default}"}
            ||= $switch->{"telnet${cli_default}"};
      }
      foreach my $snmpDefault (
          qw(communityRead communityTrap communityWrite version)) {
          my $snmpkey = "SNMP" . ucfirst($snmpDefault);
          $switch->{$snmpkey} ||= $switch->{$snmpDefault};
      }
  }

  $self->{cfg} = \%tmp_cfg;

  return \%tmp_cfg;

}

1;
