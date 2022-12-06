# frozen_string_literal: true

file = File.read('input.txt').split("\n")

NUMBER_TO_PROCESS = 4

def start_of_input?(chars, index)
  chars.slice(index, NUMBER_TO_PROCESS).uniq.size == NUMBER_TO_PROCESS
end

# Answer 1
pp(
  file.map do |line|
    chars = line.chars
    chars.find_index.with_index { |_, index| start_of_input?(chars, index) } + NUMBER_TO_PROCESS
  end,
)

# Answer 2
NUMBER_TO_PROCESS = 14
pp(
  file.map do |line|
    chars = line.chars
    chars.find_index.with_index { |_, index| start_of_input?(chars, index) } + NUMBER_TO_PROCESS
  end,
)
