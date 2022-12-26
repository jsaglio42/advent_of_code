# frozen_string_literal: true

require 'set'

FILE = 'input.txt'

LAVA = Set.new

File
  .read(FILE)
  .split("\n")
  .map do |line|
    line =~ /(-?\d+),(-?\d+),(-?\d+)/

    LAVA << [$1.to_i, $2.to_i, $3.to_i]
  end

def neighbours(dice)
  x, y, z = dice
  [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]].map do |direction|
    i, j, k = direction
    [x + i, y + j, z + k]
  end
end

def open_faces(dice)
  neighbours(dice).reduce(6) { |acc, neighbour| LAVA.include?(neighbour) ? acc - 1 : acc }
end

# Answer 1
pp LAVA.reduce(0) { |acc, dice| acc + open_faces(dice) }

# Answer 2
CONTAINER = Set.new
MINMAX_X = LAVA.map { |dice| dice[0] }.minmax
MINMAX_Y = LAVA.map { |dice| dice[1] }.minmax
MINMAX_Z = LAVA.map { |dice| dice[2] }.minmax

(MINMAX_X[0] - 1..MINMAX_X[1] + 1).each do |x|
  (MINMAX_Y[0] - 1..MINMAX_Y[1] + 1).each { |y| (MINMAX_Z[0] - 1..MINMAX_Z[1] + 1).each { |z| CONTAINER << [x, y, z] } }
end

def invalid_node(node, visited_nodes, nodes_to_visit)
  return true if node[0] < MINMAX_X[0] - 1 || node[0] > MINMAX_X[1] + 1
  return true if node[1] < MINMAX_Y[0] - 1 || node[1] > MINMAX_Y[1] + 1
  return true if node[2] < MINMAX_Z[0] - 1 || node[2] > MINMAX_Z[1] + 1
  LAVA.include?(node) || visited_nodes.include?(node) || nodes_to_visit.include?(node)
end

def trapped_bubbles
  starting_node = CONTAINER.find { |dice| dice[0] == MINMAX_X[0] - 1 }
  visited_nodes = []
  nodes_to_visit = [starting_node]
  while nodes_to_visit.size > 0
    visited_nodes.push(nodes_to_visit.shift)
    current = visited_nodes.last
    neighbours = neighbours(current).reject { |node| invalid_node(node, visited_nodes, nodes_to_visit) }
    nodes_to_visit.push(*neighbours)
  end
  CONTAINER - LAVA - Set.new(visited_nodes)
end

# Answer 2
LAVA.merge(trapped_bubbles)
pp LAVA.reduce(0) { |acc, dice| acc + open_faces(dice) }
