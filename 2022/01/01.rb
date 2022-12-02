calories_by_elf = []

calories = []
File.open('input.txt').each do |line|
  if line.strip.empty?
    calories_by_elf.push(calories)
    calories = []
  else
    calories.push(line.to_i)
  end
end

total_calories_by_elf = calories_by_elf.map(&:sum)

puts "calories_by_elf:#{calories_by_elf}"
puts "total_calories_by_elf:#{total_calories_by_elf}"
# Answer 1
puts total_calories_by_elf.max
puts '---'
# Answer 2
puts total_calories_by_elf.sort.reverse[0..2].sum
