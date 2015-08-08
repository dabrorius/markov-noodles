require_relative 'noodles'

describe Noodles do
  let(:noodles) { Noodles.new }
  it "can generate a sentence" do
    noodles.analyze_text("This is a sentence.")
    expect(noodles.generate_sentence).to eq("This is a sentence.")
  end

  it "generates proper dictionary" do
    noodles.analyze_text("This is a sentence.")
    expect(noodles.dictionary).to eq({[nil, nil]=>["This"],
                                      [nil, "This"]=>["is"],
                                      ["This", "is"]=>["a"],
                                      ["is", "a"]=>["sentence."]})
  end
end
