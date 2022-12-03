# frozen-string-literal: true

file = File.read('input.txt').split("\n")

def priority(char)
  'A'.ord <= char.ord && char.ord <= 'Z'.ord ? 27 + char.ord - 'A'.ord : 1 + char.ord - 'a'.ord
end

# puts priority('a')
# puts priority('z')
# puts priority('A')
# puts priority('Z')

def compartments(rucksack)
  midpoint = rucksack.size / 2
  [rucksack[...midpoint], rucksack[midpoint...]]
end

# puts compartments('ABCD1234')
# puts compartments('ABCD_1234')

def common_item(rucksack)
  first, second = compartments(rucksack)
  (first.split('') & second.split('')).first
end

# Answer 1
puts(file.map { |line| priority(common_item(line)) }.sum)

# Answer 2
puts(
  file
    .each_slice(3)
    .map { |first, second, third| priority((first.split('') & second.split('') & third.split('')).first) }
    .sum,
)
