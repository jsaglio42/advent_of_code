# frozen_string_literal: true

require 'matrix'

FILE_NAME = 'sample.txt'

input =
  File
    .read(FILE_NAME)
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

def safe_method(a, b, method)
  [a, b || a].send(method)
end

def draw
  min_i = safe_method(boundary(ROCKS, :i, :min), boundary(SANDS, :i, :min), :min) - 1
  max_i = safe_method(boundary(ROCKS, :i, :max), boundary(SANDS, :i, :max), :max) + 1
  min_j = safe_method(boundary(ROCKS, :j, :min), boundary(SANDS, :j, :min), :min) - 1
  max_j = safe_method(boundary(ROCKS, :j, :max), boundary(SANDS, :j, :max), :max) + 1

  height = max_i - min_i + 1
  width = max_j - min_j + 1

  map = '.' * (height * width)
  ROCKS.each { |node| map[((node[0] - min_i) * width) + (node[1] - min_j)] = '#' }
  SANDS.each { |node| map[((node[0] - min_i) * width) + (node[1] - min_j)] = 'o' }

  height.times { |idx| puts map.slice(idx * width, width) }
  puts "\n"
end

def next_position(vector)
  [Vector[1, 0], Vector[1, -1], Vector[1, 1]].each { |offset| return vector + offset if empty?(vector + offset) }
  vector
end

def stopped?(vector)
  next_position(vector) == vector
end

class OutOfBoundary < StandardError
end

def fill(raise_if_oob: true)
  sources = [SOURCE]
  while !sources.empty?
    if !empty?(sources.last)
      sources.pop
      next
    end
    it = sources.last
    until (stopped?(it) || out_of_boundary?(it))
      it = next_position(it)
      sources << it
    end
    raise OutOfBoundary if raise_if_oob && out_of_boundary?(next_position(it))
    SANDS << it
  end
end

# Answer 1
begin
  fill(raise_if_oob: true)
rescue OutOfBoundary
  pp SANDS.count
end
draw

# Answer 2
fill(raise_if_oob: false)
pp SANDS.count
draw
