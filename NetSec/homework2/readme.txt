NAME
       hw2 - print destination mac addr, source mac addr and type
       for tcpdump capture file (little-endian) file

SYNOPSIS
       ruby hw2.rb path/to/file.pcap

DESCRIPTION
       hw2.rb reads the packet body from the frame (for each packet in the file),
       gets first 6 bytes for destination mac address,
       second 6 bytes for source mac address and next 2 for type and prints them to stdout


REQUIREMENTS
      ruby - tested on ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
      ffi-pcap - gem can be installed with gem installed ffi-pcap
      or could be found on github https://github.com/sophsec/ffi-pcap
