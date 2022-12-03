# frozen-string-literal: true

input = File.read('input.txt').split("\n\n").map { |line| line.split("\n") }.map { |line| line.map(&:to_i) }

# Answer 1
puts input.map(&:sum).max
# Answer 2
puts input.map(&:sum).sort.reverse[0..2].sum
