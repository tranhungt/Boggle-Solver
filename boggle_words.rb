require 'set'

class Boggle
  def initialize(size)
  @board_size = size
  end

  def play
    start_time = Time.now
    dict = import_dict
    dictionary_time = Time.now
    board = generate_board
    @index_hash = generate_index_hash(board)
    @letters_hash = generate_letters_hash(board)
    narrow_dictionary(dict)
    print_board(board)

    words_found = []
    dict.each do |first_letter, words|
      words.each do |word|
        @letters_hash[first_letter].each do |coord|
          used_coords = Set.new([coord])
          index = first_letter == 'qu' ? 2 : 1
          last_coord = coord
          found = get_word_chain(word, index, used_coords, last_coord)
          words_found << word if found
        end
      end
    end
    puts ''
    finished_time = Time.now
    p words_found.select{|word| word.length > 1}.uniq
    puts ''
    puts "Time to import dictionary: #{dictionary_time - start_time}"
    puts "Time to finish algorithm: #{finished_time - start_time}"
    puts "Total time: #{finished_time - start_time}"
  end

  def get_word_chain(word, index, used_coords, at_coord)
    return true if index == word.length()
    letter = word[index]
    q_found = false
    if letter == 'q'
      letter = 'qu'
      q_found = true
    end

    containing_neighbors = get_containing_neighbors(at_coord, word[index], used_coords)
    containing_neighbors.each do |neighboring_coord|
      dup_used_coords = used_coords.clone
      dup_used_coords << neighboring_coord
      return get_word_chain(word, index +2, dup_used_coords, neighboring_coord) if q_found
      return get_word_chain(word, index +1, dup_used_coords, neighboring_coord)
    end
    return false
  end

  def get_neighbors(coord)
    y,x = coord
    neighbors = []
    [-1, 0, 1].each do |dy|
      [-1, 0, 1].each do |dx|
        temp_coord = [y + dy, x + dx]
        if valid_coord?(temp_coord) && temp_coord != coord
          neighbors.push(temp_coord)
        end
      end
    end
    neighbors
  end

  def get_containing_neighbors(at_coord, letter, used_coords)
    neighbors = get_neighbors(at_coord)
    containing_neighbors = []
    neighbors.each do |coord|

      if !used_coords.include?(coord) && @index_hash[coord] == letter
        containing_neighbors << coord
      end
    end
    if containing_neighbors.length > 0
      return containing_neighbors
    else
      return []
    end
  end

  def valid_coord?(coord)
    y,x = coord
    return y >= 0 && y <= @board_size && x <= @board_size && x >= 0
  end

  def print_board(board)
    board.each do |row|
      p row.map{|letter| letter.capitalize}
    end
  end

  #Generating data structures / Initial values

  def generate_index_hash(board)
    index_hash = {}
    index_hash.default = []
    board.each_with_index do |row, y|
      row.each_with_index do |letter, x|
        index_hash[[y,x]] = letter
      end
    end
    index_hash
  end

  def generate_letters_hash(board)
    letters_hash = {}
    letters_hash.default = []
    board.each_with_index do |row, y|
      row.each_with_index do |letter, x|
        if letters_hash[letter].empty?
          letters_hash[letter] = [[y,x]]
        else
          letters_hash[letter] << [y,x]
        end
      end
    end
    letters_hash
  end

  def generate_board
    letters = ('a'..'z').to_a
    q_index = letters.index('q')
    letters[q_index] = 'qu'
    board = Array.new(@board_size){ Array.new(@board_size) {letters.sample}}
  end

  def import_dict
    dict = {}
    dict.default = []
    File.open('word_list.txt').each do |line|
      word = line.strip.downcase
      first_letter = word[0]
      if word[0,2] == 'qu'
        if dict['qu'].empty?
          dict['qu'] = [word]
        else
          dict['qu'] << word
        end
      elsif dict[first_letter].empty?
        dict[first_letter] = [word]
      else
        dict[first_letter] << word
      end
    end
    dict
  end

  def narrow_dictionary(dict)
    dict.select! do |k, v|
      @letters_hash.keys.include?(k)
    end
  end
end

game = Boggle.new(6)
game.play