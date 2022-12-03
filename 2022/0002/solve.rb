# "The first column is what your opponent is going to play: A for Rock, B for Paper, and C for Scissors. The second column--"
# The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for Scissors.
# The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).

$moves = [:rock, :paper, :scissors]
$outcomes = [:loss, :draw, :win]
rounds = File.open("input").readlines.map(&:chomp).map(&:split)
decoding1 = {
  :A => :rock, :B => :paper, :C => :scissors,
  :X => :rock, :Y => :paper, :Z => :scissors,
}
part1_interpretation = rounds.map { |a,b| [decoding1[a.to_sym], decoding1[b.to_sym]] }

def outcome(theirs, mine)
  wins = [[:rock, :paper], [:paper, :scissors], [:scissors, :rock]]
  return :draw if theirs == mine
  return :win if wins.include? [theirs, mine]
  return :loss
end
def score(theirs, mine)
  ($moves.index(mine) + 1) + $outcomes.index(outcome(theirs, mine)) * 3
end
puts "part 1:"
puts part1_interpretation.map {|theirs, mine| score(theirs, mine)}.sum

decoding2 = {
  :A => :rock, :B => :paper, :C => :scissors,
  :X => :loss, :Y => :draw, :Z => :win,
}
part2_interpretation = rounds.map { |a,b| [decoding2[a.to_sym], decoding2[b.to_sym]] }
def solve(theirs, desired_outcome)
  $moves.filter {|mine| desired_outcome == outcome(theirs, mine)}[0]
end
def score2(theirs, desired)
  return score(theirs, solve(theirs, desired))
end
puts "part 2:"
puts part2_interpretation.map {|theirs, desired| score2(theirs, desired)}.sum