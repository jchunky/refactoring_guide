# frozen_string_literal: true

module TriviaKata
  module UglyTrivia
    class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
      WINNING_SCORE = 6
      BOARD_SIZE = 12

      def initialize(name) = super(name, 0, 0, false)

      def enter_penalty_box = self.in_penalty_box = true
      def leave_penalty_box = self.in_penalty_box = false
      def receive_winnings = self.purse += 1
      def move_to_next_location(roll) = self.location = (location + roll) % BOARD_SIZE

      def to_s = name
      def in_penalty_box? = in_penalty_box
      def winner? = purse >= WINNING_SCORE
    end

    class PlayerQueue < Struct.new(:players)
      def initialize = super([])

      def advance = players.rotate!
      def <<(name) = players << Player.new(name)

      def current = players.first
      def winner? = players.any?(&:winner?)
      def count = players.count
    end

    class QuestionDeck < Struct.new(:category, :index)
      def initialize(category) = super(category, 0)

      def next = "#{category} Question #{index}".tap { self.index += 1 }
    end

    class QuestionBank < Struct.new(:questions)
      CATEGORIES = %w[Pop Science Sports Rock].freeze
      QUESTIONS_PER_CATEGORY = 50

      def initialize = super(CATEGORIES.to_h { [it, QuestionDeck.new(it)] })

      def next(location) = questions[category(location)].next

      def category(location) = CATEGORIES[location % CATEGORIES.size]
    end

    class Game < Struct.new(:players, :questions)
      def initialize
        super(PlayerQueue.new, QuestionBank.new)
      end

      def add(player_name)
        players << player_name
        puts "#{player_name} was added"
        puts "They are player number #{players.count}"
      end

      def roll(roll)
        puts "#{current_player} is the current player"
        puts "They have rolled a #{roll}"
        check_if_leaving_penalty_box(roll)
        return if current_player.in_penalty_box?

        current_player.move_to_next_location(roll)
        puts "#{current_player}'s new location is #{current_location}"
        puts "The category is #{current_category}"
        puts questions.next(current_location)
      end

      def was_correctly_answered
        unless current_player.in_penalty_box?
          puts "Answer was correct!!!!"
          current_player.receive_winnings
          puts "#{current_player} now has #{current_player.purse} Gold Coins."
        end
        players.advance
        !winner?
      end

      def wrong_answer
        puts "Question was incorrectly answered"
        puts "#{current_player} was sent to the penalty box"
        current_player.enter_penalty_box
        players.advance
        !winner?
      end

      private

      def check_if_leaving_penalty_box(roll)
        return unless current_player.in_penalty_box?

        if roll.odd?
          puts "#{current_player} is getting out of the penalty box"
          current_player.leave_penalty_box
        else
          puts "#{current_player} is not getting out of the penalty box"
        end
      end

      def current_category = questions.category(current_location)
      def current_location = current_player.location
      def current_player = players.current
      def winner? = players.winner?
    end
  end
end
