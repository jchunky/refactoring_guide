module TriviaKata
  module UglyTrivia
    CATEGORIES = %w[Pop Science Sports Rock].freeze

    PlayerData = Data.define(:name, :location, :purse, :in_penalty_box) do
      def self.create(name) = new(name:, location: 0, purse: 0, in_penalty_box: false)

      def in_penalty_box? = in_penalty_box
      def winner? = purse >= 6
      def to_s = name
    end

    module CategoryFn
      def self.for_location(location)
        case location % 4
        in 0 then "Pop"
        in 1 then "Science"
        in 2 then "Sports"
        in 3 then "Rock"
        end
      end
    end

    class Game
      def initialize
        @players = []
        @current_index = 0
        @question_indices = Hash.new(0)
      end

      def add(player_name)
        @players << PlayerData.create(player_name)
        puts "#{player_name} was added"
        puts "They are player number #{@players.count}"
      end

      def roll(roll)
        player = current_player
        puts "#{player} is the current player"
        puts "They have rolled a #{roll}"

        case [player.in_penalty_box?, roll.odd?]
        in [true, true]
          puts "#{player} is getting out of the penalty box"
          @players[@current_index] = player.with(in_penalty_box: false)
        in [true, false]
          puts "#{player} is not getting out of the penalty box"
          return
        in [false, _]
          # not in penalty box, proceed
        end

        player = current_player
        new_location = (player.location + roll) % 12
        @players[@current_index] = player.with(location: new_location)

        category = CategoryFn.for_location(new_location)
        puts "#{current_player}'s new location is #{new_location}"
        puts "The category is #{category}"
        puts "#{category} Question #{@question_indices[category]}"
        @question_indices[category] += 1
      end

      def was_correctly_answered
        player = current_player
        case player.in_penalty_box?
        in false
          puts "Answer was correct!!!!"
          @players[@current_index] = player.with(purse: player.purse + 1)
          puts "#{current_player} now has #{current_player.purse} Gold Coins."
        in true
          # still in penalty box, no action
        end
        advance_to_next_player
        !any_winner?
      end

      def wrong_answer
        puts "Question was incorrectly answered"
        puts "#{current_player} was sent to the penalty box"
        @players[@current_index] = current_player.with(in_penalty_box: true)
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
