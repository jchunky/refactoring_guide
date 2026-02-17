module TriviaKata
  module UglyTrivia
    # Declarative category lookup
    CATEGORIES = %w[Pop Science Sports Rock].freeze
    CATEGORY_FOR = ->(location) { CATEGORIES[location % CATEGORIES.count] }

    class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
      def initialize(name) = super(name, 0, 0, false)
      def in_penalty_box? = in_penalty_box
      def winner? = purse >= 6
      def to_s = name
    end

    class QuestionBank
      def initialize = @indices = Hash.new(0)

      def next_question(location)
        category = CATEGORY_FOR.call(location)
        index = @indices[category]
        @indices[category] += 1
        "#{category} Question #{index}"
      end

      def category_for(location) = CATEGORY_FOR.call(location)
    end

    class Game
      def initialize
        @players = []
        @current_index = 0
        @questions = QuestionBank.new
      end

      def add(player_name)
        @players << Player.new(player_name)
        puts "#{player_name} was added"
        puts "They are player number #{@players.count}"
      end

      def roll(roll)
        player = current_player
        puts "#{player} is the current player"
        puts "They have rolled a #{roll}"

        if player.in_penalty_box?
          if roll.odd?
            puts "#{player} is getting out of the penalty box"
            player.in_penalty_box = false
          else
            puts "#{player} is not getting out of the penalty box"
            return
          end
        end

        player.location = (player.location + roll) % 12
        puts "#{player}'s new location is #{player.location}"
        puts "The category is #{@questions.category_for(player.location)}"
        puts @questions.next_question(player.location)
      end

      def was_correctly_answered
        player = current_player
        unless player.in_penalty_box?
          puts "Answer was correct!!!!"
          player.purse += 1
          puts "#{player} now has #{player.purse} Gold Coins."
        end
        advance_to_next_player
        !any_winner?
      end

      def wrong_answer
        puts "Question was incorrectly answered"
        puts "#{current_player} was sent to the penalty box"
        current_player.in_penalty_box = true
        advance_to_next_player
        !any_winner?
      end

      private

      def current_player = @players[@current_index]
      def advance_to_next_player = @current_index = (@current_index + 1) % @players.count
      def any_winner? = @players.any?(&:winner?)
    end
  end
end
