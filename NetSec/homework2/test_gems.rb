require 'rubygems'
require 'ffi/pcap'

pcap =
  FFI::PCap::Live.new(:dev => 'lo0',
                      :timeout => 1,
                      :promisc => true,
                      :handler => FFI::PCap::Handler)

pcap.setfilter("icmp")

pcap.loop() do |this,pkt|
  puts "#{pkt.time}:"

  pkt.body.each_byte {|x| print "%0.2x " % x }
  putc "\n"
end