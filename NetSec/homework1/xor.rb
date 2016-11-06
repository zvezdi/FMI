# This script can be evoked with
# $ ruby xor.rb text.txt pad.bin [output_file]

# get the command line params
plain_text_file = ARGV[0]
pad_file = ARGV[1]
cipher_text_file = ARGV[2] || "cipher_text.bin"

# text, pad ---xor---> cipher_text
File.open(plain_text_file, 'rb') do |text|
  File.open(pad_file, 'rb') do |pad|
    File.open(cipher_text_file, 'wb') do |out|
      pad_bytes = pad.read.bytes.collect
      out.write(
        text.read.bytes.collect do |byte|
          begin
            byte ^ pad_bytes.next
          rescue
            raise "Pad must be longer than the text you whant to cipher with it"
          end
        end.pack("C*")
      )
      puts "#{cipher_text_file} was created in the currennt directory"
    end
  end
end
