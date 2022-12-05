# frozen-string-literal: true

file = File.read('input.txt').split("\n\n")

cargo_input, instructions_input = file.map { |line| line.split("\n") }

def parse_cargo(input)
  size = (input.first.size + 1) / 4
  output = Array.new(size) { [] }

  input[...-1].each do |line|
    (0...size).each do |index|
      crate = line[index * 4 + 1]
      next if crate.strip.empty?

      output[index].push(crate)
    end
  end
  output.map(&:reverse)
end

def parse_instructions(input)
  input.map do |line|
    matching_data = line.match(/move (?<count>\d+) from (?<source>\d+) to (?<target>\d+)/)
    [matching_data[:count], matching_data[:source], matching_data[:target]].map(&:to_i)
  end
end

cargo = parse_cargo(cargo_input)
instructions = parse_instructions(instructions_input)

def apply_instructions_9000!(cargo, instructions)
  instructions.each { |count, source, target| count.times { cargo[target - 1].push(cargo[source - 1].pop) } }
end

def apply_instructions_9001!(cargo, instructions)
  instructions.each do |count, source, target|
    tmp = []
    count.times { tmp.push(cargo[source - 1].pop) }
    cargo[target - 1].push(*tmp.reverse)
  end
end

# Answer 1
# apply_instructions_9000!(cargo, instructions)
# pp cargo.map(&:last).join

# Answer 2
apply_instructions_9001!(cargo, instructions)
pp cargo.map(&:last).join
