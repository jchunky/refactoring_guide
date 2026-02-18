module TriviaKata
  module UglyTrivia
    class Game
      CATEGORY_ORDER = {
        0 => 'Pop',
        1 => 'Science',
        2 => 'Sports',
        3 => 'Rock',
        4 => 'Pop',
        5 => 'Science',
        6 => 'Sports',
        7 => 'Rock',
        8 => 'Pop',
        9 => 'Science',
        10 => 'Sports'
      }.freeze

      def  initialize
        @players = []
        @places = Array.new(6, 0)
        @purses = Array.new(6, 0)
        @in_penalty_box = Array.new(6, nil)

        @pop_questions = []
        @science_questions = []
        @sports_questions = []
        @rock_questions = []

        @current_player = 0
        @is_getting_out_of_penalty_box = false

        50.times do |i|
          @pop_questions << "Pop Question #{i}"
          @science_questions << "Science Question #{i}"
          @sports_questions << "Sports Question #{i}"
          @rock_questions << create_rock_question(i)
        end
      end

      def create_rock_question(index)
        "Rock Question #{index}"
      end

      def is_playable?
        how_many_players >= 2
      end

      def add(player_name)
        @players << player_name
        @places[how_many_players] = 0
        @purses[how_many_players] = 0
        @in_penalty_box[how_many_players] = false

        puts "#{player_name} was added"
        puts "They are player number #{@players.length}"

        true
      end

      def how_many_players
        @players.length
      end

      def roll(roll)
        puts "#{@players[@current_player]} is the current player"
        puts "They have rolled a #{roll}"

        if @in_penalty_box[@current_player]
          handle_penalty_roll(roll)
          return
        end

        move_player(roll)
        announce_location
        ask_question
      end

      def ask_question
        case current_category
        when 'Pop'
          puts @pop_questions.shift
        when 'Science'
          puts @science_questions.shift
        when 'Sports'
          puts @sports_questions.shift
        else
          puts @rock_questions.shift
        end
      end

      def current_category
        CATEGORY_ORDER.fetch(@places[@current_player], 'Rock')
      end

    public

      def was_correctly_answered
        if @in_penalty_box[@current_player]
          return handle_penalty_answer
        end

        handle_correct_answer
      end

      def wrong_answer
        puts 'Question was incorrectly answered'
        puts "#{@players[@current_player]} was sent to the penalty box"
        @in_penalty_box[@current_player] = true

        advance_player
        true
      end

    private

      def did_player_win
        !(@purses[@current_player] == 6)
      end

      def handle_penalty_roll(roll)
        if roll.odd?
          @is_getting_out_of_penalty_box = true
          puts "#{@players[@current_player]} is getting out of the penalty box"
          move_player(roll)
          announce_location
          ask_question
        else
          puts "#{@players[@current_player]} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
        end
      end

      def move_player(roll)
        @places[@current_player] = (@places[@current_player] + roll) % 12
      end

      def announce_location
        puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category}"
      end

      def handle_penalty_answer
        unless @is_getting_out_of_penalty_box
          advance_player
          return true
        end

        handle_correct_answer
      end

      def handle_correct_answer
        puts "Answer was correct!!!!"
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        advance_player
        winner
      end

      def advance_player
        @current_player += 1
        @current_player = 0 if @current_player == @players.length
      end
    end
  end
end
