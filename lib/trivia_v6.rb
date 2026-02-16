module UglyTrivia
  class Game
    CATEGORIES = ['Pop', 'Science', 'Sports', 'Rock'].freeze
    WINNING_SCORE = 6
    BOARD_SIZE = 12

    def initialize
      @players = []
      @current_player_index = 0
      @is_getting_out_of_penalty_box = false
      @questions = QuestionDeck.new
    end

    def is_playable? = @players.length >= 2
    def how_many_players = @players.length

    def add(player_name)
      @players << PlayerState.new(player_name)
      announce_player_added(player_name)
      true
    end

    def roll(roll_value)
      announce_current_player_roll(roll_value)
      current_player.roll(roll_value, @questions, self)
    end

    def was_correctly_answered
      result = current_player.correct_answer(self)
      advance_to_next_player
      result
    end

    def wrong_answer
      current_player.wrong_answer(self)
      advance_to_next_player
      true
    end

    def current_player = @players[@current_player_index]

    def announce_getting_out = puts "#{current_player.name} is getting out of the penalty box"
    def announce_staying_in = puts "#{current_player.name} is not getting out of the penalty box"
    def announce_location = puts "#{current_player.name}'s new location is #{current_player.place}"
    def announce_category = puts "The category is #{current_category}"
    def announce_correct = puts 'Answer was correct!!!!'
    def announce_coins = puts "#{current_player.name} now has #{current_player.coins} Gold Coins."
    def announce_wrong = puts 'Question was incorrectly answered'
    def announce_penalty = puts "#{current_player.name} was sent to the penalty box"

    def current_category
      CATEGORIES[current_player.place % 4]
    end

    private

    def announce_player_added(name)
      puts "#{name} was added"
      puts "They are player number #{@players.length}"
    end

    def announce_current_player_roll(roll_value)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll_value}"
    end

    def advance_to_next_player
      @current_player_index = (@current_player_index + 1) % @players.length
    end
  end

  class PlayerState
    attr_reader :name, :place, :coins

    def initialize(name)
      @name = name
      @place = 0
      @coins = 0
      @in_penalty_box = false
      @getting_out = false
    end

    def roll(roll_value, questions, game)
      return roll_in_penalty_box(roll_value, questions, game) if @in_penalty_box
      move_and_ask(roll_value, questions, game)
    end

    def correct_answer(game)
      return correct_in_penalty_box(game) if @in_penalty_box
      award_coin(game)
    end

    def wrong_answer(game)
      game.announce_wrong
      game.announce_penalty
      @in_penalty_box = true
    end

    def in_penalty_box? = @in_penalty_box

    private

    def roll_in_penalty_box(roll_value, questions, game)
      @getting_out = roll_value.odd?
      return stay_in_penalty_box(game) unless @getting_out
      getting_out_of_penalty_box(roll_value, questions, game)
    end

    def stay_in_penalty_box(game)
      game.announce_staying_in
    end

    def getting_out_of_penalty_box(roll_value, questions, game)
      game.announce_getting_out
      move_and_ask(roll_value, questions, game)
    end

    def move_and_ask(roll_value, questions, game)
      move(roll_value)
      game.announce_location
      game.announce_category
      questions.ask(game.current_category)
    end

    def move(roll_value)
      @place = (@place + roll_value) % Game::BOARD_SIZE
    end

    def correct_in_penalty_box(game)
      return true unless @getting_out
      award_coin(game)
    end

    def award_coin(game)
      game.announce_correct
      @coins += 1
      game.announce_coins
      @coins != Game::WINNING_SCORE
    end
  end

  class QuestionDeck
    def initialize
      @questions = Hash.new { |h, k| h[k] = [] }
      50.times { |i| create_questions(i) }
    end

    def ask(category)
      puts @questions[category].shift
    end

    private

    def create_questions(index)
      Game::CATEGORIES.each { |cat| @questions[cat] << "#{cat} Question #{index}" }
    end
  end
end
