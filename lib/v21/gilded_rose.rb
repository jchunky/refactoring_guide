module GildedRoseKata
  # Protocol: every item updater must implement #update(sell_in, quality) => [new_sell_in, new_quality]
  module ItemUpdaterProtocol
    def update(sell_in, quality) = raise NotImplementedError
  end

  class NormalItemUpdater
    include ItemUpdaterProtocol
    def update(sell_in, quality)
      new_sell_in = sell_in - 1
      new_quality = quality - (new_sell_in < 0 ? 2 : 1)
      [new_sell_in, new_quality.clamp(0, 50)]
    end
  end

  class AgedBrieUpdater
    include ItemUpdaterProtocol
    def update(sell_in, quality)
      new_sell_in = sell_in - 1
      new_quality = quality + (new_sell_in < 0 ? 2 : 1)
      [new_sell_in, new_quality.clamp(0, 50)]
    end
  end

  class BackstagePassUpdater
    include ItemUpdaterProtocol
    def update(sell_in, quality)
      new_sell_in = sell_in - 1
      delta = case new_sell_in
              when (10..) then 1
              when (5..) then 2
              when (0..) then 3
              else -quality
              end
      [new_sell_in, (quality + delta).clamp(0, 50)]
    end
  end

  class SulfurasUpdater
    include ItemUpdaterProtocol
    def update(sell_in, quality) = [sell_in, quality]
  end

  UPDATER_REGISTRY = {
    "Aged Brie" => AgedBrieUpdater.new,
    "Backstage passes to a TAFKAL80ETC concert" => BackstagePassUpdater.new,
    "Sulfuras, Hand of Ragnaros" => SulfurasUpdater.new,
  }.freeze

  DEFAULT_UPDATER = NormalItemUpdater.new

  class Item < Struct.new(:name, :sell_in, :quality)
    def update
      updater = UPDATER_REGISTRY.fetch(name, DEFAULT_UPDATER)
      self.sell_in, self.quality = updater.update(sell_in, quality)
    end
  end

  class GildedRose < Struct.new(:items)
    def update_quality = items.each(&:update)
  end
end
