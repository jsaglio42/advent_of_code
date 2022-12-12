# frozen_string_literal: true

class Node < Struct.new(:coord, :parent)
  def ==(other)
    coord == other.coord
  end

  def invalid_position
    i, j = coord
    i < 0 || j < 0 || i > MAX_I || j > MAX_J
  end

  def height
    i, j = coord
    MAP[i][j]
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

def valid_neighbours(source_node, forbidden_nodes, valid_move_proc)
  source_i, source_j = source_node.coord
  possible_coord = [
    Node.new([source_i - 1, source_j], source_node),
    Node.new([source_i + 1, source_j], source_node),
    Node.new([source_i, source_j - 1], source_node),
    Node.new([source_i, source_j + 1], source_node),
  ]
  possible_coord.reject do |dest_node|
    next true if dest_node.invalid_position
    next true if !valid_move_proc.call(source_node, dest_node)
    next true if forbidden_nodes.map(&:coord).include?(dest_node.coord)

    false
  end
end

def bfs(starting_node, breaking_proc, valid_move_proc)
  visited_nodes = []
  nodes_to_visit = [starting_node]
  while nodes_to_visit.size > 0
    current = nodes_to_visit.shift()
    visited_nodes.push(current)

    break if breaking_proc.call(current)

    available_nodes = valid_neighbours(current, visited_nodes + nodes_to_visit, valid_move_proc)
    available_nodes.each { |node| nodes_to_visit.push(node) }
  end
  raise 'no solution' if !breaking_proc.call(visited_nodes.last)
  calculate_path(visited_nodes.last)
end

def calculate_path(last_node)
  [].tap do |path|
    it = last_node
    while it
      path.unshift(it.coord)
      it = it.parent
    end
  end
end

def draw(path)
  output = Array.new(MAX_I + 1) { Array.new(MAX_J + 1) { '.' } }
  path.each { |i, j| output[i][j] = '#' }
  output.each { |line| puts line.join }
end

# Answer 1
breaking_proc = Proc.new { |node| node == FINISH }
valid_move_proc = Proc.new { |source, dest| dest.height - source.height <= 1 }
path = bfs(START, breaking_proc, valid_move_proc)

pp path.size - 1
draw(path)

# Answer 2
breaking_proc = Proc.new { |node| node.height == 0 }
valid_move_proc = Proc.new { |source, dest| source.height - dest.height <= 1 }
path = bfs(FINISH, breaking_proc, valid_move_proc)

pp path.size - 1
draw(path)
