package Uploader;

use Util;
use strict;

sub new() {

  my $proto = shift;
  my $auditdir = shift;
  my $self={};
  bless($self, $proto);

  # check if the audit directory had been passed as argument
  if (Util::trim($auditdir) eq "") {
      Util::error("No audit directory specified in constructor of Uploader");
  } else {
      $self->{'auditdir'} = $auditdir;
  }
  return $self;
}

sub loadGram2RecordsIntoDatabase() {

    my $self = shift;
    my $conf = shift;
    my $expectErrors = shift;
    my $expectedNumberLeftoverRecords = shift;
    my $uploader = "$ENV{GLOBUS_LOCATION}/libexec/globus-gram-audit";
    my $uploaderArgs = "--conf $conf --check --delete --audit-directory " . $self->{'auditdir'};

    $uploaderArgs .= "> /dev/null 2>/dev/null" unless ($ENV{TEST_DEBUG});
    
    if (! -e $uploader) {
        Util::error("Can't find " . $uploader . " to upload records");
        return (0 == 1);
    } else {
        # load the records into the database
        my $rcx = system("$uploader $uploaderArgs");
        
        if ($expectErrors == 0) {
            if ($rcx != 0) {
                Util::error("Error during upload, but did not expect errors");
                return (0 == 1);
            }
        } else {
            if ($rcx == 0) {
                Util::error("Expected errors, but uploader returned success");
                return (0 == 1);        
            }
        }
    }
    
    # verify that the number of leftover files in the audit
    # directory fits with the number of expected errors
    Util::debug("Checking for " . $expectedNumberLeftoverRecords .
        " leftover audit record files after upload in " . $self->{'auditdir'});    
    my @leftoverFiles = glob($self->{'auditdir'}."/*.gramaudit");
    my $count = @leftoverFiles;
    if ($count != $expectedNumberLeftoverRecords) {
        Util::error("Expected " . $expectedNumberLeftoverRecords . 
            " leftover files, but " . $count . " files are left over");
        return (0 == 1);                           
    }

    return (0 == 0);
}

1;
