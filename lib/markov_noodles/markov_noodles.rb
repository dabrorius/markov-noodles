# frozen_string_literal: true

require 'msgpack'

# This is the main MarkovNoodles class.
class MarkovNoodles
  # The dictionary managed by this instance. This is a hash, with
  # array keys (length depending on {#depth}), and array values.
  # @return [Hash{Array<String> => Array<String>}] the dictionary
  attr_reader :dictionary

  # The depth of Markov chains. This defines how many elements are in the
  # hash keys of {#dictionary}.
  attr_reader :depth

  # Create a new MarkovNoodles instance with an empty dictionary.
  # @param [Integer] depth the depth of the markov chain.
  # @return [MarkovNoodles] the new MarkovNoodles instance.
  def initialize(depth = 2)
    @depth = depth
    @dictionary = Hash.new { |hash, missing_word| hash[missing_word] = [] }
  end

  # Analyses a file and integrates it into the dictionary.
  # All this does is pass `File.read(filename)` to {#analyse_string}.
  # @param [String] filename the name of the file to analyse
  def analyse_file(filename)
    analyse_string(File.read(filename))
  end

  # Analyses a string and integrates it into the dictionary.
  # @param [String] text the text to analyse
  def analyse_string(text)
    current_words = Array.new(depth)
    text_array = split_text_to_array(text)
    until text_array.empty?
      next_word = text_array.shift
      add_words(current_words.dup, next_word)
      current_words.push next_word
      current_words.shift
    end
  end

  # Saves the dictionary in this instance to a file, to be restored later by {#load_dictionary}.
  # Note that this overwrites the given file!
  # @param [String] filename the name of the file to store the dictionary in
  def save_dictionary(filename)
    File.write(filename, @dictionary.to_msgpack, mode: 'w')
  end

  # Loads a dictionary saved with {#save_dictionary} into this instance.
  # @param [String] filename the name of the file to restore the dictionary from
  def load_dictionary(filename)
    @dictionary = MessagePack.unpack(File.read(filename))
  end

  # Generates the specified amount of sentences using {#generate_sentence}, separating them with spaces.
  # @param [Integer] n the amount of sentences to generate
  # @return [String] the generated sentences separated by spaces
  def generate_n_sentences(n)
    Array.new(n) { generate_sentence }.join(' ')
  end

  # Generates a single sentence, using the current dictionary.
  # @return [String] the generated sentence
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

  # Splits a text into array and inserts {#depth} nils after each sentence.
  #
  # This way generated texts can start with any word that is at the beginning of
  # any sentence in analysed text, instead of always starting with the first
  # word from the text.
  def split_text_to_array(text)
    text_array = []
    text.split.each do |word|
      text_array.push word

      next unless end_word?(word)
      depth.times do
        text_array.push nil
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
