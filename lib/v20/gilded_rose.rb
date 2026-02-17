module GildedRoseKata
  module UpdatePipeline
    def self.compute(name, sell_in, quality)
      { name:, sell_in:, quality: }
        .then { decrement_sell_in(it) }
        .then { adjust_quality(it) }
        .then { clamp_quality(it) }
        .then { [it[:sell_in], it[:quality]] }
    end

    def self.decrement_sell_in(data)
      return data if data[:name] == "Sulfuras, Hand of Ragnaros"
      data.merge(sell_in: data[:sell_in] - 1)
    end

    def self.adjust_quality(data)
      delta = case data[:name]
              when "Sulfuras, Hand of Ragnaros" then 0
              when "Aged Brie" then data[:sell_in] < 0 ? 2 : 1
              when "Backstage passes to a TAFKAL80ETC concert"
                case data[:sell_in]
                when (10..) then 1
                when (5..) then 2
                when (0..) then 3
                else -data[:quality]
                end
              else data[:sell_in] < 0 ? -2 : -1
              end
      data.merge(quality: data[:quality] + delta)
    end

    def self.clamp_quality(data)
      return data if data[:name] == "Sulfuras, Hand of Ragnaros"
      data.merge(quality: data[:quality].clamp(0, 50))
    end
  end

  class Item < Struct.new(:name, :sell_in, :quality)
    def update
      self.sell_in, self.quality = UpdatePipeline.compute(name, sell_in, quality)
    end
  end

  class GildedRose < Struct.new(:items)
    def update_quality = items.each(&:update)
  end
end
