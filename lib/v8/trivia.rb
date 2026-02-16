module TriviaKata
  # Refactored to fix:
  # - Data Clumps: Player data grouped into TriviaPlayer class
  # - Feature Envy: Player handles its own state
  # - Data Clumps: Question categories grouped into QuestionDeck

  class QuestionDeck
    def initialize(category, count = 50)
      @category = category
      @questions = (0...count).map { |i| "#{category} Question #{i}" }
    end

    def draw
      @questions.shift
    end
  end

  class QuestionBank
    CATEGORIES = ['Pop', 'Science', 'Sports', 'Rock'].freeze
    BOARD_SIZE = 12

    def initialize
      @decks = CATEGORIES.each_with_object({}) do |category, hash|
        hash[category] = QuestionDeck.new(category)
      end
    end

    def draw_question(position)
      category = category_for(position)
      @decks[category].draw
    end

    def category_for(position)
      case position % 4
      when 0 then 'Pop'
      when 1 then 'Science'
      when 2 then 'Sports'
      else 'Rock'
      end
    end
  end

  class TriviaPlayer
    BOARD_SIZE = 12
    WINNING_SCORE = 6

    attr_reader :name, :position, :purse
    attr_accessor :in_penalty_box, :getting_out_of_penalty_box

    def initialize(name)
      @name = name
      @position = 0
      @purse = 0
      @in_penalty_box = false
      @getting_out_of_penalty_box = false
    end

    def move(spaces)
      @position = (@position + spaces) % BOARD_SIZE
    end

    def earn_coin
      @purse += 1
    end

    def won?
      @purse >= WINNING_SCORE
    end

    def send_to_penalty_box
      @in_penalty_box = true
    end
  end

  module UglyTrivia
    class Game
      def initialize
        @players = []
        @current_player_index = 0
        @question_bank = QuestionBank.new
      end

      def is_playable?
        @players.size >= 2
      end

      def add(player_name)
        player = TriviaPlayer.new(player_name)
        @players << player

        puts "#{player_name} was added"
        puts "They are player number #{@players.size}"
        true
      end

      def how_many_players
        @players.size
      end

      def roll(roll)
        player = current_player
        puts "#{player.name} is the current player"
        puts "They have rolled a #{roll}"

        if player.in_penalty_box
          if roll.odd?
            player.getting_out_of_penalty_box = true
            puts "#{player.name} is getting out of the penalty box"
            move_and_ask_question(player, roll)
          else
            puts "#{player.name} is not getting out of the penalty box"
            player.getting_out_of_penalty_box = false
          end
        else
          move_and_ask_question(player, roll)
        end
      end

      def was_correctly_answered
        player = current_player

        if player.in_penalty_box && !player.getting_out_of_penalty_box
          advance_turn
          return true
        end

        puts 'Answer was correct!!!!'
        player.earn_coin
        puts "#{player.name} now has #{player.purse} Gold Coins."

        winner = !player.won?
        advance_turn
        winner
      end

      def wrong_answer
        player = current_player
        puts 'Question was incorrectly answered'
        puts "#{player.name} was sent to the penalty box"
        player.send_to_penalty_box

        advance_turn
        true
      end

      private

      def current_player
        @players[@current_player_index]
      end

      def advance_turn
        @current_player_index = (@current_player_index + 1) % @players.size
      end

      def move_and_ask_question(player, roll)
        player.move(roll)
        puts "#{player.name}'s new location is #{player.position}"
        puts "The category is #{@question_bank.category_for(player.position)}"
        puts @question_bank.draw_question(player.position)
      end
    end
  end
end
