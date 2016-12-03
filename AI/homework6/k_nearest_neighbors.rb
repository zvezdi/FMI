require 'csv'

SEPAL_LENGTH = 0
SEPAL_WIDTH = 1
PETAL_LENGTH = 2
PETAL_WIDTH = 3
CLASS = 4

def data(path_to_csv_file = "iris_data/iris.data")
  dataset = CSV.read(path_to_csv_file)

  testing_set = []
  training_set = []

  testing_set_indexes = random_indexes(20, 150)
  dataset.each_with_index do |datapoint, index|
    if testing_set_indexes.include?(index)
      testing_set << datapoint
    else
      training_set << datapoint
    end
  end
  
  {training_set: training_set, testing_set: testing_set}
end

def random_indexes(how_many, highest)
  indexes = (1..how_many).map { rand(highest) }.uniq

  while indexes.size < how_many
    index = rand(highest)
    indexes << index unless indexes.include?(index)
  end

  indexes
end

def distance(datapoint1, datapoint2)
  # there is a corelation between petal_size, petal_length and class 
  # so I'll calculate the difference based only on petal_size and petal_length
  Math.sqrt((datapoint1[PETAL_LENGTH].to_f - datapoint2[PETAL_LENGTH].to_f)**2 +
            (datapoint1[PETAL_WIDTH].to_f - datapoint2[PETAL_WIDTH].to_f)**2)
end

def knn(datapoint, training_set, k)
  training_set.map do |training_datapoint|
    {iris_class: training_datapoint[CLASS], distance: distance(datapoint, training_datapoint)}
  end.sort_by { |datapoint| datapoint[:distance]}.take(k)
end

def determin_class(neighbors)
  counts = Hash.new(0)
  neighbors.each { |n| counts[n[:iris_class]] += 1 }

  counts.max_by { |k,v| v }[0]
end

def find_classes(training_set, testing_set)
  res = []
  testing_set.each do |datapoint|
    neighbors = knn(datapoint, training_set, 3)
    calculated_class = determin_class(neighbors)
    res << {datapoint: datapoint, calculated_class: calculated_class}
  end

  res
end

def assesment(training_set, testing_set)
  classes = find_classes(training_set, testing_set)
  assesment_vector = classes.map { |record| record[:datapoint][CLASS] == record[:calculated_class] }
  accuracy = assesment_vector.count(true).to_f / testing_set.size.to_f * 100 
  classes.each do |record|
    puts " #{record[:datapoint]} --> #{record[:calculated_class]}"
  end
  puts "Accuracy: #{accuracy}%"
end

datasets = data("iris_data/iris.data")
training_set = datasets[:training_set]
testing_set = datasets[:testing_set]

assesment(training_set, testing_set)