# frozen_string_literal: true

file = File.read('input.txt').split("\n")

def start_of_input?(chars, index, size)
  chars.slice(index, size).uniq.size == size
end

def find_total_processed(line, size)
  line.chars.find_index.with_index { |_, index| start_of_input?(line.chars, index, size) } + size
end

# Answer 1
pp(file.map { |line| find_total_processed(line, 4) })

# Answer 2
pp(file.map { |line| find_total_processed(line, 14) })
