define ganglia_server::gmetad ($gmetad_name=$title,$description=$title,$sources,$xml_port,$xml_interact_port) {
  #$sources should be a hash like
  #$sources={ "some_desc" => "$port" , "another_desc" => "$port" }
  #Write the config file from a template
  file { "/etc/ganglia/gmetad_${gmetad_name}.conf":
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("ganglia_server/gmetad.conf.erb"),
  }
  #create teh symbolic link
  file {"/usr/sbin/gmetad_${gmetad_name}":
    ensure => link,
    target => "/usr/sbin/gmetad",
  }
  file { "/etc/init.d/gmetad_${gmetad_name}":
    owner => "root",
    group => "root",
    mode => 0744,
    content => template("ganglia_server/gmetad.init.erb"),
    require => File["/etc/ganglia/gmetad_${gmetad_name}.conf"],
  }
  #Run the service
  service { "gmetad_${gmetad_name}":
    ensure => running,
    enable => true,
    require => File["/etc/init.d/gmetad_${gmetad_name}"],
    subscribe => File["/etc/ganglia/gmetad_${gmetad_name}.conf"],
  }
  #Add it to the start/stop/restart scripts?

  line { "gmetad_${gmetad_name}_start":
    ensure => present,
    file   => "/etc/ganglia/start_all",
    line   => "service gmetad_${gmetad_name} start",
  }
  line { "gmetad_${gmetad_name}_stop":
    ensure => present,
    file   => "/etc/ganglia/stop_all",
    line   => "service gmetad_${gmetad_name} stop",
  }
  line { "gmetad_${gmetad_name}_restart":
    ensure => present,
    file   => "/etc/ganglia/restart_all",
    line   => "service gmetad_${gmetad_name} restart",
  }
  file {"/var/lib/ganglia/${gmetad_name}/":
    ensure => directory,
    backup => false,
    owner => "ganglia",
    group => "ganglia",
  }
  file {"/var/lib/ganglia/${gmetad_name}/rrds":
    ensure => directory,
    backup => false,
    owner => "ganglia",
    group => "ganglia",
    require => File["/var/lib/ganglia/${gmetad_name}/"],
  }
}
