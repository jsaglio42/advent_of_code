# frozen_string_literal: true

file = File.read('input.txt').split("\n")

CURRENT_PATH = ['/']
FILE_SYSTEM = { '/' => {} }

file.each do |line|
  if line.start_with?('$ cd')
    _, _, arg = line.split
    case arg
    when '/'
      CURRENT_PATH.clear
      CURRENT_PATH.push('/')
    when '..'
      CURRENT_PATH.pop
    else
      CURRENT_PATH.push(arg)
    end
  elsif line == '$ ls'
    next
  elsif line.start_with?('dir')
    _, dir_name = line.split
    tmp = FILE_SYSTEM.dig(*CURRENT_PATH)
    tmp[dir_name] = {}
  else
    size, file = line.split
    tmp = FILE_SYSTEM.dig(*CURRENT_PATH)
    tmp[file] = size.to_i
  end
end

def dir_size(hash)
  hash.reduce(0) do |acc, item|
    _, v = item
    v.is_a?(Hash) ? acc + dir_size(v) : acc + v
  end
end

def dir_strange_size(hash)
  subdir_strange_size =
    hash.reduce(0) do |acc, item|
      _, v = item
      v.is_a?(Hash) ? acc + dir_strange_size(v) : acc
    end
  current_folder_size = dir_size(hash)
  current_folder_size <= 100_000 ? subdir_strange_size + current_folder_size : subdir_strange_size
end

# pp FILE_SYSTEM
# Answer 1
pp dir_strange_size(FILE_SYSTEM)

# Answer 2
DISK_SIZE = 70_000_000
NEEDED_SPACE = 30_000_000
FREE_SPACE = DISK_SIZE - dir_size(FILE_SYSTEM)
SPACE_TO_FREE = NEEDED_SPACE - FREE_SPACE

def valid_directory_sizes(hash, treshold)
  tmp = []
  tmp.push(dir_size(hash)) if dir_size(hash) >= treshold
  hash.each { |_, v| tmp.push(valid_directory_sizes(v, treshold)) if v.is_a?(Hash) }
  tmp
end

pp valid_directory_sizes(FILE_SYSTEM, SPACE_TO_FREE).flatten.min
