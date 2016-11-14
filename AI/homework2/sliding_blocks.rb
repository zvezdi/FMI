require 'matrix'
require 'set'
require_relative 'priority_queue.rb'

class Array
  def dclone
    cloned = []
    each do |row|
      cloned << Array.new(row)
    end

    cloned
  end
end

class State
  attr_reader :cost, :directions, :board, :heuristic_price

  def initialize(board = [], cost = 0, directions = "")
    @board = board
    @cost = cost
    @heuristic_price = heuristic(board)
    @directions = directions
  end

  def eql?(state)
    board == state.board
  end

  def hash
    board.hash
  end

  def children
    free_idx = free_index
    x_free, y_free = free_idx[0], free_idx[1]

    children = []
    ['u', 'd', 'l', 'r'].each do |direction|
      case direction
      when "u"
        x, y = x_free - 1, y_free
      when "d"
        x, y = x_free + 1, y_free
      when "r"
        x, y = x_free, y_free + 1
      when "l"
        x, y = x_free, y_free - 1
      else raise "Unknown direction #{direction}"
      end
      children << child(free_idx, [x, y], direction) if inside([x, y])
    end

    children
  end

  def to_s
    anti_transform(@board.dclone).each do |row|
      p row.join(" ")
    end
    puts @cost
    puts @directions
  end

  def heuristic(board)
    n = board.size
    overall_manhatan_distance = 0
    board.each_with_index do |row, i|
      row.each_with_index do |el, j|
        distance = (i - el / n).abs + (j - el % n).abs
        overall_manhatan_distance += distance
      end
    end

    overall_manhatan_distance
  end

  def >=(state)
    cost + heuristic_price <= state.cost + state.heuristic_price
  end

  def >(state)
    cost + heuristic_price < state.cost + state.heuristic_price
  end
  
  private

  def free_index
    n = @board.size
    Matrix[*@board].index(n * n - 1)
  end
  
  def board_size
    @board.size
  end

  def inside(index)
    #index looks like [row, column]
    0 <= index[0] and index[0] < board_size and 0 <= index[1] and index[1] < board_size 
  end

  def child(free_idx, idx, direction)
    x_free, y_free = free_idx[0], free_idx[1]
    x, y = idx[0], idx[1]

    State.new(@board.dclone, @cost + 1, @directions + direction).swap([x, y], [x_free, y_free])
  end

  protected

  def swap(idx1, idx2)
    @board[idx1[0]][idx1[1]], @board[idx2[0]][idx2[1]] =
    @board[idx2[0]][idx2[1]], @board[idx1[0]][idx1[1]]

    self
  end

end

def transform(board)
  n = board.size
  board.map do |row|
    row.map do |el|
      if el == 0
        n * n - 1
      else
        el - 1
      end
    end
  end
end

def anti_transform(board)
  n = board_size
  board.map do |row|
    row.map do |el|
      if el ==  n * n - 1
       0
      else
        el + 1
      end
    end
  end
end

def a_star(state)
  arr = transform(state)
  s = State.new(arr)
  queue = PriorityQueue.new
  set = Set.new [s]
  # # p s.heuristic_price
  queue << s
  until queue.empty?
    curr = queue.pop
    set << curr
    return curr if curr.heuristic_price == 0
    curr.children.each do |child|
      queue << child unless set.include?(child)
    end
  end

  State.new
end

def get_initial_state
  initial_state = []
  num = gets.to_i
  num = Math.sqrt(num + 1).to_i
  num.times do
    line = gets.split(" ").map { |el| el.to_i }
    raise "You must enter #{num} blocks per row!" unless line.size == num
    initial_state << line
  end
  
  puts

  initial_state
end

start = get_initial_state
result = a_star(start)

if result.directions == ""
  puts "No solution"
else
  puts result.directions.chars.size
  result.directions.chars.each do |letter|
    case letter
    when 'r'
      puts "left"
    when 'l'
      puts "right"
    when 'u'
      puts "down"
    when 'd'
      puts "up"
    end
  end
end