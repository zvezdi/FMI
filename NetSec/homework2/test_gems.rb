require 'ffi/pcap'

dev = FFI::PCap.device_names[0]  # or the active interface you want to get packets from
                                  # need to figure out how to select it dinamically

pcap = FFI::PCap::Live.new(:dev => dev,
                           :timeout => 1,
                           :promisc => true,
                           :handler => FFI::PCap::Handler)   # for this time, listening is active, as show with stats

pcap.stats
pcap.stats.ps_recv

pcap.datalink.describe

pakt = []

pcap.loop(:count => 1) do |this,pkt|   # :count => -1 for infinite loop, break with .breakloop method
  pakt << pkt
  puts "#{pkt.time} :: #{pkt.len}"
  pkt.body.each_byte {|x| print "%0.2x " % x }
  putc "\n"
end

puts pakt