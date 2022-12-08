# frozen-string-literal: true

file = File.read('input.txt').split("\n")

def priority(char)
  'A'.ord <= char.ord && char.ord <= 'Z'.ord ? 27 + char.ord - 'A'.ord : 1 + char.ord - 'a'.ord
end

def compartments(rucksack)
  midpoint = rucksack.size / 2
  [rucksack[...midpoint], rucksack[midpoint...]]
end

def common_item(rucksack)
  first, second = compartments(rucksack)
  (first.chars & second.chars).first
end

# Answer 1
pp(file.map { |line| priority(common_item(line)) }.sum)

# Answer 2
pp(file.each_slice(3).map { |first, second, third| priority((first.chars & second.chars & third.chars).first) }.sum)
