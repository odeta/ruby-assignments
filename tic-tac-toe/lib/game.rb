require_relative 'player'
require 'colorize'
class Game
  attr_accessor :board, :player1, :player2

  def initialize(board = Hash[(1..9).map { |e| [e, '-'] }],
                player1 = Player.new,
                player2 = Player.new)
    @board = board
    @player1 = player1
    @player2 = player2
  end

  def start
    display_rules
    set_up_players

    until ended?
      play_a_turn(@player1)
      return if ended?
      play_a_turn(@player2)
    end

    if a_winner?(player1)
      display_board
      puts "#{player1.name} won!".magenta.bold
    elsif a_winner?(player2)
      display_board
      puts "#{player2.name} won!".magenta.bold
    else
      display_board
      puts "Draw!".magenta.bold
    end
  end

  # private
    def display_board
      puts
      @board.map do |pos, symb|
        print pos % 3 == 0 ? "#{symb}\n".magenta : "#{symb.to_s} ".magenta
      end.join(" ")
      puts
    end

    def display_rules
      puts "Hi, to play this game you should".magenta
      puts "enter one integer, which must be".magenta
      puts "between 1 and 9, like in this".magenta
      puts "************************************".magenta
    end

    def put_symbol(pos, symbol)
      return false unless @board[pos] == '-'
      @board[pos] = symbol
      true
    end

    def set_up_players
      puts "First player name:".cyan.bold
      @player1.name = gets.chomp
      puts "...and symbol (enter 1 for 'X', 2 for 'O'):".cyan
      @player1.symbol =
        case gets.match(/\d+/)[0].to_i
        when 1 then 'X'
        when 2 then 'O'
        else ''
        end
      while @player1.symbol == ''
        puts "Try again (enter 1 for 'X', 2 for 'O'):".cyan
        @player1.symbol =
          case gets.match(/\d+/)[0].to_i
          when 1 then 'X'
          when 2 then 'O'
          else ''
          end
      end
      puts "\n#{@player1.name} is #{@player1.symbol}s.\n".cyan
      puts "Second player name:".cyan.bold
      @player2.name = gets.chomp
      @player2.symbol = @player1.symbol == 'X' ? 'O' : 'X'
      puts "\n#{@player2.name} is #{@player2.symbol}s.\n".cyan
    end

    def play_a_turn(player)
      display_board
      puts "#{player.name}'s turn.".cyan.bold
      puts "Enter a position:".magenta
      num = gets.match(/\d+/)[0].to_i
      until put_symbol(num, player.symbol)
        puts "Already taken, try again:".magenta
        num = gets.match(/\d+/)[0].to_i
      end
    end

    def a_winner?(player)
      winning_arr = [[1,2,3], [4,5,6], [7,8,9], [3,5,7],
                     [1,5,9], [1,4,7], [2,5,8], [3,6,9]]
      player_arr = @board.select { |pos, symb| symb == player.symbol }.keys
      return false if player_arr == []
      winning_arr.each do |arr|
        if arr & player_arr == arr
          # display_board
          # puts "#{player.name} won!".magenta.bold
          return true
        end
      end
      false
    end

    def draw?
      @board.any? { |pos, symb| symb == '-'} ? false : true
    end

    def ended?
      a_winner?(@player1) || a_winner?(@player2) || draw? ? true : false
    end
end
#
# game = Game.new
# game.start
