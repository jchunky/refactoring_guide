module TriviaKata
  module UglyTrivia
    class PlayerQueue < Struct.new(:players)
      def initialize = super([])

      def add(player_name) = players << Player.new(player_name)
      def next = players.rotate!

      def count = players.count
      def current = players.first
      def winner? = players.any?(&:winner?)
    end

    class QuestionDeck < Struct.new(:questions)
      CATEGORIES = %w[Pop Science Sports Rock]

      def initialize = super(CATEGORIES.to_h { [it, 0] })

      def next_question(location)
        category = category_for(location)
        index = questions[category]
        questions[category] += 1
        "#{category} Question #{index}"
      end

      def category_for(location) = CATEGORIES[location % CATEGORIES.count]
    end

    class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
      alias in_penalty_box? in_penalty_box

      def initialize(name) = super(name, 0, 0, false)

      def receive_winnings = self.purse += 1
      def move_to_next_location(roll) = self.location = (location + roll) % 12
      def enter_penalty_box = self.in_penalty_box = true
      def leave_penalty_box = self.in_penalty_box = false

      def to_s = name
      def winner? = purse >= 6
    end

    class Game < Struct.new(:players, :questions)
      def initialize = super(PlayerQueue.new, QuestionDeck.new)

      def add(player_name)
        players.add(player_name)
        puts "#{player_name} was added"
        puts "They are player number #{players.count}"
      end

      def roll(roll)
        puts "#{current_player} is the current player"
        puts "They have rolled a #{roll}"
        check_if_leaving_penalty_box(roll)
        return if current_player.in_penalty_box?

        current_player.move_to_next_location(roll)
        puts "#{current_player}'s new location is #{current_player.location}"
        puts "The category is #{current_category}"
        puts next_question
      end

      def was_correctly_answered
        unless current_player.in_penalty_box?
          puts "Answer was correct!!!!"
          current_player.receive_winnings
          puts "#{current_player} now has #{current_player.purse} Gold Coins."
        end
        advance_to_next_player
        !winner?
      end

      def wrong_answer
        puts "Question was incorrectly answered"
        puts "#{current_player} was sent to the penalty box"
        current_player.enter_penalty_box
        advance_to_next_player
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

      def next_question = questions.next_question(current_location)
      def advance_to_next_player = players.next

      def current_category = %w[Pop Science Sports Rock][current_location % 4]
      def current_location = current_player.location
      def current_player = players.current
      def winner? = players.winner?
    end
  end
end
