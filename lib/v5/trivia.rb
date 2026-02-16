module TriviaKata
  # Refactored using 99 Bottles of OOP principles:
  # - Extract class for Player concept
  # - Extract class for QuestionDeck concept  
  # - Extract class for Board/Category concept
  # - Small methods that do one thing
  # - Names reflect roles

  module UglyTrivia
    class QuestionDeck
      def initialize(category, count = 50)
        @category = category
        @questions = count.times.map { |i| "#{category} Question #{i}" }
      end

      def draw
        @questions.shift
      end
    end

    class Board
      CATEGORIES = ['Pop', 'Science', 'Sports', 'Rock'].freeze
      BOARD_SIZE = 12

      def category_for_position(position)
        CATEGORIES[position % 4]
      end

      def advance_position(current, roll)
        (current + roll) % BOARD_SIZE
      end
    end

    class TriviaPlayer
      attr_reader :name
      attr_accessor :position, :purse, :in_penalty_box

      def initialize(name)
        @name = name
        @position = 0
        @purse = 0
        @in_penalty_box = false
      end

      def add_coin
        @purse += 1
      end

      def won?
        purse == 6
      end

      def send_to_penalty_box
        @in_penalty_box = true
      end
    end

    class Game
      WINNING_PURSE = 6

      def initialize
        @players = []
        @board = Board.new
        @question_decks = {
          'Pop' => QuestionDeck.new('Pop'),
          'Science' => QuestionDeck.new('Science'),
          'Sports' => QuestionDeck.new('Sports'),
          'Rock' => QuestionDeck.new('Rock')
        }
        @current_player_index = 0
        @is_getting_out_of_penalty_box = false
      end

      def is_playable?
        how_many_players >= 2
      end

      def add(player_name)
        player = TriviaPlayer.new(player_name)
        @players << player

        puts "#{player_name} was added"
        puts "They are player number #{@players.length}"
        true
      end

      def how_many_players
        @players.length
      end

      def roll(roll)
        puts "#{current_player.name} is the current player"
        puts "They have rolled a #{roll}"

        if current_player.in_penalty_box
          handle_penalty_box_roll(roll)
        else
          move_and_ask_question(roll)
        end
      end

      def was_correctly_answered
        if current_player.in_penalty_box && !@is_getting_out_of_penalty_box
          advance_to_next_player
          return true
        end

        puts 'Answer was correct!!!!'
        current_player.add_coin
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."

        winner = !current_player.won?
        advance_to_next_player
        winner
      end

      def wrong_answer
        puts 'Question was incorrectly answered'
        puts "#{current_player.name} was sent to the penalty box"
        current_player.send_to_penalty_box

        advance_to_next_player
        true
      end

      private

      def current_player
        @players[@current_player_index]
      end

      def current_category
        @board.category_for_position(current_player.position)
      end

      def handle_penalty_box_roll(roll)
        if roll.odd?
          @is_getting_out_of_penalty_box = true
          puts "#{current_player.name} is getting out of the penalty box"
          move_and_ask_question(roll)
        else
          puts "#{current_player.name} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
        end
      end

      def move_and_ask_question(roll)
        current_player.position = @board.advance_position(current_player.position, roll)

        puts "#{current_player.name}'s new location is #{current_player.position}"
        puts "The category is #{current_category}"
        ask_question
      end

      def ask_question
        puts @question_decks[current_category].draw
      end

      def advance_to_next_player
        @current_player_index = (@current_player_index + 1) % @players.length
      end
    end
  end
end
