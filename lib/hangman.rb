require 'pry-byebug'
require 'erb'
require 'yaml'

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
    until @guess.length == 1 && @guess.match?(/^[[:alpha:]]+$/) && !@guesses.include?(@guess)
      puts "Guess an alphabet: "
      @guess = gets.chomp.downcase
      if @guesses.include?(@guess)
        puts "You have already guessed that letter."
      end
    end
    @guesses.push(@guess)
    @guess
  end
end

class Word
  attr_reader :word, :feedback_array

  def initialize
    @word = Word.generate_word
    @word_array = @word.split('')
    @feedback_array = Array.new(@word.length, " _ ")
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
    # Replace the __ in the @feedback_array at the corresponding array position with the alphabet 
    @word_array.each_with_index do |letter, index|
      if letter == guess
        @feedback_array[index] = " #{letter} "
        result = 'correct'
      end
    end
    # If result is incorrect, return
    return result
  end
end

def save_game(player_name, player_lives_left, player_guesses, word_word, word_feedback_array)
  # Create a hash of values to be saved
  data = {
    name: player_name,
    lives_left: player_lives_left,
    guesses: player_guesses,
    word: word_word,
    feedback_array: word_feedback_array
  }
  
  # Set up file naming system
  Dir.mkdir('saves') unless Dir.exist?('saves')
  filename = "#{player_name}.yml"

  # Writing into the file
  File.open("saves/#{filename}", 'w') {|file| file.write(data.to_yaml)}
end

def load_game
end

puts "
█░█ ▄▀█ █▄░█ █▀▀ █▀▄▀█ ▄▀█ █▄░█
█▀█ █▀█ █░▀█ █▄█ █░▀░█ █▀█ █░▀█

"

# Initialize player
player = Player.new

# Initialize word
word = Word.new
puts word.word

# Loop guess as long as player has more than 0 lives AND feedback_array still has unknown characters
while player.lives_left > 0 && word.feedback_array.include?(' _ ')
  puts ""

  # Ask if player wants to save a game
  player_save_choice = ''
  until player_save_choice == "Y" || player_save_choice == "N"
    puts "Do you want to save? (Y/N)"
    player_save_choice = gets.chomp
  end
  if player_save_choice == "Y"
    save_game(player.name, player.lives_left, player.guesses, word.word, word.feedback_array)
    exit
  end

  # Get player guess
  player.get_guess

  # Provide feedback
  if word.update_feedback(player.guess) == "incorrect"
    player.lives_left -= 1
  end

  # Update player with lives left, their guesses and feedback
  puts "
  #{word.feedback_array.join}
  "
  puts "================================================================================"
  puts "#{player.name}, you currently have #{player.lives_left} lives left!"
  puts "Guessed: #{player.guesses.join(', ')}"
  puts "================================================================================"
end

# Output final screen message
if word.feedback_array.include?(' _ ')
  puts "
  █▄█ █▀█ █░█   █░░ █▀█ █▀ █▀▀
  ░█░ █▄█ █▄█   █▄▄ █▄█ ▄█ ██▄
  "
else
  puts "
  █▄█ █▀█ █░█   █░█░█ █ █▄░█
  ░█░ █▄█ █▄█   ▀▄▀▄▀ █ █░▀█
  "
end