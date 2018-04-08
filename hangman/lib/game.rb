require_relative 'colorize.rb'

class Game
  attr_reader :word_letters, :good_guesses, :bad_guesses, :tries

  def initialize
    words = []
    words = read_words_from_file.select { |word| word.length.between?(5, 12) }
    @word_letters = []
    words.sample.each_char { |char| @word_letters << char }
    @good_guesses = []
    @bad_guesses = []
    @tries = 10
  end

  def start
    put_title_and_rules
    puts "Word: #{@word_letters.join}"
    while !game_ended?
      put_word_and_tries

      guessed_letter = gets.chomp.downcase[0]

      if @bad_guesses.include?(guessed_letter) || @good_guesses.include?(guessed_letter)
        puts " You've already tried this letter. Try again".red
        next
      end

      if @word_letters.include?(guessed_letter)
        @good_guesses << guessed_letter
      else
        @bad_guesses << guessed_letter
      end

      @tries -= 1 if @bad_guesses.include?(guessed_letter)
    end

  end

  private

    def game_ended?
      return true if whole_word_guessed? || tries_ended?
      false
    end

    def tries_ended?
      if @tries == 0
        puts "\n You lost! The word was \"#{@word_letters.join}\".".bold.blue
        puts " Bye!".bold.blue
        return true
      end
      false
    end

    def whole_word_guessed?
      @word_letters.each do |letter|
        return false unless @good_guesses.include?(letter)
      end
      put_word
      puts "\n\n Hooray! You won!".bold.blue
      true
    end

    def read_words_from_file
      words = []
      contents = File.readlines("words.txt")
      contents.each do |line|
        words << line.downcase[0..-3]
      end
      words
    end

    def put_title_and_rules
      puts "
       ██░ ██  ▄▄▄       ███▄    █   ▄████  ███▄ ▄███▓ ▄▄▄       ███▄    █
      ▓██░ ██▒▒████▄     ██ ▀█   █  ██▒ ▀█▒▓██▒▀█▀ ██▒▒████▄     ██ ▀█   █
      ▒██▀▀██░▒██  ▀█▄  ▓██  ▀█ ██▒▒██░▄▄▄░▓██    ▓██░▒██  ▀█▄  ▓██  ▀█ ██▒
      ░▓█ ░██ ░██▄▄▄▄██ ▓██▒  ▐▌██▒░▓█  ██▓▒██    ▒██ ░██▄▄▄▄██ ▓██▒  ▐▌██▒
      ░▓█▒░██▓ ▓█   ▓██▒▒██░   ▓██░░▒▓███▀▒▒██▒   ░██▒ ▓█   ▓██▒▒██░   ▓██░
       ▒ ░░▒░▒ ▒▒   ▓▒█░░ ▒░   ▒ ▒  ░▒   ▒ ░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒░   ▒ ▒
       ▒ ░▒░ ░  ▒   ▒▒ ░░ ░░   ░ ▒░  ░   ░ ░  ░      ░  ▒   ▒▒ ░░ ░░   ░ ▒░
       ░  ░░ ░  ░   ▒      ░   ░ ░ ░ ░   ░ ░      ░     ░   ▒      ░   ░ ░
       ░  ░  ░      ░  ░         ░       ░        ░         ░  ░         ░".blue

       puts "\n  HOW TO PLAY:".magenta.bold
       puts "  Try to guess a word the computer picked randomly.".magenta
       puts "  You have #{@tries} tries.".magenta
       puts "\n\n The word contains #{@word_letters.length} letters:\n\n"
    end

    def put_word
      print "\n  "
      @word_letters.each do |letter|
        if @good_guesses.include?(letter)
          print "#{letter} ".upcase.magenta.bold
        else
          print "_ ".magenta.bold
        end
      end
    end

    def put_word_and_tries
      put_word
      puts "\n\n You have #{@tries} bad guess#{@tries > 1 ? "es" : ""} left.".yellow
      puts " Bad guesses: #{@bad_guesses.join(", ")}.".bold unless @bad_guesses.length == 0
      print " Guess a letter: "
    end
end

a = Game.new
a.start
