package Data::UUID;

#--------CUSTOM AMENDMENTS ------ 
#
# a portable version (binary perl dist, PAR::Packer , PerlApp)
# can't have a hard coded path

package Data::UUID::LOADER;
use strict;
use File::Spec;

sub _get_cava_uuid_dir {
    my $oldmask = umask 0000;
    my $folder = File::Spec->tmpdir;
    if($^O =~ /^mswin/i) {
        $folder .= qq(\\custom_data_uuid);
    } elsif(($^O =~ /^darwin/i) && ($folder ne '/tmp')) {
        # recent darwin has user specific temp
        $folder .= '/custom_data_uuid';
    } else {
        # linux && old darwin need username
        my $usename = (getpwuid($<))[0];
        $usename ||= 'system_data_uuid';
        $usename =~ s/[^A-Za-z0-9\_]/-/g;
        $folder .= '/' . $usename;
        mkdir($folder, 0777) if(!-d $folder);
        $folder .= '/custom_data_uuid';
    }
    
    mkdir($folder, 0777) if(!-d $folder);
    return $folder;
}

sub _perl_get_nodeid_store {
    my $gdir = _get_cava_uuid_dir();
    $gdir .= '/CUSTOMUUID_NODEID_STORE';
    $gdir =~ s/\//\\/g if($^O =~ /^MSWin/);
    chmod(0666, $gdir);
    return $gdir;
}

sub _perl_get_state_store {
    my $gdir = _get_cava_uuid_dir();
    $gdir .= '/CUSTOMUUID_STATE_NV_STORE';
    $gdir =~ s/\//\\/g if($^O =~ /^MSWin/);
    chmod(0666, $gdir);
    return $gdir;
}

#------------END CUSTOM AMENDMENTS

package Data::UUID;

use strict;

use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;
require Digest::MD5;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
   NameSpace_DNS
   NameSpace_OID
   NameSpace_URL
   NameSpace_X500
);
$VERSION = '1.217_001';

bootstrap Data::UUID $VERSION;

1;
__END__

=head1 NAME

Data::UUID - Perl extension for generating Globally/Universally 
Unique Identifiers (GUIDs/UUIDs).

=head1 SYNOPSIS

  use Data::UUID;
  
  $ug    = new Data::UUID;
  $uuid1 = $ug->create();
  $uuid2 = $ug->create_from_name(<namespace>, <name>);

  $res   = $ug->compare($uuid1, $uuid2);

  $str   = $ug->to_string( $uuid );
  $uuid  = $ug->from_string( $str );

=head1 DESCRIPTION

This module provides a framework for generating v3 UUIDs (Universally Unique
Identifiers, also known as GUIDs (Globally Unique Identifiers). A UUID is 128
bits long, and is guaranteed to be different from all other UUIDs/GUIDs
generated until 3400 CE.

UUIDs were originally used in the Network Computing System (NCS) and later in
the Open Software Foundation's (OSF) Distributed Computing Environment.
Currently many different technologies rely on UUIDs to provide unique identity
for various software components. Microsoft COM/DCOM for instance, uses GUIDs
very extensively to uniquely identify classes, applications and components
across network-connected systems.

The algorithm for UUID generation, used by this extension, is described in the
Internet Draft "UUIDs and GUIDs" by Paul J. Leach and Rich Salz.  (See RFC
4122.)  It provides reasonably efficient and reliable framework for generating
UUIDs and supports fairly high allocation rates -- 10 million per second per
machine -- and therefore is suitable for identifying both extremely short-lived
and very persistent objects on a given system as well as across the network.

This modules provides several methods to create a UUID:
 
   # creates binary (16 byte long binary value) UUID.
   $ug->create();
   $ug->create_bin();

   # creates binary (16-byte long binary value) UUID based on particular
   # namespace and name string.
   $ug->create_from_name(<namespace>, <name>);
   $ug->create_from_name_bin(<namespace>, <name>);

   # creates UUID string, using conventional UUID string format,
   # such as: 4162F712-1DD2-11B2-B17E-C09EFE1DC403
   $ug->create_str();
   $ug->create_from_name_str(<namespace>, <name>);

   # creates UUID string as a hex string,
   # such as: 0x4162F7121DD211B2B17EC09EFE1DC403
   $ug->create_hex();
   $ug->create_from_name_hex(<namespace>, <name>);

   # creates UUID string as a Base64-encoded string
   $ug->create_b64();
   $ug->create_from_name_b64(<namespace>, <name>);

   Binary UUIDs can be converted to printable strings using following methods:

   # convert to conventional string representation
   $ug->to_string(<uuid>);

   # convert to hex string
   $ug->to_hexstring(<uuid>);

   # convert to Base64-encoded string
   $ug->to_b64string(<uuid>);

   Conversly, string UUIDs can be converted back to binary form:

   # recreate binary UUID from string
   $ug->from_string(<uuid>);
   $ug->from_hexstring(<uuid>);

   # recreate binary UUID from Base64-encoded string
   $ug->from_b64string(<uuid>);

   Finally, two binary UUIDs can be compared using the following method:

   # returns -1, 0 or 1 depending on whether uuid1 less
   # than, equals to, or greater than uuid2
   $ug->compare(<uuid1>, <uuid2>);

Examples:

   use Data::UUID;

   # this creates a new UUID in string form, based on the standard namespace
   # UUID NameSpace_URL and name "www.mycompany.com"

   $ug = new Data::UUID;
   print $ug->create_from_name_str(NameSpace_URL, "www.mycompany.com");

=head2 EXPORT

The module allows exporting of several standard namespace UUIDs:

=over

=item NameSpace_DNS

=item NameSpace_URL

=item NameSpace_OID

=item NameSpace_X500

=back
 
=head1 AUTHOR

Alexander Golomshtok <agolomsh@cpan.org>

=head1 SEE ALSO

The Internet Draft "UUIDs and GUIDs" by Paul J. Leach and Rich Salz (RFC 4122)

=cut
