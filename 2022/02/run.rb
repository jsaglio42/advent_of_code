# frozen_string_literal: true

file = File.read('input.txt').split("\n")

SCORE_BY_OUTCOME = { LOSS: 0, DRAW: 3, WIN: 6 }.freeze
SCORE_BY_MOVE = { ROCK: 1, PAPER: 2, SCISSOR: 3 }.freeze

WINING_MOVES = { ROCK: :PAPER, SCISSOR: :ROCK, PAPER: :SCISSOR }.freeze
LOSING_MOVES = WINING_MOVES.to_a.map(&:reverse).to_h

MOVE_BY_ENCRYPTED_INPUT = { A: :ROCK, B: :PAPER, C: :SCISSOR, X: :ROCK, Y: :PAPER, Z: :SCISSOR }.freeze

def math_outchome(opponent_move, my_move)
  return :DRAW if opponent_move == my_move

  WINING_MOVES[opponent_move] == my_move ? :WIN : :LOSS
end

def match_score(opponent_move, my_move)
  outcome = math_outchome(opponent_move, my_move)
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
  return opponent_move if outcome == :DRAW

  outcome == :WIN ? WINING_MOVES[opponent_move] : LOSING_MOVES[opponent_move]
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
