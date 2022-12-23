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

SOURCE = [0, 500]

ROCKS =
  input
    .each_with_object([]) do |edges, acc|
      (0...edges.size - 1).each do |edge_index|
        start = edges[edge_index]
        stop = edges[edge_index + 1]
        diff = stop - start
        (0...diff.magnitude).each { |length| acc << (start + (length * diff.normalize)).map(&:to_i) }
      end
      acc << edges.last
    end
    .map(&:to_a)

def rock?(tiles, position)
  tiles[position] == '#' || position[0] == rock_bottom + 2
end

def sand?(tiles, position)
  tiles[position] == 'o'
end

def empty?(tiles, position)
  !rock?(tiles, position) && !sand?(tiles, position)
end

def out_of_boundary?(position)
  position[0] > rock_bottom
end

def rock_bottom
  @rock_bottom ||= ROCKS.map(&:first).max
end

def new_tiles
  ROCKS.to_h { |rock| [rock, '#'] }
end

def draw(tiles)
  min_i, min_j = [0, 500 - rock_bottom - 2]
  max_i, max_j = [rock_bottom + 2, 500 + rock_bottom + 2]

  (min_i..max_i).each do |i|
    if i == rock_bottom + 2
      line = '#' * (max_j - min_j + 1)
      puts line
    else
      line = '.' * (max_j - min_j + 1)
      tiles.select { |position| i == position[0] }.each { |position, char| line[position[1] - min_j] = char }
      puts line
    end
  end
end

def next_position(tiles, position)
  i, j = position
  [[1, 0], [1, -1], [1, 1]].each do |offset_i, offset_j|
    return i + offset_i, j + offset_j if empty?(tiles, [i + offset_i, j + offset_j])
  end
  position
end

def stopped?(tiles, position)
  next_position(tiles, position) == position
end

class OutOfBoundary < StandardError
end

def fill(tiles, raise_if_oob: true)
  # counter = 0
  sources = [SOURCE]
  while !sources.empty?
    next sources.pop if !empty?(tiles, sources.last)
    it = sources.last
    until (stopped?(tiles, it))
      it = next_position(tiles, it)
      raise OutOfBoundary if raise_if_oob && out_of_boundary?(it)
      sources.push(it)
    end
    tiles[it] = 'o'
    # draw(tiles) if (counter += 1) % 1000 == 0
  end
end

tiles = new_tiles
begin
  fill(tiles, raise_if_oob: true)
rescue OutOfBoundary
  nil
end
draw(tiles)
pp(tiles.values.count { |char| char == 'o' })

# Answer 2
tiles = new_tiles
fill(tiles, raise_if_oob: false)
draw(tiles)
pp(tiles.values.count { |char| char == 'o' })
