# Bottles of Beer Kata
#
# Generates the lyrics to "99 Bottles of Beer on the Wall"
# This classic song counts down from 99 bottles to 0,
# with special phrasing for the last few verses.
#
# Verse structure:
# - Normal verse (3+): "N bottles of beer on the wall, N bottles of beer.
#                       Take one down and pass it around, N-1 bottles of beer on the wall."
# - Two bottles: Uses "1 bottle" (singular) in the last line
# - One bottle: Uses "it" instead of "one", ends with "no more bottles"
# - Zero bottles: "No more bottles... Go to the store and buy some more, 99 bottles..."

module BottlesKata
  class Bottles
    # Starting number of bottles for the full song
    STARTING_BOTTLE_COUNT = 99

    # Generate a single verse of the song
    #
    # @param bottle_count [Integer] The number of bottles for this verse (0-99)
    # @return [String] The verse text
    def verse(bottle_count)
      case bottle_count
      when 0
        verse_for_zero_bottles
      when 1
        verse_for_one_bottle
      when 2
        verse_for_two_bottles
      else
        verse_for_multiple_bottles(bottle_count)
      end
    end

    # Generate multiple consecutive verses
    #
    # @param start_count [Integer] The bottle count to start from (higher number)
    # @param end_count [Integer] The bottle count to end at (lower number)
    # @return [String] All verses joined with blank lines
    def verses(start_count, end_count)
      verse_list = start_count.downto(end_count).map { |count| verse(count) }
      verse_list.join("\n")
    end

    # Generate the complete song (99 bottles down to 0)
    #
    # @return [String] The entire song
    def song
      verses(STARTING_BOTTLE_COUNT, 0)
    end

    private

    # Verse when there are no bottles left
    def verse_for_zero_bottles
      "No more bottles of beer on the wall, " \
      "no more bottles of beer.\n" \
      "Go to the store and buy some more, " \
      "#{STARTING_BOTTLE_COUNT} bottles of beer on the wall.\n"
    end

    # Verse for the last bottle (singular "bottle", pronoun "it")
    def verse_for_one_bottle
      "1 bottle of beer on the wall, " \
      "1 bottle of beer.\n" \
      "Take it down and pass it around, " \
      "no more bottles of beer on the wall.\n"
    end

    # Verse for two bottles (next verse uses singular "bottle")
    def verse_for_two_bottles
      "2 bottles of beer on the wall, " \
      "2 bottles of beer.\n" \
      "Take one down and pass it around, " \
      "1 bottle of beer on the wall.\n"
    end

    # Standard verse for 3 or more bottles
    def verse_for_multiple_bottles(bottle_count)
      remaining_bottles = bottle_count - 1

      "#{bottle_count} bottles of beer on the wall, " \
      "#{bottle_count} bottles of beer.\n" \
      "Take one down and pass it around, " \
      "#{remaining_bottles} bottles of beer on the wall.\n"
    end
  end
end
