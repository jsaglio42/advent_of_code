# frozen_string_literal: true

require 'matrix'

input =
  File
    .read('input.txt')
    .split("\n")
    .map do |line|
      dir, dist = line.split
      [dir.to_sym, dist.to_i]
    end

DIRECTION = { R: Vector[1, 0], L: Vector[-1, 0], U: Vector[0, 1], D: Vector[0, -1] }.freeze

def move_to_apply(delta)
  # No move
  return Vector[0, 0] if delta[0].abs < 2 && delta[1].abs < 2

  # Big diagonal moves
  return Vector[delta[0] / 2, delta[1] / 2] if delta[0].abs == 2 && delta[1].abs == 2

  delta[0].abs == 2 ? Vector[delta[0] / 2, delta[1]] : Vector[delta[0], delta[1] / 2]
end

def solve!(rope_positions, input)
  input.each do |dir, dist|
    dist.times do
      current_rope = rope_positions.last
      new_rope = [current_rope.first + DIRECTION[dir]]

      current_rope[1..].each do |tail|
        new_head = new_rope.last
        delta = new_head - tail
        new_tail = tail + move_to_apply(delta)

        new_rope.push(new_tail)
      end

      rope_positions.push(new_rope)
    end
  end
end

# Answer 1
rope_positions = [Array.new(2) { Vector[0, 0] }]
solve!(rope_positions, input)
pp rope_positions.map(&:last).uniq.count

# Answer 1
rope_positions = [Array.new(10) { Vector[0, 0] }]
solve!(rope_positions, input)
pp rope_positions.map(&:last).uniq.count
