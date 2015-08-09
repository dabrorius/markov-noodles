require 'msgpack'

class Noodles
  attr_reader :dictionary

  def initialize(depth=2)
    @depth = depth
    @dictionary = {}
  end

  def analyze_file(filename)
    analyze_string(File.read(filename))
  end

  def analyze_string(text)
    current_words = Array.new(depth)
    text_array = text.split
    while(text_array.length > 0)
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
    text = ""
    n.times do |i|
      text.concat(generate_sentence)
      unless i == (n-1)
        text.concat(" ")
      end
    end
    text
  end

  def generate_sentence
    current_words = Array.new(depth)
    sentence_array = []
    loop do
      new_word = current_words.last
      if new_word
        sentence_array.push new_word 
      end
      if is_end_word?(new_word)
        break
      end
      next_word_options = @dictionary[current_words]
      if next_word_options == nil
        unless is_end_word?(new_word)
          new_word.concat('.')
        end
        break
      end
      next_word = next_word_options.sample
      current_words.push next_word
      current_words.shift
    end
    sentence_array.join(" ")
  end

  def depth
    @depth
  end

  private

  def add_words(preceding, followedby)
    raise "Preceding must be an array" unless preceding.is_a?(Array)
    raise "Followedby must be a string" unless followedby.is_a?(String)
    @dictionary[preceding] ||= []
    @dictionary[preceding].push followedby
  end

  def is_end_word?(word)
    word != nil && (word =~ /^*+[?\.!]$/) != nil
  end
end
