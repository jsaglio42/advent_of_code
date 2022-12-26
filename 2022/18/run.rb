# frozen_string_literal: true

require 'set'

FILE = 'input.txt'

DICES = Set.new

File
  .read(FILE)
  .split("\n")
  .map do |line|
    line =~ /(-?\d+),(-?\d+),(-?\d+)/

    DICES << [$1.to_i, $2.to_i, $3.to_i]
  end

def open_faces(dice)
  x, y, z = dice
  [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]].reduce(6) do |acc, offset|
    i, j, k = offset
    DICES.include?([x + i, y + j, z + k]) ? acc - 1 : acc
  end
end

# Answer 1
pp DICES.reduce(0) { |acc, dice| acc + open_faces(dice) }
