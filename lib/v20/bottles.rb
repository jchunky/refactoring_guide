module BottlesKata
  module BottleFn
    def self.bottle_data(n)
      { n:,
        quantity: n == 0 ? "no more" : n.to_s,
        containers: n == 1 ? "bottle" : "bottles",
        action: case n
                when 0 then "Go to the store and buy some more"
                when 1 then "Take it down and pass it around"
                else "Take one down and pass it around"
                end,
        successor: n == 0 ? 99 : n - 1 }
    end

    def self.label(data) = "#{data[:quantity]} #{data[:containers]}"

    def self.format_verse(n)
      n.then { bottle_data(it) }
       .then { |current|
        successor = bottle_data(current[:successor])
        "#{label(current).capitalize} of beer on the wall, #{label(current)} of beer.\n" \
          "#{current[:action]}, #{label(successor)} of beer on the wall.\n"
      }
    end
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { BottleFn.format_verse(it) }.join("\n")
    def verse(number) = BottleFn.format_verse(number)
  end
end
