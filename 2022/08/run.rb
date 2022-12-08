# frozen_string_literal: true

TREE_MAP = File.read('input.txt').split("\n").map { |line| line.chars.map(&:to_i) }
MAP_SIZE = TREE_MAP.size

def visible_from_outside?(i, j)
  tree_size = TREE_MAP[i][j]

  return true if (0...i).all? { |k| TREE_MAP[k][j] < tree_size }
  return true if (i + 1...MAP_SIZE).all? { |k| TREE_MAP[k][j] < tree_size }
  return true if (0...j).all? { |k| TREE_MAP[i][k] < tree_size }
  return true if (j + 1...MAP_SIZE).all? { |k| TREE_MAP[i][k] < tree_size }

  false
end

# Answer 1
scenic_score = TREE_MAP.map.with_index { |line, i| line.map.with_index { |_, j| visible_from_outside?(i, j) } }
pp scenic_score.map { |line| line.count(&:itself) }.sum

def scenic_score_up(i, j)
  score = 0
  (0...i).each do |k|
    score += 1

    break if TREE_MAP[i - 1 - k][j] >= TREE_MAP[i][j]
  end
  score
end

def scenic_score_down(i, j)
  score = 0
  (i + 1...MAP_SIZE).each do |k|
    score += 1

    break if TREE_MAP[k][j] >= TREE_MAP[i][j]
  end
  score
end

def scenic_score_left(i, j)
  score = 0
  (0...j).each do |k|
    score += 1

    break if TREE_MAP[i][j - 1 - k] >= TREE_MAP[i][j]
  end
  score
end

def scenic_score_right(i, j)
  score = 0
  (j + 1...MAP_SIZE).each do |k|
    score += 1

    break if TREE_MAP[i][k] >= TREE_MAP[i][j]
  end
  score
end

def scenic_score(i, j)
  scenic_score_up(i, j) * scenic_score_down(i, j) * scenic_score_left(i, j) * scenic_score_right(i, j)
end

# Answer 2
scenic_score_map = TREE_MAP.map.with_index { |line, i| line.map.with_index { |_, j| scenic_score(i, j) } }
pp scenic_score_map.map(&:max).max
