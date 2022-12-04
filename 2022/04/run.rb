# frozen-string-literal: true

file = File.read('input.txt').split("\n")

input = file.map { |line| line.split(',').map { |section| section.split('-').map(&:to_i) } }

def small_section_included?(small, large)
  small_start, small_stop = small
  large_start, large_stop = large
  return false if small_start < large_start
  return false if small_stop > large_stop

  true
end

def small_section_overlap?(small, large)
  small_start, small_stop = small
  large_start, large_stop = large
  return false if small_stop < large_start
  return false if small_start > large_stop

  true
end

def assignement_full_overlap?(first_assignement, second_assignement)
  small_section_included?(first_assignement, second_assignement) ||
    small_section_included?(second_assignement, first_assignement)
end

# Answer 1
pp(
  input.count do |first_assignement, second_assignement|
    assignement_full_overlap?(first_assignement, second_assignement)
  end,
)

# Answer 2
pp(
  input.count { |first_assignement, second_assignement| small_section_overlap?(first_assignement, second_assignement) },
)
