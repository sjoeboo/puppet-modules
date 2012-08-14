#manifest to control the ganglia server
class ganglia_server {
  include ganglia_server::install

  #To create a new gmond service/instance

  #ganglia_server::gmond {"something":
  #  description => "100% optional, defaults to $name",
  #  port => "someport# for udp and tcp",
  #}
  #

  #gmetad is similar, but more complicated because you pass it a hash:
  #ganglia_server::gmetad {"something":
  # description => "100% optional, defaults to $name",
  # sources => {
  #"some_gmond" => "gmond_port", 
  #"another_gmond" => "another_gmond_port"
  #},
  # xml_port => "some port",
  # xml_interact_port => "soem port",
  #}
  class ganglia_server::install {
    #gmond comes from the gmond module...hmm
    $packages = ["ganglia-gmetad","ganglia-gmond-python"]
    package { $packages:
      ensure => installed,
    }
  }
