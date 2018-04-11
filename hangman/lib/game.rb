require './lib/colorize.rb'
require 'json'

class Game
  attr_accessor :word_letters, :good_guesses, :bad_guesses, :tries, :title

  SAVED_GAMES_FILE = "saved_games.json"
  WORDS_FILE = "words.txt"

  def initialize(title = "", word_letters = [], good_guesses = [], bad_guesses = [], tries = 10)
    words = []
    words = read_words_from_file.select { |word| word.length.between?(5, 12) }
    @word_letters = word_letters
    if @word_letters.empty?
      words.sample.each_char { |char| @word_letters << char }
    end
    @good_guesses = good_guesses
    @bad_guesses = bad_guesses
    @tries = 10
    @title = title
  end

  def start
    put_title_and_rules

    while !game_ended?
      put_word_and_tries

      input = gets.chomp
      case input
      when "exit"
        return
      when "save"
        puts "\n Enter title for this game:"
        @title = gets.chomp
        save_game
        puts "\n Game was successfully saved! Bye!".bold
        return
      when "load"
        game_titles = []
        puts "\n Available games:"
        File.readlines(SAVED_GAMES_FILE).each do |line|
          game = JSON.parse(line)
          game_titles << game['title']
          puts " #{game['title']}".magenta.bold
        end
        print "\n Enter game title: ".bold
        input_title = gets.chomp
        if game_titles.include?(input_title)
          load_game(input_title)
          puts "\n Game was successfully loaded! Continue playing \"#{input_title}\".".yellow.bold
        else
          puts "\n Sorry! Game doesn't exist.".red
        end
        next
      else
        guessed_letter = input.downcase[0]
      end

      if bad_guesses.include?(guessed_letter) || good_guesses.include?(guessed_letter)
        puts " You've already tried this letter. Try again".red
        next
      end

      if word_letters.include?(guessed_letter)
        good_guesses << guessed_letter
      else
        bad_guesses << guessed_letter
        @tries = tries - 1
      end
    end
  end

  private

    def save_game
      game = {
        title: @title,
        word_letters: @word_letters.join(" "),
        good_guesses: @good_guesses.join(" "),
        bad_guesses: @bad_guesses.join(" "),
        tries: @tries
      }
      File.open(SAVED_GAMES_FILE, 'a') { |file| file.puts game.to_json }
      return
    end

    def load_game(game_title)
      contents = File.readlines(SAVED_GAMES_FILE)
      contents.each do|line|
        game = JSON.parse(line)
        if game['title'] == game_title
          @title = game['title']
          @good_guesses = game['good_guesses'].split(" ")
          @bad_guesses = game['bad_guesses'].split(" ")
          @tries = game['tries']
          @word_letters = game['word_letters'].split(" ")
        end
      end
    end

    def game_ended?
      return true if whole_word_guessed? || tries_ended?
      false
    end

    def tries_ended?
      if tries == 0
        puts "\n You lost! The word was \"#{word_letters.join}\".".bold.blue
        puts " Bye!".bold.blue
        return true
      end
      false
    end

    def whole_word_guessed?
      word_letters.each do |letter|
        return false unless good_guesses.include?(letter)
      end
      put_word
      puts "\n\n Hooray! You won!".bold.blue
      true
    end

    def read_words_from_file
      words = []
      contents = File.readlines(WORDS_FILE)
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
       puts "  You have #{tries} tries.".magenta
       puts "\n  Enter:"
       puts "    [single letter] - to guess a letter,"
       puts "    save - to save your game,"
       puts "    load - to load saved game,"
       puts "    exit - to exit the game."
       puts "\n\n GAME STARTS NOW!".magenta.bold
       puts "\n The word contains #{word_letters.length} letters:\n\n"
    end

    def put_word
      puts "\n ****************************************"
      print "\n  "
      word_letters.each do |letter|
        if good_guesses.include?(letter)
          print "#{letter} ".upcase.magenta.bold
        else
          print "_ ".magenta.bold
        end
      end
    end

    def put_word_and_tries
      put_word
      puts "\n\n You have #{tries} bad guess#{tries > 1 ? "es" : ""} left.".yellow
      puts " Bad guesses: #{bad_guesses.join(", ")}.".bold unless bad_guesses.length == 0
      print " Guess a letter: ".bold
    end
end
