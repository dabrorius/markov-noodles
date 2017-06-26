# frozen_string_literal: true

require 'msgpack'

class MarkovNoodles
  attr_reader :dictionary
  attr_reader :depth

  def initialize(depth = 2)
    @depth = depth
    @dictionary = Hash.new { |hash, missing_word| hash[missing_word] = [] }
  end

  def analyse_file(filename)
    analyse_string(File.read(filename))
  end

  def analyse_string(text)
    current_words = Array.new(depth)
    text_array = split_text_to_array(text)
    while text_array.length > 0
      next_word = text_array.shift
      add_words(current_words.dup, next_word)
      current_words.push next_word
      current_words.shift
    end
  end

  def save_dictionary(filename)
    File.open(filename, 'w') do |file|
      file.write @dictionary.to_msgpack
    end
  end

  def load_dictionary(filename)
    @dictionary = MessagePack.unpack(File.read(filename))
  end

  def generate_n_sentences(n)
    n.times.map { generate_sentence }.join(' ')
  end

  def generate_sentence
    current_words = Array.new(depth)
    sentence_array = []
    loop do
      new_word = current_words.last
      sentence_array.push new_word if new_word
      break if end_word?(new_word)
      next_word_options = @dictionary[current_words]
      if next_word_options.empty? && !end_word?(new_word)
        new_word.concat('.')
        break
      end
      next_word = next_word_options.sample
      current_words.push next_word
      current_words.shift
    end
    sentence_array.join(' ')
  end

  private

  # Splits a text into array and inserts @depth nils after each sentence.
  #
  # This way generated texts can start with any word that is at the beginning of
  # any sentence in analysed text, instead of always starting with the first
  # word from the text.
  def split_text_to_array(text)
    text_array = []
    text.split.each do |word|
      text_array.push word
      if end_word?(word)
        depth.times do
          text_array.push nil
        end
      end
    end
    text_array
  end

  def add_words(preceding, followedby)
    @dictionary[preceding].push followedby
  end

  # Checks if word ends with one of following characters .?$
  def end_word?(word)
    !word.nil? && !(word =~ /^*+[?\.!]$/).nil?
  end
end
