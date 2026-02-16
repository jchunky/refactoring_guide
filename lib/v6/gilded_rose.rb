module GildedRoseKata
  Item = Struct.new(:name, :sell_in, :quality)

  # Polymorphic item classes - no nested conditionals, no else
  class ItemUpdater
    def self.for(item)
      ITEM_TYPES.fetch(item.name, NormalItemUpdater).new(item)
    end

    attr_reader :item

    def initialize(item)
      @item = item
    end

    def update
      update_quality
      update_sell_in
      update_quality_after_sell_date
    end

    def update_quality
      decrease_quality
    end

    def update_sell_in
      item.sell_in -= 1
    end

    def update_quality_after_sell_date
      return unless expired?
      decrease_quality
    end

    def expired? = item.sell_in < 0
    def decrease_quality = item.quality = [item.quality - 1, 0].max
    def increase_quality = item.quality = [item.quality + 1, 50].min
  end

  class NormalItemUpdater < ItemUpdater
  end

  class AgedBrieUpdater < ItemUpdater
    def update_quality = increase_quality
    def update_quality_after_sell_date
      return unless expired?
      increase_quality
    end
  end

  class BackstagePassUpdater < ItemUpdater
    def update_quality
      increase_quality
      increase_quality if item.sell_in < 11
      increase_quality if item.sell_in < 6
    end

    def update_quality_after_sell_date
      return unless expired?
      item.quality = 0
    end
  end

  class SulfurasUpdater < ItemUpdater
    def update_quality = nil
    def update_sell_in = nil
    def update_quality_after_sell_date = nil
  end

  ITEM_TYPES = {
    "Aged Brie" => AgedBrieUpdater,
    "Backstage passes to a TAFKAL80ETC concert" => BackstagePassUpdater,
    "Sulfuras, Hand of Ragnaros" => SulfurasUpdater
  }.freeze

  class GildedRose
    def initialize(items)
      @items = items
    end

    def update_quality
      @items.each { |item| ItemUpdater.for(item).update }
    end
  end
end
