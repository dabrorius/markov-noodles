require_relative 'noodles'

describe Noodles do
  let(:noodles) { Noodles.new }
  it "can generate a sentence" do
    noodles.analyze_text("This is a sentence.")
    expect(noodles.generate_sentence).to eq("This is a sentence.")
  end

  it "adds a full stop automatically" do
    noodles.analyze_text("This is a sentence")
    expect(noodles.generate_sentence).to eq("This is a sentence.")
  end

  it "generates proper dictionary" do
    noodles.analyze_text("This is a sentence.")
    expect(noodles.dictionary).to eq({[nil, nil]=>["This"],
                                      [nil, "This"]=>["is"],
                                      ["This", "is"]=>["a"],
                                      ["is", "a"]=>["sentence."]})
  end

  it "generates proper dictionary when word appears multiple times" do
    noodles.analyze_text("I like pie. I like beer.")
    expect(noodles.dictionary).to eq({[nil, nil]=>["I"],
                                      [nil, "I"]=>["like"],
                                      ["I", "like"]=>["pie.", "beer."],
                                      ["like", "pie."]=>["I"],
                                      ["pie.", "I"]=>["like"]})
  end

  describe "markov chains of length 1" do
    let(:noodles) { Noodles.new(1) }
    it "generates proper dictionary" do
      noodles.analyze_text("This is a sentence.")
      expect(noodles.dictionary).to eq([nil]=>["This"],
                                               ["This"]=>["is"],
                                               ["is"]=>["a"],
                                               ["a"]=>["sentence."])
    end

    it "can generate a sentence" do
      noodles.analyze_text("This is a sentence.")
      expect(noodles.generate_sentence).to eq("This is a sentence.")
    end
  end

  describe "markov chains of length 3" do
    let(:noodles) { Noodles.new(3) }
    it "generates proper dictionary" do
      noodles.analyze_text("This is a sentence.")
      expect(noodles.dictionary).to eq([nil, nil, nil]=>["This"],
                                               [nil, nil, "This"]=>["is"],
                                               [nil, "This", "is"]=>["a"],
                                               ["This", "is", "a"]=>["sentence."])
    end

    it "can generate a sentence" do
      noodles.analyze_text("This is a sentence.")
      expect(noodles.generate_sentence).to eq("This is a sentence.")
    end
  end
end
