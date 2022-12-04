# frozen-string-literal: true

file = File.read('input.txt').split("\n")

SCORE_BY_OUTCOME = { LOSS: 0, DRAW: 3, WIN: 6 }.freeze
SCORE_BY_MOVE = { ROCK: 1, PAPER: 2, SCISSOR: 3 }.freeze

OUTCOME_TABLE = {
  ROCK: {
    ROCK: :DRAW,
    PAPER: :WIN,
    SCISSOR: :LOSS,
  },
  PAPER: {
    ROCK: :LOSS,
    PAPER: :DRAW,
    SCISSOR: :WIN,
  },
  SCISSOR: {
    ROCK: :WIN,
    PAPER: :LOSS,
    SCISSOR: :DRAW,
  },
}

MOVE_BY_ENCRYPTED_INPUT = { A: :ROCK, B: :PAPER, C: :SCISSOR, X: :ROCK, Y: :PAPER, Z: :SCISSOR }.freeze

def match_score(opponent_move, my_move)
  outcome = OUTCOME_TABLE[opponent_move][my_move]
  SCORE_BY_OUTCOME[outcome] + SCORE_BY_MOVE[my_move]
end

# Answer 1
result =
  file
    .map do |line|
      opponent_move, my_move = line.split.map(&:to_sym).map { |input| MOVE_BY_ENCRYPTED_INPUT[input] }
      match_score(opponent_move, my_move)
    end
    .sum
pp result

def find_move(opponent_move, outcome)
  move, = OUTCOME_TABLE[opponent_move].find { |_, target_outcome| target_outcome == outcome }
  move
end

OUTCOME_BY_ENCRYPTED_INPUT = { X: :LOSS, Y: :DRAW, Z: :WIN }.freeze

# Answer 2
result =
  file
    .map do |line|
      opponent_input, outcome = line.split.map(&:to_sym)
      opponent_move = MOVE_BY_ENCRYPTED_INPUT[opponent_input]
      outcome = OUTCOME_BY_ENCRYPTED_INPUT[outcome]
      my_move = find_move(opponent_move, outcome)
      match_score(opponent_move, my_move)
    end
    .sum
pp result
