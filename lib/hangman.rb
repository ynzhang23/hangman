require 'pry-byebug'
require 'erb'
require 'csv'

class Player
  def initialize()
    puts "What is your name?"
    @name = gets
    @lives_left = 7
  end
end

class Word
  attr_reader :word
  def initialize
    @word = Word.generate_word
  end

  def Word.generate_word
    words = []
    # Convert the words in word list txt into an array
    File.open('google-10000-english-no-swears.txt', 'r') do |file|
      until file.eof?
        words.push(file.gets.chomp)
      end
    end
    # Filter array into words between 5 and 12 characters long
    words.select! {|word| word.length >= 5 && word.length <= 12}
    # Randomly select a word from the array
    words.sample
  end
end

puts "
█░█ ▄▀█ █▄░█ █▀▀ █▀▄▀█ ▄▀█ █▄░█
█▀█ █▀█ █░▀█ █▄█ █░▀░█ █▀█ █░▀█"

puts word = Word.new
puts word.word