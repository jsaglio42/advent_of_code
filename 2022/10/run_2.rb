# frozen_string_literal: true

inputs =
  File
    .read('input.txt')
    .split("\n")
    .map do |line|
      instruction, argument = line.split
      [instruction.to_sym, argument&.to_i]
    end

execution_list = [1]
inputs.reduce(1) do |acc, input|
  instruction, value = input
  case instruction
  when :noop
    execution_list.push([acc])
    acc
  when :addx
    execution_list.push([acc, acc + value])
    acc + value
  end
end

# Answer 1
def compute_strengh(execution_list)
  (0..5).map { |index| execution_list[19 + (index * 40)] * (20 + (index * 40)) }.sum
end
pp compute_strengh(execution_list.flatten)

# Answer 2
screen = ' ' * 240
def print_screen(screen)
  (0..6).each { |line| puts screen.slice(line * 40, 40) }
end

def plot(screen, clock, acc)
  x_pos = (clock) % 40

  screen[clock] = '#' if (acc - x_pos).abs < 2
end

execution_list.flatten.each_with_index { |acc, index| plot(screen, index, acc) }
print_screen(screen)
