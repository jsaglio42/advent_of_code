# frozen_string_literal: true

input =
  File
    .read("input.txt")
    .split("\n\n")
    .map { |block| block.split("\n").map { |line| eval(line) } }

def compare(left, right)
  case [left.class, right.class]
  when [Array, Array]
    if left.empty? || right.empty?
      left.size - right.size
    else
      first_item_compare = compare(left.first, right.first)

      if first_item_compare.zero?
        compare(left[1..], right[1..])
      else
        first_item_compare
      end
    end
  when [Integer, Integer]
    left - right
  when [Array, Integer]
    compare(left, [right])
  when [Integer, Array]
    compare([left], right)
  end
end

# Answer 1
pp(
  input
    .each_with_index
    .to_a
    .reduce(0) do |acc, block_with_index|
      block, index = block_with_index
      acc = acc + index + 1 if compare(block[0], block[1]) <= 0
      acc
    end
)

# Answer 2
sorted =
  (input.flatten(1) + [[[2]]] + [[[6]]]).sort do |left, right|
    compare(left, right)
  end

pp (sorted.find_index { |node| compare(node, [[2]]).zero? } + 1) *
     (sorted.find_index { |node| compare(node, [[6]]).zero? } + 1)
