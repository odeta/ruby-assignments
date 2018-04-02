require './player'

class Game
  attr_reader :board, :player1, :player2

  def initialize
    @board = Hash[(1..9).map { |e| [e, '-'] }]
    @player1 = Player.new
    @player2 = Player.new
  end

  def start
    display_rules
    set_up_players

    until ended?
      play_a_turn(@player1)
      return if ended?
      play_a_turn(@player2)
    end
  end

  private
    def display_board
      puts
      @board.map do |pos, symb|
        print pos % 3 == 0 ? "#{symb}\n" : symb.to_s + " "
      end.join(" ")
      puts
    end

    def display_rules
      puts "Hi, to play this game you should"
      puts "enter one integer, which must be"
      puts "between 1 and 9, like in this"
      puts "example: 1."
      puts "************************************"
    end

    def put_symbol(pos, symbol)
      return false unless @board[pos] == '-'
      @board[pos] = symbol
      true
    end

    def set_up_players
      puts "First player name:"
      @player1.name = gets.chomp
      puts "...and symbol (enter 1 for 'X', 2 for 'O'):"
      @player1.symbol =
        case gets.match(/\d+/)[0].to_i
        when 1 then 'X'
        when 2 then 'O'
        else ''
        end
      while @player1.symbol == ''
        puts "Try again (enter 1 for 'X', 2 for 'O'):"
        @player1.symbol =
          case gets.match(/\d+/)[0].to_i
          when 1 then 'X'
          when 2 then 'O'
          else ''
          end
      end
      puts "\n#{@player1.name} is #{@player1.symbol}s.\n"
      puts "Second player name:"
      @player2.name = gets.chomp
      @player2.symbol = @player1.symbol == 'X' ? 'O' : 'X'
      puts "\n#{@player2.name} is #{@player2.symbol}s.\n"
    end

    def play_a_turn(player)
      display_board
      puts "#{player.name}'s turn."
      puts "Enter a position:"
      num = gets.match(/\d+/)[0].to_i
      until put_symbol(num, player.symbol)
        puts "Already taken, try again:"
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
          display_board
          puts "#{player.name} won!"
          return true
        end
      end
      false
    end

    def ended?
      return true if a_winner?(@player1) || a_winner?(@player2)
      unless @board.any? { |pos, symb| symb == '-'}
        puts "Draw!"
        return true
      end
      false
    end
end

game = Game.new
game.start
