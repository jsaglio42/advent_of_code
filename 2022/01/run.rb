# frozen-string-literal: true

input = File.read('input.txt').split("\n\n").map { |line| line.split("\n") }.map { |line| line.map(&:to_i) }

# Answer 1
pp input.map(&:sum).max
# Answer 2
pp input.map(&:sum).sort.reverse[0..2].sum
