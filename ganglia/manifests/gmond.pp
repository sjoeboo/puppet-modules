define ganglia_server::gmond ($gmond_name = $title, $description = $title, $port) {
  #Write the config file from a template
  file { "/etc/ganglia/gmond_${gmond_name}.conf":
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("ganglia_server/gmond.conf.erb"),
  }
  #We create a symlink for the daemon...
  file {"/usr/sbin/gmond_${gmond_name}":
    ensure => link,
    target => "/usr/sbin/gmond",
  }
  #Write the init script from a template
  file { "/etc/init.d/gmond_${gmond_name}":
    owner => "root",
    group => "root",
    mode => 0744,
    content => template("ganglia_server/gmond.init.erb"),
    require => File["/etc/ganglia/gmond_${gmond_name}.conf"],
  }
  #Run the service
  service { "gmond_${gmond_name}":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => File["/etc/init.d/gmond_${gmond_name}"],
    subscribe => File["/etc/ganglia/gmond_${gmond_name}.conf"],
  }
  #Add it to the start/stop/restart scripts?

  line { "gmond_${gmond_name}_start":
    ensure => present,
    file   => "/etc/ganglia/start_all",
    line   => "service gmond_${gmond_name} start",
  }
  line { "gmond_${gmond_name}_stop":
    ensure => present,
    file   => "/etc/ganglia/stop_all",
    line   => "service gmond_${gmond_name} stop",
  }
  line { "gmond_${gmond_name}_restart":
    ensure => present,
    file   => "/etc/ganglia/restart_all",
    line   => "service gmond_${gmond_name} restart",
  }
}
