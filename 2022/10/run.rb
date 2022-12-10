# frozen_string_literal: true

inputs =
  File
    .read('input.txt')
    .split("\n")
    .map do |line|
      instruction, argument = line.split
      [instruction.to_sym, argument&.to_i]
    end

CLOCK_MARKS = [20, 60, 100, 140, 180, 220].freeze
TIME_TO_EXEC = {
  noop: 0,
  addx: 2
}

class CRT
  def initialize
    @screen = " " * 240
  end

  def tick(clock, pixel)
    return if clock > 240
    x_pos = (clock - 1) % 40

    if (clock - 1) < 270 && (pixel - x_pos).abs < 2
      @screen[clock - 1] = '#'
    end
  end

  def dump
    (0..6).each { |line| puts @screen.slice(line * 40, 40) }
  end
end

class CPU
  attr_accessor :register

  def initialize
    @register = 1
    @time_to_exec = 0
    @instruction, @argument = nil, nil
  end

  def push(input)
    raise "busy" if @instruction

    @instruction, @argument = input
    @time_to_exec = TIME_TO_EXEC[@instruction]
  end

  def available?
    @instruction.nil?
  end

  def noop
  end

  def addx
    @register += @argument
  end

  def tick
    @time_to_exec -= 1

    if @time_to_exec < 1
      self.send(@instruction)
      @instruction = nil
    end
  end
end

def compute_strengh(memory)
  memory.each_with_index.map { |value, index| value * CLOCK_MARKS[index] }.sum
end

clock = 0
memory = []
cpu = CPU.new
crt = CRT.new
while !(inputs.empty? && cpu.available?) do
  clock +=1
  memory.push(cpu.register) if CLOCK_MARKS.include?(clock)
  
  if cpu.available?
    cpu.push(inputs.shift)
  end

  crt.tick(clock, cpu.register)
  cpu.tick
end

# Answer 1
pp compute_strengh(memory)

# Answer 2
crt.dump