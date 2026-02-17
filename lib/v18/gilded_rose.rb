module GildedRoseKata
  # Events
  ItemUpdated = Data.define(:new_sell_in, :new_quality)

  module ItemRules
    def self.compute_update(name, sell_in, quality)
      case name
      when "Sulfuras, Hand of Ragnaros"
        ItemUpdated.new(new_sell_in: sell_in, new_quality: quality)
      when "Aged Brie"
        new_sell_in = sell_in - 1
        new_quality = quality + (new_sell_in < 0 ? 2 : 1)
        ItemUpdated.new(new_sell_in:, new_quality: new_quality.clamp(0, 50))
      when "Backstage passes to a TAFKAL80ETC concert"
        new_sell_in = sell_in - 1
        delta = case new_sell_in
                when (10..) then 1
                when (5..) then 2
                when (0..) then 3
                else -quality
                end
        ItemUpdated.new(new_sell_in:, new_quality: (quality + delta).clamp(0, 50))
      else
        new_sell_in = sell_in - 1
        new_quality = quality - (new_sell_in < 0 ? 2 : 1)
        ItemUpdated.new(new_sell_in:, new_quality: new_quality.clamp(0, 50))
      end
    end
  end

  class Item < Struct.new(:name, :sell_in, :quality)
    def update
      event = ItemRules.compute_update(name, sell_in, quality)
      self.sell_in = event.new_sell_in
      self.quality = event.new_quality
    end
  end

  class GildedRose < Struct.new(:items)
    def update_quality = items.each(&:update)
  end
end
