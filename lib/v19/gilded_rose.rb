module GildedRoseKata
  # Declarative update rules: name => update_lambda(sell_in, quality) => [new_sell_in, new_quality]
  ITEM_RULES = {
    "Sulfuras, Hand of Ragnaros" => ->(sell_in, quality) { [sell_in, quality] },

    "Aged Brie" => ->(sell_in, quality) {
      new_sell_in = sell_in - 1
      new_quality = quality + (new_sell_in < 0 ? 2 : 1)
      [new_sell_in, new_quality.clamp(0, 50)]
    },

    "Backstage passes to a TAFKAL80ETC concert" => ->(sell_in, quality) {
      new_sell_in = sell_in - 1
      delta = case new_sell_in
              when (10..) then 1
              when (5..) then 2
              when (0..) then 3
              else -quality
              end
      [new_sell_in, (quality + delta).clamp(0, 50)]
    },
  }.freeze

  DEFAULT_ITEM_RULE = ->(sell_in, quality) {
    new_sell_in = sell_in - 1
    new_quality = quality - (new_sell_in < 0 ? 2 : 1)
    [new_sell_in, new_quality.clamp(0, 50)]
  }

  class Item < Struct.new(:name, :sell_in, :quality)
    def update
      rule = ITEM_RULES.fetch(name, DEFAULT_ITEM_RULE)
      self.sell_in, self.quality = rule.call(sell_in, quality)
    end
  end

  class GildedRose < Struct.new(:items)
    def update_quality = items.each(&:update)
  end
end
