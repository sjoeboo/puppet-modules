class samba {
	include samba::install, samba::service
}

class samba::install {
	package { ["samba","samba-client","samba-common","samba-winbind","samba-winbind-krb5-locator","krb5-workstation"]:
		ensure=>present,
	}
}
class samba::service {
	service {"smb":
		ensure => running,
		hasstatus => true,
		hasrestart => true,
		enable => true,
		require => Class["samba::install"],
	}
	service {"nmb":
		ensure => running,
		hasstatus => true,
		hasrestart => true,
		enable => true,
		require => Class["samba::install"],
	}
	service {"winbind":
		ensure     => running,
		hasstatus  => true,
		hasrestart => true,
		enable     => true,
		require    => Class["samba::install"],
	}	
}

define samba::config ($includeconf=""){
	include samba
	file {"/usr/local/bin/joindomain.sh":
		source => "puppet:///samba/joindomain.sh",
		mode   => 0777,
		owner  => root,
		group  => root,
	}
	file {"/etc/samba/smb.conf":
		content =>template('samba/smb.conf.erb'),
		owner   =>root,
		group   =>root,
		mode    =>664,
		require => Class["samba::install"],
		notify  => Exec["joindomain"],
	}
	exec {"joindomain":
                command => "/usr/local/bin/joindomain.sh",
		refreshonly           => true,
		require               => File["/usr/local/bin/joindomain.sh"],
		notify                => Class["samba::service"],
	}
}

define samba::share($name,$path,$writeable='yes',$create_mask='0774',$dir_mask='0774',$hosts_allow="",$hosts_deny="",$template='samba/smb_share.conf.erb') {
	#Defines a samba server, with one share, bound to RC AD. 
	#include samba::config
	
	file {"/etc/samba/smb_$name.conf":
		content=>template($template),
		owner=>root,
		group=>root,
		mode=>664,
		notify => Class["samba::service"],
	}
}
