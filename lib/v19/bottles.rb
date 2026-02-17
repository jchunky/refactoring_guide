module BottlesKata
  # Declarative rules for special bottle numbers
  BOTTLE_RULES = {
    0 => { quantity: "no more", containers: "bottles", action: "Go to the store and buy some more", successor: 99 },
    1 => { quantity: nil, containers: "bottle", action: "Take it down and pass it around", successor: nil },
  }.freeze

  # Default rule for any number not in BOTTLE_RULES
  DEFAULT_RULE = { quantity: nil, containers: "bottles", action: "Take one down and pass it around", successor: nil }.freeze

  module BottleNumberFn
    def self.rules_for(n) = BOTTLE_RULES.fetch(n, DEFAULT_RULE)

    def self.quantity(n) = rules_for(n)[:quantity] || n.to_s
    def self.containers(n) = rules_for(n)[:containers]
    def self.action(n) = rules_for(n)[:action]
    def self.successor(n) = rules_for(n)[:successor] || n - 1
    def self.to_s(n) = "#{quantity(n)} #{containers(n)}"
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

    def verse(n)
      current = BottleNumberFn.to_s(n)
      "#{current.capitalize} of beer on the wall, #{current} of beer.\n" \
        "#{BottleNumberFn.action(n)}, #{BottleNumberFn.to_s(BottleNumberFn.successor(n))} of beer on the wall.\n"
    end
  end
end
