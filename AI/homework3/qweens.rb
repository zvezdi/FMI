# state is represented by array
# each element represents a column
# and it's value is the number of the row the qween is placed in

def place_qweens(n)
  if n.even?
    # should implement some gready algorithm to produce better initial state
    (0..n).map { rand(n-1) }
  else
    # if the qweens are uneven number they could be always placed like that
    counter = -2
    (0...n).map do
      (counter += 2) % n
    end
  end
end

def conflicts(state, test_column)
  #takes state and index of column
  #returns how many qweens are in conflict with te one in taht column
  hits = 0

  (0...state.length).each do |curr_column|
    next if curr_column == test_column

    offset = curr_column - test_column
    test_row = state[test_column]
    curr_row = state[test_column + offset]

    hits += 1 if test_row == curr_row
    hits += 1 if test_row + offset == curr_row
    hits += 1 if test_row - offset == curr_row
  end

  hits
end

def conflicts_array(state)
  # return an array each element holds the count of conflicts for the cooresponding column
  (0...state.length).map { |column| conflicts(state, column) }
end

def final?(state, conflicts_array)
  conflicts_array.reduce(:+) == 0
end

def select_qween(state, conflicts_array)
  #should be returning a random index to overcome local exteremiums
  in_conflict = []
  conflicts_array.each_with_index { |count, index|  in_conflict << index if count != 0 }
  in_conflict[rand(in_conflict.size)]
end

def best_row(state, column_idx)
  #returns the index of row with min conflicts in the passed column
  conf = (0...state.length).map do |row|
    test_state = state.dup
    test_state[column_idx] = row
    conflicts(test_state, column_idx)
  end
  conf.index(conf.min)
end

def move(state, column_idx)
  # select row with minimum conflicts
  state[column_idx] = best_row(state, column_idx)
end

def min_conflicts(state)
  # the number of iterations should be determined dinamically
  1000000.times do |iteration|
    conflicts_array = conflicts_array(state)

    return state if final?(state, conflicts_array)
    qween = select_qween(state, conflicts_array)
    move(state, qween)
  end

  puts "Try more iterations or better initial state"
end

def pretty_print(state)
  (0...state.length).each do |row|
    row_data = []
    (0...state.length).each do |column|
      if state[column] == row
        row_data << '*'
      else
        row_data << '_'
      end 
    end
    puts row_data.join("")
  end
end

n = gets.to_i
state = place_qweens(n)
solution = min_conflicts(state)
pretty_print(solution) if solution