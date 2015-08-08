class Noodles
  attr_reader :dictionary
  def initialize(depth=2)
    @depth = depth
    @dictionary = {}
  end

  def analyze_text(text)
    current_words = Array.new(depth)
    text_array = text.split(" ")
    while(text_array.length>0)
      next_word = text_array.shift
      add_words(current_words.dup, next_word)
      current_words.push next_word
      current_words.shift
    end
  end

  def add_words(preceding, followedby)
    raise "Preceding must be an array" unless preceding.is_a?(Array)
    raise "Followedby must be string" unless followedby.is_a?(String)
    @dictionary[preceding] ||= []
    @dictionary[preceding].push followedby
  end

  def generate_sentence
    current_words = Array.new(depth)
    sentence_array = []
    loop do
      sentence_array.push current_words.first unless current_words.first == nil
      last_word = sentence_array.last
      if is_end_word?(last_word)
        break
      end
      next_words = @dictionary[current_words]
      # If can't find any more words
      if next_words == nil
        head, *tail = current_words
        # Add everything from current words except for head, becaues
        # it's already in
        sentence_array.concat(tail)
        # If the alst word here wasn't end word, add a punctation mark
        unless is_end_word?(sentence_array.last)
          sentence_array.last.join('.')
        end
        break
      end
      next_word = next_words.sample
      puts "G #{current_words} -> #{next_word}"
      current_words.push next_word
      current_words.shift
    end
    sentence_array.join(" ")
  end

  def depth
    @depth
  end

  def is_end_word?(word)
    word != nil && word.split("").last == "."
  end

  def print
    puts @dictionary
  end
end
