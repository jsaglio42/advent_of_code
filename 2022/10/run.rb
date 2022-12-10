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

class CRT
  def initialize
    @screen = " " * 240
  end

  def draw(clock, acc_value)
    x_pos = (clock - 1) % 40

    if (acc_value - x_pos).abs < 2
      @screen[clock - 1] = '#'
    end
  end

  def dump
    (0..6).each { |line| puts @screen.slice(line * 40, 40) }
  end
end

class CPU
  attr_accessor :clock, :acc_values, :crt

  def initialize(crt)
    @acc = 1
    @clock = 1
    @acc_values = []
    @crt = crt
  end

  def increment_clock
    @acc_values.push(@acc) if CLOCK_MARKS.include?(@clock)
    @crt.draw(@clock, @acc)
    @clock += 1
  end

  def noop
    increment_clock
  end

  def addx(value)
    increment_clock
    increment_clock
    @acc += value
  end
end

cpu = CPU.new(CRT.new)
inputs.each do |instruction, argument|
  case instruction
  when :noop
    cpu.noop
  when :addx
    cpu.addx(argument)
  end
end

# Answer 1
pp cpu.acc_values.each_with_index.map { |strengh, index| strengh * CLOCK_MARKS[index] }.sum

# Answer 2
cpu.crt.dump