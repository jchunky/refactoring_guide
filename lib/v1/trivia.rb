module TriviaKata
  module UglyTrivia
    class Game
      def initialize
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
          @pop_questions.push "Pop Question #{i}"
          @science_questions.push "Science Question #{i}"
          @sports_questions.push "Sports Question #{i}"
          @rock_questions.push "Rock Question #{i}"
        end
      end

      def is_playable?
        how_many_players >= 2
      end

      def add(player_name)
        @players.push player_name
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
          if roll.odd?
            @is_getting_out_of_penalty_box = true
            puts "#{@players[@current_player]} is getting out of the penalty box"
            move_player_and_ask_question(roll)
          else
            puts "#{@players[@current_player]} is not getting out of the penalty box"
            @is_getting_out_of_penalty_box = false
          end
        else
          move_player_and_ask_question(roll)
        end
      end

      def ask_question
        questions = {
          'Pop' => @pop_questions,
          'Science' => @science_questions,
          'Sports' => @sports_questions,
          'Rock' => @rock_questions
        }
        puts questions[current_category].shift
      end

      def current_category
        case @places[@current_player] % 4
        when 0 then 'Pop'
        when 1 then 'Science'
        when 2 then 'Sports'
        else 'Rock'
        end
      end

      def was_correctly_answered
        if @in_penalty_box[@current_player] && !@is_getting_out_of_penalty_box
          advance_player
          return true
        end

        puts 'Answer was correct!!!!'
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        advance_player
        winner
      end

      def wrong_answer
        puts 'Question was incorrectly answered'
        puts "#{@players[@current_player]} was sent to the penalty box"
        @in_penalty_box[@current_player] = true

        advance_player
        true
      end

      private

      def move_player_and_ask_question(roll)
        @places[@current_player] += roll
        @places[@current_player] -= 12 if @places[@current_player] > 11

        puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category}"
        ask_question
      end

      def advance_player
        @current_player += 1
        @current_player = 0 if @current_player == @players.length
      end

      def did_player_win
        @purses[@current_player] != 6
      end
    end
  end
end
