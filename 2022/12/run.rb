# frozen_string_literal: true

class Node < Struct.new(:coord, :parent)
  def ==(other)
    coord == other.coord
  end
end

def char_to_height(char)
  char.ord - 'a'.ord
end

MAP = File.read('input.txt').split("\n").map { |line| line.chars.map { |char| char_to_height(char) } }
MAX_I = MAP.size - 1
MAX_J = MAP.first.size - 1

start_i = MAP.find_index { |line| line.include?(char_to_height('S')) }
start_j = MAP[start_i].find_index { |char| char == char_to_height('S') }
MAP[start_i][start_j] = 0
START = Node.new([start_i, start_j], nil)

finish_i = MAP.find_index { |line| line.include?(char_to_height('E')) }
finish_j = MAP[finish_i].find_index { |char| char == char_to_height('E') }
MAP[finish_i][finish_j] = 25
FINISH = Node.new([finish_i, finish_j], nil)

visited_nodes = []
nodes_to_visit = [START]

def neighbours(current_node, useless_nodes)
  current_i, current_j = current_node.coord
  possible_coord = [
    [current_i - 1, current_j],
    [current_i + 1, current_j],
    [current_i, current_j - 1],
    [current_i, current_j + 1],
  ]
  possible_coord.reject do |i, j|
    next true if i < 0 || j < 0
    next true if i > MAX_I || j > MAX_J
    next true if MAP[i][j] - MAP[current_i][current_j] > 1
    next true if useless_nodes.map(&:coord).include?([i, j])

    false
  end
end

while nodes_to_visit.size > 0
  current = nodes_to_visit.shift()
  visited_nodes.push(current)
  break if current == FINISH

  available_nodes = neighbours(current, visited_nodes + nodes_to_visit)
  available_nodes.each { |i, j| nodes_to_visit.push(Node.new([i, j], current)) }
end
raise 'no solution' if visited_nodes.last != FINISH

# Answer 1
def path(last_node)
  [].tap do |path|
    it = last_node
    while it
      path.unshift(it)
      it = it.parent
    end
  end
end

def draw(path)
  output = Array.new(MAX_I + 1) { Array.new(MAX_J + 1) { '.' } }
  path.each do |node|
    i, j = node.coord
    output[i][j] = '#'
  end
  output.each { |line| puts line.join }
end

pp path(visited_nodes.last).size - 1
draw(path(visited_nodes.last))
