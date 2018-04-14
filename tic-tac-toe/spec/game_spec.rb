require 'game'

describe Game do

  let(:player_1) { Player.new }
  let(:player_2) { Player.new }
  let(:game_board) do
    { 1 => 'X', 2 => 'X', 3 => 'X',
      4 => '-', 5 => 'O', 6 => 'O',
      7 => 'O', 8 => '-', 9 => '-' }
  end
  let(:game) do
    Game.new(game_board,player_1,player_2)
  end

  describe "#a_winner?" do
    context "given a player whose symbol is 'X'" do
      context "and board with winning combination for 'X'" do
        it "returns true" do
          allow(game.player1).to receive(:symbol) { 'X' }
          expect(game.a_winner?(game.player1)).to eq(true)
        end
      end

      context "and an empty board" do
        it "returns false" do
          allow(game).to receive(:board) do
            { 1 => '-', 2 => '-', 3 => '-',
              4 => '-', 5 => '-', 6 => '-',
              7 => '-', 8 => '-', 9 => '-' }
          end
          expect(game.a_winner?(game.player1)).to eq(false)
        end
      end
    end
  end

  describe "#ended?" do
    context "when there is a draw" do
      it "returns true" do
        game.board = { 1 => 'X', 2 => 'O', 3 => 'X',
                       4 => 'X', 5 => 'X', 6 => 'O',
                       7 => 'O', 8 => 'X', 9 => 'O' }
        # allow(game).to receive(:board) do
        #   { 1 => 'X', 2 => 'O', 3 => 'X',
        #     4 => 'X', 5 => 'X', 6 => 'O',
        #     7 => 'O', 8 => 'X', 9 => 'O' }
        # end
        expect(game.ended?).to eq(true)
      end

      it "calls #draw?" do
        game.board = { 1 => 'X', 2 => 'O', 3 => 'X',
                       4 => 'X', 5 => 'X', 6 => 'O',
                       7 => 'O', 8 => 'X', 9 => 'O' }
        allow(game.player1).to receive(:symbol) { 'X' }
        allow(game.player2).to receive(:symbol) { 'O' }
        expect(game).to receive(:draw?)

        game.ended?
      end
    end

    context "after first turn" do
      it "returns false" do
        game.board = { 1 => '-', 2 => '-', 3 => '-',
                       4 => '-', 5 => 'X', 6 => '-',
                       7 => '-', 8 => '-', 9 => '-' }
        allow(game.player1).to receive(:symbol) { 'X' }
        allow(game.player2).to receive(:symbol) { 'O' }

        expect(game.ended?).to eq(false)
      end
    end
  end
end
