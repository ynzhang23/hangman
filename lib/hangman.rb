require 'pry-byebug'
require 'erb'
require 'csv'

class Player
  attr_accessor :lives_left, :name, :guess, :guesses

  def initialize()
    puts "What is your name?"
    @name = gets.chomp
    @lives_left = 7
    @guesses = []
  end

  def get_guess()
    # Get Player's guess
    @guess = '.'
    until @guess.length == 1 && @guess.match?(/^[[:alpha:]]+$/)
      puts "Guess an alphabet: "
      @guess = gets.chomp.downcase
    end
    @guesses.push(@guess)
    @guess
  end
end

class Word
  attr_reader :word, :feedback, :feedback_array

  def initialize
    @word = Word.generate_word
    @word_array = @word.split('')
    @feedback_array = Array.new(@word.length, "_")
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

  def update_feedback(guess)
    result = 'incorrect'
    # Replace the __ in the @feedback at the corresponding array position with the alphabet 
    @word_array.each_with_index do |letter, index|
      if letter == guess
        @feedback_array[index] = letter
        result = 'correct'
      end
    end
    # If result is incorrect, return
    return result
  end

end

puts "
█░█ ▄▀█ █▄░█ █▀▀ █▀▄▀█ ▄▀█ █▄░█
█▀█ █▀█ █░▀█ █▄█ █░▀░█ █▀█ █░▀█"

# Initialize player
player = Player.new

# Initialize word
word = Word.new
puts word.word

# Get player guess
player.get_guess

# Provide feedback
if word.update_feedback(player.guess) == "incorrect"
  player.lives_left -= 1
end

# Update player with lives left
puts "#{player.name}, you currently have #{player.lives_left} lives left!"