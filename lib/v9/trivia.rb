# Trivia Game Kata
#
# A board game where players answer trivia questions to earn gold coins.
# Players roll dice to move around a circular board with category-specific spaces.
# Wrong answers send players to the penalty box.
#
# Game rules:
# - Minimum 2 players required
# - Board has 12 spaces (0-11), wrapping around
# - Each space belongs to a category: Pop, Science, Sports, or Rock
# - Correct answers earn 1 gold coin
# - First player to 6 gold coins wins
# - Players in penalty box can only leave on odd dice rolls

module TriviaKata
  module UglyTrivia
    class Game
      # Game configuration constants
      BOARD_SIZE = 12
      QUESTIONS_PER_CATEGORY = 50
      GOLD_COINS_TO_WIN = 6
      MINIMUM_PLAYERS = 2
      MAX_PLAYERS = 6

      # Question categories
      CATEGORIES = [:pop, :science, :sports, :rock].freeze

      # Board space to category mapping
      # Spaces 0, 4, 8 = Pop
      # Spaces 1, 5, 9 = Science
      # Spaces 2, 6, 10 = Sports
      # All other spaces = Rock
      CATEGORY_BY_SPACE = {
        0 => :pop, 4 => :pop, 8 => :pop,
        1 => :science, 5 => :science, 9 => :science,
        2 => :sports, 6 => :sports, 10 => :sports,
        3 => :rock, 7 => :rock, 11 => :rock
      }.freeze

      def initialize
        @players = []
        @player_positions = Array.new(MAX_PLAYERS, 0)
        @player_gold_coins = Array.new(MAX_PLAYERS, 0)
        @player_in_penalty_box = Array.new(MAX_PLAYERS, false)

        @question_decks = initialize_question_decks
        @current_player_index = 0
        @current_player_leaving_penalty_box = false
      end

      def is_playable?
        player_count >= MINIMUM_PLAYERS
      end

      def add(player_name)
        @players << player_name
        player_index = player_count
        @player_positions[player_index] = 0
        @player_gold_coins[player_index] = 0
        @player_in_penalty_box[player_index] = false

        puts "#{player_name} was added"
        puts "They are player number #{@players.length}"

        true
      end

      def player_count
        @players.length
      end

      # Called when current player rolls the dice
      def roll(dice_value)
        puts "#{current_player_name} is the current player"
        puts "They have rolled a #{dice_value}"

        if current_player_in_penalty_box?
          handle_penalty_box_roll(dice_value)
        else
          move_player_and_ask_question(dice_value)
        end
      end

      # Called when current player answers correctly
      def was_correctly_answered
        if current_player_in_penalty_box?
          handle_correct_answer_from_penalty_box
        else
          handle_correct_answer
        end
      end

      # Called when current player answers incorrectly
      def wrong_answer
        puts 'Question was incorrectly answered'
        puts "#{current_player_name} was sent to the penalty box"
        @player_in_penalty_box[@current_player_index] = true

        advance_to_next_player
        true
      end

      private

      # ============================================
      # QUESTION DECK MANAGEMENT
      # ============================================

      def initialize_question_decks
        {
          pop: create_question_deck("Pop"),
          science: create_question_deck("Science"),
          sports: create_question_deck("Sports"),
          rock: create_question_deck("Rock")
        }
      end

      def create_question_deck(category_name)
        QUESTIONS_PER_CATEGORY.times.map do |question_number|
          "#{category_name} Question #{question_number}"
        end
      end

      def ask_question
        category = current_space_category
        question = @question_decks[category].shift
        puts question
      end

      # ============================================
      # BOARD AND POSITION MANAGEMENT
      # ============================================

      def current_space_category
        space = @player_positions[@current_player_index]
        CATEGORY_BY_SPACE.fetch(space, :rock)
      end

      def current_category_name
        current_space_category.to_s.capitalize
      end

      def move_player(spaces)
        @player_positions[@current_player_index] += spaces
        # Wrap around if past end of board
        @player_positions[@current_player_index] %= BOARD_SIZE
      end

      # ============================================
      # PLAYER STATE HELPERS
      # ============================================

      def current_player_name
        @players[@current_player_index]
      end

      def current_player_in_penalty_box?
        @player_in_penalty_box[@current_player_index]
      end

      def advance_to_next_player
        @current_player_index = (@current_player_index + 1) % @players.length
      end

      # ============================================
      # DICE ROLL HANDLING
      # ============================================

      def handle_penalty_box_roll(dice_value)
        if odd_roll?(dice_value)
          @current_player_leaving_penalty_box = true
          puts "#{current_player_name} is getting out of the penalty box"
          move_player_and_ask_question(dice_value)
        else
          @current_player_leaving_penalty_box = false
          puts "#{current_player_name} is not getting out of the penalty box"
        end
      end

      def odd_roll?(dice_value)
        dice_value.odd?
      end

      def move_player_and_ask_question(dice_value)
        move_player(dice_value)

        puts "#{current_player_name}'s new location is #{@player_positions[@current_player_index]}"
        puts "The category is #{current_category_name}"
        ask_question
      end

      # ============================================
      # ANSWER HANDLING
      # ============================================

      def handle_correct_answer_from_penalty_box
        if @current_player_leaving_penalty_box
          handle_correct_answer
        else
          # Player stayed in penalty box, didn't answer
          advance_to_next_player
          true
        end
      end

      def handle_correct_answer
        puts 'Answer was correct!!!!'
        award_gold_coin

        game_continues = !current_player_won?
        advance_to_next_player
        game_continues
      end

      def award_gold_coin
        @player_gold_coins[@current_player_index] += 1
        puts "#{current_player_name} now has #{@player_gold_coins[@current_player_index]} Gold Coins."
      end

      def current_player_won?
        @player_gold_coins[@current_player_index] >= GOLD_COINS_TO_WIN
      end
    end
  end
end
