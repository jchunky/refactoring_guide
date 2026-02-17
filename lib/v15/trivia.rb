module TriviaKata
  module UglyTrivia
    CATEGORIES = %w[Pop Science Sports Rock].freeze

    PlayerData = Data.define(:name, :location, :purse, :in_penalty_box) do
      def self.create(name) = new(name:, location: 0, purse: 0, in_penalty_box: false)

      def receive_winnings = with(purse: purse + 1)
      def move_to(loc) = with(location: loc)
      def enter_penalty_box = with(in_penalty_box: true)
      def leave_penalty_box = with(in_penalty_box: false)
      def in_penalty_box? = in_penalty_box
      def winner? = purse >= 6
      def to_s = name
    end

    module QuestionFn
      def self.category_for(location) = CATEGORIES[location % CATEGORIES.count]

      def self.next_question(category, index) = "#{category} Question #{index}"
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

        if player.in_penalty_box?
          if roll.odd?
            puts "#{player} is getting out of the penalty box"
            @players[@current_index] = player.leave_penalty_box
          else
            puts "#{player} is not getting out of the penalty box"
            return
          end
        end

        player = current_player
        new_location = (player.location + roll) % 12
        @players[@current_index] = player.move_to(new_location)

        category = QuestionFn.category_for(new_location)
        puts "#{current_player}'s new location is #{new_location}"
        puts "The category is #{category}"
        puts QuestionFn.next_question(category, @question_indices[category])
        @question_indices[category] += 1
      end

      def was_correctly_answered
        player = current_player
        unless player.in_penalty_box?
          puts "Answer was correct!!!!"
          @players[@current_index] = player.receive_winnings
          puts "#{current_player} now has #{current_player.purse} Gold Coins."
        end
        advance_to_next_player
        !any_winner?
      end

      def wrong_answer
        puts "Question was incorrectly answered"
        puts "#{current_player} was sent to the penalty box"
        @players[@current_index] = current_player.enter_penalty_box
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
