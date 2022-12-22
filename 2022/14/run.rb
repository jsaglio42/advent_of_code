# frozen_string_literal: true

require 'matrix'

input =
  File
    .read('sample.txt')
    .split("\n")
    .map do |line|
      line
        .split('->')
        .map(&:strip)
        .map do |coord|
          j, i = coord.split(',').map(&:to_i)
          Vector[i, j]
        end
    end

SOURCE = Vector[0, 500]

ROCKS =
  input.each_with_object([]) do |edges, acc|
    (0...edges.size - 1).each do |edge_index|
      start = edges[edge_index]
      stop = edges[edge_index + 1]
      diff = stop - start
      (0...diff.magnitude).each { |length| acc << (start + (length * diff.normalize)).map(&:to_i) }
    end
    acc << edges.last
  end

SANDS = []

def boundary(positions, direction, method)
  case direction
  when :i
    positions.map(&:to_a).map(&:first).send(method)
  when :j
    positions.map(&:to_a).map(&:last).send(method)
  end
end

def source?(vector)
  Vector[0, 500] == vector
end

def rock?(vector)
  ROCKS.include?(vector) || vector[0] == boundary(ROCKS, :i, :max) + 2
end

def sand?(vector)
  SANDS.include?(vector)
end

def empty?(vector)
  !rock?(vector) && !sand?(vector)
end

def out_of_boundary?(vector)
  vector[0] > boundary(ROCKS, :i, :max)
end

def draw
  min_i = [boundary(ROCKS, :i, :min), boundary(SANDS, :i, :min)].min - 1
  max_i = [boundary(ROCKS, :i, :max), boundary(SANDS, :i, :max)].max + 2
  min_j = [boundary(ROCKS, :j, :min), boundary(SANDS, :j, :min)].min - 1
  max_j = [boundary(ROCKS, :j, :max), boundary(SANDS, :j, :max)].max + 1
  (min_i..max_i).each do |i|
    (min_j..max_j).each do |j|
      vector = Vector[i, j]
      if rock?(vector)
        print('#')
      elsif sand?(vector)
        print('o')
      elsif source?(vector)
        print('+')
      else
        print('.')
      end
    end
    print("\n")
  end
  print("\n")
end

def next_position(vector)
  [Vector[1, 0], Vector[1, -1], Vector[1, 1]].each { |offset| return vector + offset if empty?(vector + offset) }
  vector
end

def stopped?(vector)
  next_position(vector) == vector
end

def fill(break_if_out_of_boundary: true)
  while true
    it = SOURCE
    it = next_position(it) until (stopped?(it) || out_of_boundary?(it))
    break if break_if_out_of_boundary && out_of_boundary?(next_position(it))
    SANDS << it
    break if it == SOURCE
  end
end

# Answer 1
fill(break_if_out_of_boundary: true)
pp SANDS.count
draw

# Answer 1
fill(break_if_out_of_boundary: false)
pp SANDS.count
draw
