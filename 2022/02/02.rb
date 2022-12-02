

PAPER = 'PAPER'
ROCK = 'ROCK'
SCISSOR = 'SCISSOR'

LOSS = 0
DRAW = 3
WIN = 6

CHOICE_TO_MOVE = {
  "A" => ROCK,
  "B" => PAPER,
  "C" => SCISSOR,
  "X" => ROCK,
  "Y" => PAPER,
  "Z" => SCISSOR,
}

CHOICE_TO_OUTCOME = {
  "X" => LOSS,
  "Y" => DRAW,
  "Z" => WIN,
}

OUTCOME_MAPPING = {
  ROCK => {
      ROCK => DRAW,
      PAPER => WIN,
      SCISSOR => LOSS,
  },
  PAPER => {
      ROCK => LOSS,
      PAPER => DRAW,
      SCISSOR => WIN,
  },
  SCISSOR => {
      ROCK => WIN,
      PAPER => LOSS,
      SCISSOR => DRAW,
  },
}

def move_score(move)
  case move
    when ROCK then 1
    when PAPER then 2
    when SCISSOR then 3
    else 0
  end
end

def match_score(opponent, me)
  OUTCOME_MAPPING[opponent][me] + move_score(me)
end

scores = []
File.open('input.txt').each do |line|
  opponent_move, my_move = line.split.map{ |choice| CHOICE_TO_MOVE[choice] }
  scores.push(match_score(opponent_move, my_move))
end

puts scores.sum

def find_move(opponent_move, outcome)
  move, score = OUTCOME_MAPPING[opponent_move].find { |k, v| v == outcome}
  return move
end


scores = []
File.open('input.txt').each do |line|
  opponent_choice, outcome = line.split
  opponent_move = CHOICE_TO_MOVE[opponent_choice]
  outcome = CHOICE_TO_OUTCOME[outcome]
  my_move = find_move(opponent_move, outcome)
  scores.push(match_score(opponent_move, my_move))
end

puts scores.sum

