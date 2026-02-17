module BottlesKata
  class BottleNumber
    attr_reader :n

    def initialize(n) = @n = n

    def receive(message)
      case message
      in :to_s then "#{quantity} #{containers}"
      in :action then action
      in :successor then self.class.new(successor_n)
      end
    end

    private

    def quantity = n == 0 ? "no more" : n.to_s
    def containers = n == 1 ? "bottle" : "bottles"

    def action
      case n
      when 0 then "Go to the store and buy some more"
      when 1 then "Take it down and pass it around"
      else "Take one down and pass it around"
      end
    end

    def successor_n = n == 0 ? 99 : n - 1
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

    def verse(number)
      bn = BottleNumber.new(number)
      current = bn.receive(:to_s)
      successor = bn.receive(:successor)
      "#{current.capitalize} of beer on the wall, #{current} of beer.\n" \
        "#{bn.receive(:action)}, #{successor.receive(:to_s)} of beer on the wall.\n"
    end
  end
end
