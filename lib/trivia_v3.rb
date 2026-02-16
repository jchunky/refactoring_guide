module UglyTrivia
  class Player < Struct.new(:name, :place, :purse, :in_penalty_box, keyword_init: true)
    alias to_s name
    alias in_penalty_box? in_penalty_box

    WINNING_SCORE = 6
    BOARD_SIZE = 12

    def initialize(name:)
      super(name:, place: 0, purse: 0, in_penalty_box: false)
    end

    def move(roll)
      self.place = (place + roll) % BOARD_SIZE
    end

    def award_coin
      self.purse += 1
    end

    def send_to_penalty_box
      self.in_penalty_box = true
    end

    def winner? = purse == WINNING_SCORE
  end

  class QuestionDeck < Struct.new(:category, :questions)
    def self.build(category, count: 50)
      questions = count.times.map { "#{category} Question #{it}" }
      new(category, questions)
    end

    def draw = questions.shift
  end

  class Game
    CATEGORIES = %w[Pop Science Sports Rock].freeze
    CATEGORY_PATTERN = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3].freeze

    def initialize
      @players = []
      @current_player_index = 0
      @is_getting_out_of_penalty_box = false
      @decks = CATEGORIES.to_h { [it, QuestionDeck.build(it)] }
    end

    def is_playable? = @players.size >= 2

    def add(player_name)
      @players << Player.new(name: player_name)
      puts "#{player_name} was added"
      puts "They are player number #{@players.size}"
      true
    end

    def how_many_players = @players.size

    def roll(roll)
      puts "#{current_player} is the current player"
      puts "They have rolled a #{roll}"

      if current_player.in_penalty_box?
        handle_penalty_box_roll(roll)
      else
        move_and_ask(roll)
      end
    end

    def was_correctly_answered
      if current_player.in_penalty_box? && !@is_getting_out_of_penalty_box
        advance_turn
        return true
      end

      puts current_player.in_penalty_box? ? 'Answer was correct!!!!' : 'Answer was correct!!!!'
      current_player.award_coin
      puts "#{current_player} now has #{current_player.purse} Gold Coins."

      winner = !current_player.winner?
      advance_turn
      winner
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{current_player} was sent to the penalty box"
      current_player.send_to_penalty_box
      advance_turn
      true
    end

    private

    def current_player = @players[@current_player_index]

    def advance_turn
      @current_player_index = (@current_player_index + 1) % @players.size
    end

    def handle_penalty_box_roll(roll)
      if roll.odd?
        @is_getting_out_of_penalty_box = true
        puts "#{current_player} is getting out of the penalty box"
        move_and_ask(roll)
      else
        @is_getting_out_of_penalty_box = false
        puts "#{current_player} is not getting out of the penalty box"
      end
    end

    def move_and_ask(roll)
      current_player.move(roll)
      puts "#{current_player}'s new location is #{current_player.place}"
      puts "The category is #{current_category}"
      ask_question
    end

    def current_category = CATEGORIES[CATEGORY_PATTERN[current_player.place]]

    def ask_question
      puts @decks[current_category].draw
    end
  end
end
