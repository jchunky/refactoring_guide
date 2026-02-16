module UglyTrivia
  class Game
    BOARD_SIZE = 12
    QUESTIONS_PER_CATEGORY = 50
    WINNING_SCORE = 6
    CATEGORIES = ['Pop', 'Science', 'Sports', 'Rock'].freeze

    def initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, false)
      @current_player = 0
      @is_getting_out_of_penalty_box = false

      @questions = initialize_questions
    end

    def is_playable?
      player_count >= 2
    end

    def add(player_name)
      @players << player_name

      puts "#{player_name} was added"
      puts "They are player number #{player_count}"

      true
    end

    def roll(roll)
      puts "#{current_player_name} is the current player"
      puts "They have rolled a #{roll}"

      if in_penalty_box?
        handle_penalty_box_roll(roll)
      else
        move_and_ask(roll)
      end
    end

    def was_correctly_answered
      if in_penalty_box? && !@is_getting_out_of_penalty_box
        advance_player
        return true
      end

      award_correct_answer
      winner = !player_won?
      advance_player
      winner
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{current_player_name} was sent to the penalty box"
      @in_penalty_box[@current_player] = true

      advance_player
      true
    end

    private

    def initialize_questions
      CATEGORIES.each_with_object({}) do |category, questions|
        questions[category] = QUESTIONS_PER_CATEGORY.times.map { |i| "#{category} Question #{i}" }
      end
    end

    def player_count
      @players.length
    end

    def current_player_name
      @players[@current_player]
    end

    def in_penalty_box?
      @in_penalty_box[@current_player]
    end

    def handle_penalty_box_roll(roll)
      if odd?(roll)
        @is_getting_out_of_penalty_box = true
        puts "#{current_player_name} is getting out of the penalty box"
        move_and_ask(roll)
      else
        @is_getting_out_of_penalty_box = false
        puts "#{current_player_name} is not getting out of the penalty box"
      end
    end

    def odd?(number)
      number.odd?
    end

    def move_and_ask(roll)
      move_player(roll)
      puts "#{current_player_name}'s new location is #{current_place}"
      puts "The category is #{current_category}"
      ask_question
    end

    def move_player(roll)
      @places[@current_player] = (@places[@current_player] + roll) % BOARD_SIZE
    end

    def current_place
      @places[@current_player]
    end

    def current_category
      CATEGORIES[current_place % CATEGORIES.length]
    end

    def ask_question
      puts @questions[current_category].shift
    end

    def award_correct_answer
      message = in_penalty_box? ? 'Answer was correct!!!!' : 'Answer was correct!!!!'
      puts message
      @purses[@current_player] += 1
      puts "#{current_player_name} now has #{@purses[@current_player]} Gold Coins."
    end

    def advance_player
      @current_player = (@current_player + 1) % player_count
    end

    def player_won?
      @purses[@current_player] == WINNING_SCORE
    end
  end
end
