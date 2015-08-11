# Markov chain generation with Noodles

Noodles is a minimalistic library for generating text using Markov chains.

## Installation
```
gem install noodles
```

## Usage

Here's an example of analysing a string and generating a sentence.

```ruby
noodle = Noodles.new
noodle.analyse_string('Here is a string.')
noodle.generate_sentence
```

Here's an example of analysing a text file and generating multiple sentences.

```ruby
noodle = Noodles.new
noodle.analyse_file('input.txt')
noodle.generate_n_sentences(10)
```

You can save and load dictionaries.

```ruby
noodle = Noodles.new
noodle.analyse_string('Here is a string.')
noodle.save_dictionary('saved_dictionary.dict')

# after a while...

noodle_two = Noodles.new
noodle_two.load_dictionary('saved_dictionary.dict')
noodle_Two.genereate_sentence
```
Default dictionary depth is two but you can change it during initialization.

```ruby
so_deep = Noodles.new(3) # => creates a dictionary of depth 3
```

## So what exactly does this do?

This library uses Markov chains to generate superficially real-looking text
given a sample document. This method has been used to generate [comics](http://joshmillard.com/garkov/)
as well as [math research papers](http://thatsmathematics.com/mathgen/) that even
got accepted by a [journal](http://thatsmathematics.com/blog/archives/102).

You should feed it a lot of text in order to get good results. If there's not
enough data to work with it will just keep re-using same sentences that were in
original document.

Here's a simple example of generated 'original' sentence with very minimal input.

```
noodle = Noodles.new
noodle.analyse_string("I like pie and eat it. I like pony and eat with it")
noodle.generate_sentence # => "I like pie and eat with it."  
```

Here's an example text I got from analysing Adventures of Huckleberry Finn by Mark Twain.

> He grabbed his gun across his left hand, says the great tragedy will be glad when he was back and got into my window just before day was breaking. Why, what in the nation do they will mention it to labboard, in the world let me suffer; can bear it. We got an old hair trunk with the family, and a round ball, and lots of things was scattered about we reckoned the duke's great-grandfather and all that. Miss Watson would say, over a dead, dull, solid blue, like a fishing-worm, and let them go by; and told me why, and I didn't go.  Here, I'll put a good big cavern in the crowd, though maybe not for kingdoms.

Good luck, have fun!
