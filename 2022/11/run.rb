# frozen_string_literal: true

input = File.read('input.txt').split("\n\n").map { |monkey| monkey.split("\n") }

class Monkey
  attr_accessor :processed_count
  attr_reader :divider

  def initialize(compute_string, divider, success_monkey, failure_monkey)
    @compute_string = compute_string
    @divider = divider
    @success_monkey = success_monkey
    @failure_monkey = failure_monkey
    @processed_count = 0
  end

  def reset_process_count
    @processed_count = 0
  end


  def new_worry(worry)
    eval("lambda { |old| #{@compute_string} }").call(worry)
  end

  def new_monkey(worry)
    eval("lambda { |worry| worry % #{@divider} == 0 ? #{@success_monkey} : #{@failure_monkey} }").call(worry)
  end

  def process_part_1(worry, items)
    new_worry = new_worry(worry) / 3
    new_monkey = new_monkey(new_worry)

    items[new_monkey].push(new_worry)
    @processed_count += 1
  end

  def process_part_2(worry, items, stress_factor)
    new_worry = new_worry(worry) % stress_factor
    new_monkey = new_monkey(new_worry)
    items[new_monkey].push(new_worry)
    @processed_count += 1
  end
end

input_items_by_monkey = {}
input_monkeys = {}

input.each_with_index do |block, index|
  input_items_by_monkey[index] = block[1].split('Starting items: ')[1].split(',').map(&:strip).map(&:to_i)
  compute_string = block[2].split('Operation: new = ')[1]
  divider = block[3].split('Test: divisible by ')[1].to_i
  success_monkey = block[4].split('If true: throw to monkey ')[1].to_i
  failure_monkey = block[5].split('If false: throw to monkey ')[1].to_i
  input_monkeys[index] = Monkey.new(compute_string, divider, success_monkey, failure_monkey)
end

# Answer 1
items_by_monkey = input_items_by_monkey.to_h { |k, v| [k.clone, v.clone] }
monkeys = input_monkeys.to_h { |k, v| [k.clone, v.clone] }

20.times do
  monkeys.each do |index, monkey|
    while !items_by_monkey[index].empty?
      item = items_by_monkey[index].shift
      monkey.process_part_1(item, items_by_monkey)
    end
  end
end
top = monkeys.values.map(&:processed_count).sort.reverse[...2]
pp top[0] * top[1]

# Answer 2
items_by_monkey = input_items_by_monkey.to_h { |k, v| [k.clone, v.clone] }
monkeys = input_monkeys.to_h { |k, v| [k.clone, v.clone] }

monkeys.values.each(&:reset_process_count)
common_divider = monkeys.values.map(&:divider).reduce(1) { |acc, value| acc * value }
10_000.times do
  monkeys.each do |index, monkey|
    while !items_by_monkey[index].empty?
      item = items_by_monkey[index].shift
      monkey.process_part_2(item, items_by_monkey, common_divider)
    end
  end
end
top = monkeys.values.map(&:processed_count).sort.reverse[...2]
pp top[0] * top[1]
