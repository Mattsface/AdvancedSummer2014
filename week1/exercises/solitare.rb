class Cypher
	attr_accessor :string

	def initialize(string)
		@string = string
		format_string
	end

	private 
	def format_string
		remove_invalid_characters
		capatalize_characters
		group_charaters
	end

	def remove_invalid_characters
		@string = @string.tr('^A-Za-z', '')
	end

	def capatalize_characters
		@string = @string.upcase	
	end

	def group_charaters
		@string = @string.scan(/.{5}|.+/).join(" ")
	end
	
end

class Encrypter

	def initialize(message, keystream)
		@keystream = keystream
		@message = message.delete(' ')
		@en_array = []
		@alphabet = { :A => 1, :B => 2, :C => 3, :D => 4, 
		:E => 5, :F => 6, :G => 7, :H => 8, :I => 9, 
		:J => 10, :K => 11, :L => 12, :M => 13, :N => 14, 
		:O => 15, :P => 16, :Q => 17, :R => 18, :S => 19, 
		:T => 20, :U => 21, :V => 22, :W => 23, :X => 24, 
		:Y => 25, :Z => 26 }
		
	end

	def encrypt
		en_keystream = convert_to_numbers(@keystream)
		en_message = convert_to_numbers(@message)
		i = 0
		en_keystream.each do |x|	
			@en_array << combine_numbers(x, en_message[i])
			i = i + 1
		end
	end

	def convert_to_letters
		string = ""
		invert_alphabet = @alphabet.invert
		@en_array.each do |x|
			string << invert_alphabet[x].to_s
		end

		return string.scan(/.{5}|.+/).join(" ")
	end


	def combine_numbers(x, y)
		z = y + x 
		
		if z > 26 
			z = z - 26
		end

		return z 

	end


	def convert_to_numbers(string)
		
		number_string_array = []
		array_string = string.split
		array_string.each do |x|
			x.each_char do |y|
				number_string_array << @alphabet[y.to_sym].to_i	
			end	
		end
		number_string_array
	end
end

class Decrypter
	def initialize(message, keystream)
		@message = message.delete(' ')
		@keystream = keystream
		@de_array = []
		@alphabet = { :A => 1, :B => 2, :C => 3, :D => 4, 
		:E => 5, :F => 6, :G => 7, :H => 8, :I => 9, 
		:J => 10, :K => 11, :L => 12, :M => 13, :N => 14, 
		:O => 15, :P => 16, :Q => 17, :R => 18, :S => 19, 
		:T => 20, :U => 21, :V => 22, :W => 23, :X => 24, 
		:Y => 25, :Z => 26 }
	end

	def decrypt
		de_keystream = convert_to_numbers(@keystream)
		de_message = convert_to_numbers(@message)
		i = 0
		de_keystream.each do |x|	
			@de_array << combine_numbers(x, de_message[i])
			i = i + 1
		end
	end

	def combine_numbers(k, m)

		if m <= k
			m = m + 26
		end
		
		z = m - k

		return z 

	end

	def convert_to_letters
		string = ""
		invert_alphabet = @alphabet.invert
		@de_array.each do |x|
			string << invert_alphabet[x].to_s
		end

		return string.scan(/.{5}|.+/).join(" ")
	end

	def convert_to_numbers(string)
		
		number_string_array = []
		array_string = string.split
		array_string.each do |x|
			x.each_char do |y|
				number_string_array << @alphabet[y.to_sym].to_i	
			end	
		end
		number_string_array
	end
end

class Deck

  attr_accessor :cards

  def initialize
    @cards = (1..52).to_a << "A" << "B"
    @alphabet = ("A".."Z").to_a
  end

  def move_joker_a
    move_card_down(@cards.index("A"))
  end

  def move_joker_b
    2.times { move_card_down(@cards.index("B"))}
  end

  def triple_cut
    t_cut = @cards[0, find_top_joker]
    b_cut = @cards[(find_bottom_joker + 1), @cards.index(@cards.last)]
    @cards = @cards - t_cut
    @cards = @cards - b_cut
    @cards = (@cards << t_cut).flatten
    @cards = @cards.unshift(b_cut).flatten   
  end

  def count_cut
    card_value = @cards.last
    if card_value.instance_of? String
      card_value = 53
    end
    bottom_cut = @cards[0, card_value]
    @cards = @cards.drop(bottom_cut.count)
    @cards = @cards.insert((@cards.count - 1), bottom_cut).flatten
  end

  def find_top_joker
    a_index = @cards.index("A")
    b_index = @cards.index("B")
    if a_index > b_index 
      b_index
    else
      a_index
    end
  end

  def find_bottom_joker
    a_index = @cards.index("A")
    b_index = @cards.index("B")
    if a_index < b_index 
      b_index
    else
      a_index
    end
  end

  def move_card_down(index)
    if index == 53
      @cards.insert(1, @cards.delete_at(index))
    else
      @cards.insert((index + 1), @cards.delete_at(index))
    end
  end


  def get_output_letter
    n = @cards.first
    n = 53 if n.instance_of? String
    output = @cards[n]
    if output.instance_of? String
      nil
    else
      if output > 26 
        find_letter(output - 26)
      else
        find_letter(output)
      end
    end
  end

  def find_letter(output)
    @alphabet[output - 1]
  end
end

