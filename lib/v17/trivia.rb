module TriviaKata
  module UglyTrivia
    class Player
      def initialize(name)
        @name = name
        @location = 0
        @purse = 0
        @in_penalty_box = false
      end

      def receive(message, *args)
        case message
        in :name then @name
        in :location then @location
        in :purse then @purse
        in :in_penalty_box? then @in_penalty_box
        in :winner? then @purse >= 6
        in :move then @location = (@location + args[0]) % 12
        in :win_point then @purse += 1
        in :enter_penalty_box then @in_penalty_box = true
        in :leave_penalty_box then @in_penalty_box = false
        in :to_s then @name
        end
      end

      def to_s = @name
    end

    class QuestionBank
      CATEGORIES = %w[Pop Science Sports Rock].freeze

      def initialize
        @indices = Hash.new(0)
      end

      def receive(message, *args)
        case message
        in :category_for
          CATEGORIES[args[0] % CATEGORIES.count]
        in :next_question
          category = CATEGORIES[args[0] % CATEGORIES.count]
          index = @indices[category]
          @indices[category] += 1
          "#{category} Question #{index}"
        end
      end
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
        puts "#{player.receive(:to_s)} is the current player"
        puts "They have rolled a #{roll}"

        if player.receive(:in_penalty_box?)
          if roll.odd?
            puts "#{player} is getting out of the penalty box"
            player.receive(:leave_penalty_box)
          else
            puts "#{player} is not getting out of the penalty box"
            return
          end
        end

        player.receive(:move, roll)
        location = player.receive(:location)
        category = @questions.receive(:category_for, location)
        puts "#{player}'s new location is #{location}"
        puts "The category is #{category}"
        puts @questions.receive(:next_question, location)
      end

      def was_correctly_answered
        player = current_player
        unless player.receive(:in_penalty_box?)
          puts "Answer was correct!!!!"
          player.receive(:win_point)
          puts "#{player} now has #{player.receive(:purse)} Gold Coins."
        end
        advance_to_next_player
        !any_winner?
      end

      def wrong_answer
        player = current_player
        puts "Question was incorrectly answered"
        puts "#{player} was sent to the penalty box"
        player.receive(:enter_penalty_box)
        advance_to_next_player
        !any_winner?
      end

      private

      def current_player = @players[@current_index]
      def advance_to_next_player = @current_index = (@current_index + 1) % @players.count
      def any_winner? = @players.any? { it.receive(:winner?) }
    end
  end
end
