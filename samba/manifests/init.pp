class samba {
	include samba::install, samba::service
}

class samba::install {
	package { ["samba","samba-client","samba-common"]:
		ensure=>present
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
}

define samba::config ($includeconf=""){
	include samba
	
	file {"/etc/samba/smb.conf":
		content=>template('samba/smb.conf.erb'),
		owner=>root,
		group=>root,
		mode=>664,
		require => Class["samba::install"],
		notify => Class["samba::service"],
	}
}

define samba::share($name,$path,$writeable='yes',$create_mask='0774',$dir_mask='0774',$hosts_allow="",$hosts_deny="",$template='samba/smb_share.conf.erb') {
	file {"/etc/samba/smb_$name.conf":
		content=>template($template),
		owner=>root,
		group=>root,
		mode=>664,
		notify => Class["samba::service"],
	}
}
