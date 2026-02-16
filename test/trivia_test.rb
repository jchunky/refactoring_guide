require 'test/unit'
require 'stringio'
require_relative '../lib/version_loader'
VersionLoader.require_kata('trivia')

class GameTest < Test::Unit::TestCase
  def test_it_works
    game = UglyTrivia::Game.new
    expected = <<~STRING
      Chet was added
      They are player number 1
      Pat was added
      They are player number 2
      Sue was added
      They are player number 3
      Chet is the current player
      They have rolled a 6
      Chet's new location is 6
      The category is Sports
      Sports Question 0
      Answer was correct!!!!
      Chet now has 1 Gold Coins.
      Pat is the current player
      They have rolled a 6
      Pat's new location is 6
      The category is Sports
      Sports Question 1
      Answer was correct!!!!
      Pat now has 1 Gold Coins.
      Sue is the current player
      They have rolled a 6
      Sue's new location is 6
      The category is Sports
      Sports Question 2
      Answer was correct!!!!
      Sue now has 1 Gold Coins.
      Chet is the current player
      They have rolled a 1
      Chet's new location is 7
      The category is Rock
      Rock Question 0
      Answer was correct!!!!
      Chet now has 2 Gold Coins.
      Pat is the current player
      They have rolled a 3
      Pat's new location is 9
      The category is Science
      Science Question 0
      Question was incorrectly answered
      Pat was sent to the penalty box
      Sue is the current player
      They have rolled a 1
      Sue's new location is 7
      The category is Rock
      Rock Question 1
      Answer was correct!!!!
      Sue now has 2 Gold Coins.
      Chet is the current player
      They have rolled a 6
      Chet's new location is 1
      The category is Science
      Science Question 1
      Answer was correct!!!!
      Chet now has 3 Gold Coins.
      Pat is the current player
      They have rolled a 4
      Pat is not getting out of the penalty box
      Sue is the current player
      They have rolled a 1
      Sue's new location is 8
      The category is Pop
      Pop Question 0
      Answer was correct!!!!
      Sue now has 3 Gold Coins.
      Chet is the current player
      They have rolled a 2
      Chet's new location is 3
      The category is Rock
      Rock Question 2
      Answer was correct!!!!
      Chet now has 4 Gold Coins.
      Pat is the current player
      They have rolled a 4
      Pat is not getting out of the penalty box
      Sue is the current player
      They have rolled a 6
      Sue's new location is 2
      The category is Sports
      Sports Question 3
      Answer was correct!!!!
      Sue now has 4 Gold Coins.
      Chet is the current player
      They have rolled a 1
      Chet's new location is 4
      The category is Pop
      Pop Question 1
      Answer was correct!!!!
      Chet now has 5 Gold Coins.
      Pat is the current player
      They have rolled a 2
      Pat is not getting out of the penalty box
      Sue is the current player
      They have rolled a 3
      Sue's new location is 5
      The category is Science
      Science Question 2
      Answer was correct!!!!
      Sue now has 5 Gold Coins.
      Chet is the current player
      They have rolled a 4
      Chet's new location is 8
      The category is Pop
      Pop Question 2
      Answer was correct!!!!
      Chet now has 6 Gold Coins.
    STRING

    output = capture do
      game.add('Chet')
      game.add('Pat')
      game.add('Sue')

      game.roll(6)
      game.was_correctly_answered
      game.roll(6)
      game.was_correctly_answered
      game.roll(6)
      game.was_correctly_answered

      game.roll(1)
      game.was_correctly_answered
      game.roll(3)
      game.wrong_answer
      game.roll(1)
      game.was_correctly_answered

      game.roll(6)
      game.was_correctly_answered
      game.roll(4)
      game.was_correctly_answered
      game.roll(1)
      game.was_correctly_answered

      game.roll(2)
      game.was_correctly_answered
      game.roll(4)
      game.was_correctly_answered
      game.roll(6)
      game.was_correctly_answered

      game.roll(1)
      game.was_correctly_answered
      game.roll(2)
      game.was_correctly_answered
      game.roll(3)
      game.was_correctly_answered

      game.roll(4)
      game.was_correctly_answered
    end

    assert_equal expected, output
  end

  def capture
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
