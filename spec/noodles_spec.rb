require 'noodles'

describe Noodles do
  let(:noodles) { Noodles.new }

  it 'can generate a sentence' do
    noodles.analyze_string('This is a sentence.')
    expect(noodles.generate_sentence).to eq('This is a sentence.')
  end

  it 'can generate multiple sentences' do
    noodles.analyze_string('This is a sentence.')
    expect(noodles.generate_n_sentences(3)).to eq('This is a sentence.'\
      ' This is a sentence. This is a sentence.')
  end

  it 'can analyze sentence with a lot of whitespace' do
    noodles.analyze_string(" This  is a  \n\n  sentence.  \n")
    expect(noodles.generate_sentence).to eq('This is a sentence.')
    expect(noodles.dictionary).to eq([nil, nil] => ['This'],
                                     [nil, 'This'] => ['is'],
                                     ['This', 'is'] => ['a'],
                                     ['is', 'a'] => ['sentence.'])
  end

  it 'adds a full stop automatically' do
    noodles.analyze_string('This is a sentence')
    expect(noodles.generate_sentence).to eq('This is a sentence.')
  end

  it 'generates proper dictionary' do
    noodles.analyze_string('This is a sentence.')
    expect(noodles.dictionary).to eq([nil, nil] => ['This'],
                                     [nil, 'This'] => ['is'],
                                     ['This', 'is'] => ['a'],
                                     ['is', 'a'] => ['sentence.'])
  end

  describe '#analzye_file' do
    it 'creates correct dictionary' do
      input_file = File.expand_path('../test_input.txt', __FILE__)
      noodles.analyze_file(input_file)
      expect(noodles.dictionary).to eq([nil, nil] => ['White'],
                                       [nil, 'White'] => ['cats'],
                                       ['White', 'cats'] => ['are'],
                                       ['cats', 'are'] => ['the'],
                                       ['are', 'the'] => ['best.'])
    end
  end

  describe 'saving and loading' do
    it 'can save dictionary to file' do
      dictionary_file = File.expand_path('../dictionary_file', __FILE__)
      noodles.analyze_string('Black sails at midnight')
      noodles.save_dictionary(dictionary_file)
      written_dictionary = MessagePack.unpack(File.read(dictionary_file))
      expect(written_dictionary).to eq noodles.dictionary
      File.delete(dictionary_file) if File.exist?(dictionary_file)
    end

    it 'can read dictionary from file' do
      dictionary_file = File.expand_path('../test_dictionary', __FILE__)
      noodles.load_dictionary(dictionary_file)
      expect(noodles.dictionary).to eq([nil, nil] => ['Black'],
                                       [nil, 'Black'] => ['sails'],
                                       ['Black', 'sails'] => ['at'],
                                       ['sails', 'at'] => ['midnight'])
    end
  end

  describe '#end_word?' do
    it 'returns true when . is last character' do
      expect(noodles.send(:end_word?, 'duck.')).to eq(true)
    end

    it 'returns true when ! is last character' do
      expect(noodles.send(:end_word?, 'duck!')).to eq(true)
    end

    it 'returns true when ? is last character' do
      expect(noodles.send(:end_word?, 'duck?')).to eq(true)
    end

    it 'returns false when punctuation mark is missing' do
      expect(noodles.send(:end_word?, 'duck')).to eq(false)
    end

    it 'returns false when punctuation mark is in middle of a word' do
      expect(noodles.send(:end_word?, 'du.ck')).to eq(false)
    end

    it 'returns false when nil is passed' do
      expect(noodles.send(:end_word?, nil)).to eq(false)
    end
  end

  it 'generates proper dictionary when word appears multiple times' do
    noodles.analyze_string('I like pie. I like beer.')
    expect(noodles.dictionary).to eq([nil, nil] => ['I'],
                                     [nil, 'I'] => ['like'],
                                     ['I', 'like'] => ['pie.', 'beer.'],
                                     ['like', 'pie.'] => ['I'],
                                     ['pie.', 'I'] => ['like'])
  end

  describe 'markov chains of length 1' do
    let(:noodles) { Noodles.new(1) }
    it 'generates proper dictionary' do
      noodles.analyze_string('This is a sentence.')
      expect(noodles.dictionary).to eq([nil] => ['This'],
                                       ['This'] => ['is'],
                                       ['is'] => ['a'],
                                       ['a'] => ['sentence.'])
    end

    it 'can generate a sentence' do
      noodles.analyze_string('This is a sentence.')
      expect(noodles.generate_sentence).to eq('This is a sentence.')
    end
  end

  describe 'markov chains of length 3' do
    let(:noodles) { Noodles.new(3) }
    it 'generates proper dictionary' do
      noodles.analyze_string('This is a sentence.')
      expect(noodles.dictionary).to eq([nil, nil, nil] => ['This'],
                                       [nil, nil, 'This'] => ['is'],
                                       [nil, 'This', 'is'] => ['a'],
                                       ['This', 'is', 'a'] => ['sentence.'])
    end

    it 'can generate a sentence' do
      noodles.analyze_string('This is a sentence.')
      expect(noodles.generate_sentence).to eq('This is a sentence.')
    end
  end
end
