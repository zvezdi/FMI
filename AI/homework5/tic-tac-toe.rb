module Constants
  BOARD_SIZE = 3
  FREE = '_'
  MIN_PLAYER = 'O'
  MAX_PLAYER = 'X'
  WINNING_COMBOS = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]]
end

class Board
  include Constants
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def possible_moves
    (0...BOARD_SIZE**2).select { |index| board[index] == FREE}
  end

  def winner
    WINNING_COMBOS.each do |indexes|
      return MIN_PLAYER if indexes.all? { |index| board[index] == MIN_PLAYER }
      return MAX_PLAYER if indexes.all? { |index| board[index] == MAX_PLAYER }
    end

    ''
  end

  def full?
    board.none? { |symbol| symbol == FREE }
  end

  def move(index, player)
    board[index] = player
  end
  
  def undo_move(index)
    board[index] = FREE
  end

  def print
    row = []
    board.each_with_index do |symbol, index|
      row << symbol
      if (index + 1) % 3 == 0
         puts row.join ' '
         row = []
      end    
    end
  end
end

class TicTacToe
  include Constants
  attr_accessor :board

  def initialize
    empty_board = ('_' * 9).chars
    @board = Board.new(empty_board)
  end

  def play
    print
    until game_end?
      winner = human_plays(MIN_PLAYER)
      winner = computer_plays(MAX_PLAYER)
    end

    puts winner || "It's a tie!"
  end

  private
  def print
    puts "======================"
    board.print
    puts "======================"
  end

  def human_plays(player)
      index = get_human_input
      board.move(index, player)
      print
      check_for_winner(player)
  end

  def computer_plays(player)
    indexes = []
    best_value = Float::INFINITY * -1
    board.possible_moves.each do |index|
        board.move(index, player)
        value = minimax_alpha_beta_pruning(oponent(player), -2, 2)
        board.undo_move(index)
        if value > best_value
          indexes = [index]
          best_value = value
        elsif value == best_value
          indexes << index
        end
    end  
    index = indexes[rand(indexes.size)]
    board.move(index, player)
    print
    check_for_winner(player)
  end

  def game_end?
    board.possible_moves.size == 1 or board.winner != ''
  end

  def check_for_winner(player)
    "#{player} wins!" if board.winner == player
  end

  def oponent(player)
    player == MAX_PLAYER ? MIN_PLAYER : MAX_PLAYER
  end

  def minimax_alpha_beta_pruning(player, alpha, beta)
    case board.winner
    when MIN_PLAYER
      return -1
    when MAX_PLAYER
      return 1
    else
      return 0 if board.full?
    end

    if player == MAX_PLAYER
      best_value = Float::INFINITY * -1
      board.possible_moves.each do |index|
        board.move(index, player)
        value = minimax_alpha_beta_pruning(oponent(player), alpha, beta)
        board.undo_move(index)
        best_value = [best_value, value].max
        alpha = [alpha, best_value].max
        break if beta <= alpha
      end
      return best_value
    else # MIN_PLAYER's turn
      best_value = Float::INFINITY
      board.possible_moves.each do |index|
        board.move(index, player)
        value = minimax_alpha_beta_pruning(oponent(player), alpha, beta)
        board.undo_move(index)
        best_value = [best_value, value].min
        beta = [beta, best_value].min
        break if beta <= alpha
      end
      return best_value
    end
  end

  def get_human_input
    puts
    puts "Enter x,y coordinates: "
    coordinates = gets
    puts
    coordinates = coordinates.split(',').map { |coord| coord.strip.to_i }

    #the index of selected square 
    (coordinates[1] - 1) * BOARD_SIZE + (coordinates[0] - 1)
  end
end

t = TicTacToe.new
t.play  