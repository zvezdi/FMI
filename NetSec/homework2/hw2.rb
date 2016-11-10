require 'ffi/pcap'

def print_mac_addr_info(packet)
  frame = packet.body
  destination, source, type = [], [], []
  frame[0..5].each_byte { |x| destination << "%0.2x" %x }
  frame[6..11].each_byte { |x| source << "%0.2x" %x }
  frame[12..13].each_byte { |x| type << "%0.2x" %x }

  puts destination.join(':') + " " + source.join(':') + " 0x"  + type.join
end

def offline_pcap_mac_info(input_file)
  input_file = FFI::PCap::Offline.new(input_file)
  input_file.each do |this, packet|
    print_mac_addr_info(packet)
  end
end

offline_pcap_mac_info("hw2.pcap")