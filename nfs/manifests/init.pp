#
# Module: nfs
#
#  Created by  on 2012-01-03.
#  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
#
# Define:
#  Manges NFS hosts 
#
# Parameters:
#
#   
# Actions:
#
# Requires:
#
# Sample Usage:
# (start code)
# (end)
class nfs::server {
	include nfs::service

#Simple, Just manage an exports file for each host...
#To use this just create the exports file as $hostname.exports
	file { "/etc/exports":
		ensure => present,
		owner => root,
		group => root,
		mode => 0644,
		source => "puppet:///nfs/$hostname.exports"
	}
	file {"/etc/sysconfig/nfs":
		ensure=>present,
		owner=>root,
		group=>root,
		mode=>0644,
		source=>"puppet:///nfs/sysconfig_nfs"
	}
}

class nfs::install {
	package {"nfs-utils":
		ensure => installed,
	}
}

class nfs::service{
	service {"nfs":
		ensure => running,
		hasstatus => true,
		hasrestart => true,
		enable => true,
		require => Class["nfs::install"],
	}
}
