module GildedRoseKata
  module ItemUpdateFn
    def self.compute(name, sell_in, quality)
      case name
      in "Sulfuras, Hand of Ragnaros"
        [sell_in, quality]
      in "Aged Brie"
        new_sell_in = sell_in - 1
        new_quality = quality + (new_sell_in < 0 ? 2 : 1)
        [new_sell_in, new_quality.clamp(0, 50)]
      in "Backstage passes to a TAFKAL80ETC concert"
        new_sell_in = sell_in - 1
        delta = case new_sell_in
                in (10..) then 1
                in (5..9) then 2
                in (0..4) then 3
                in (..-1) then -quality
                end
        [new_sell_in, (quality + delta).clamp(0, 50)]
      in String
        new_sell_in = sell_in - 1
        new_quality = quality - (new_sell_in < 0 ? 2 : 1)
        [new_sell_in, new_quality.clamp(0, 50)]
      end
    end
  end

  class Item < Struct.new(:name, :sell_in, :quality)
    def update
      new_sell_in, new_quality = ItemUpdateFn.compute(name, sell_in, quality)
      self.sell_in = new_sell_in
      self.quality = new_quality
    end
  end

  class GildedRose < Struct.new(:items)
    def update_quality = items.each(&:update)
  end
end
