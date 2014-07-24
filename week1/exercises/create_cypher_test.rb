require './solitare.rb'
require 'optparse'
require 'ostruct'
  


options = Optparsesolitare.parse(ARGV)
# this needs better logic obviously, but lets make it work to start
# if we are decrypting, then we require a input key-stream
# if we are encrypting, then we require a output key-stream
# for now we'll assume that -k or -x isn't nil 

if options.decrypt
  decrypter = Encrypter.new(options.decrypt, options.key)
  decrypter.decrypt
  puts decrypter.convert_to_letters
elsif options.encrypt
  
  message = Cypher.new(options.encrypt)
  deck = Deck.new
  length = message.string.delete(' ').length
  keystream = ""

  while keystream.length < length
    deck.move_joker_a
    deck.move_joker_b
    deck.triple_cut
    deck.count_cut
    c = deck.get_output_letter
    if c
      keystream << c
    end
  end

  encrypter = Encrypter.new(message.string, keystream)
  encrypter.encrypt
  puts encrypter.convert_to_letters
  puts keystream
else
  puts "No argument supplied"
  exit
end

