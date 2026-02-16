module GildedRoseKata
  Item = Struct.new(:name, :sell_in, :quality)

  class GildedRose
    AGED_BRIE = "Aged Brie"
    BACKSTAGE = "Backstage passes to a TAFKAL80ETC concert"
    SULFURAS = "Sulfuras, Hand of Ragnaros"

    def initialize(items) = @items = items

    def update_quality = @items.each { update_item(it) }

    private

    def update_item(item)
      updater = ItemUpdater.for(item)
      updater.update
    end
  end

  # Base updater with default behavior
  class ItemUpdater < Struct.new(:item)
    MAX_QUALITY = 50
    MIN_QUALITY = 0

    def self.for(item)
      case item.name
      when GildedRose::AGED_BRIE then AgedBrieUpdater
      when GildedRose::BACKSTAGE then BackstageUpdater
      when GildedRose::SULFURAS then SulfurasUpdater
      else ItemUpdater
      end.new(item)
    end

    def update
      decrease_quality
      age_item
      decrease_quality if expired?
    end

    private

    def age_item = item.sell_in -= 1
    def expired? = item.sell_in < 0
    def decrease_quality = item.quality = [item.quality - 1, MIN_QUALITY].max
    def increase_quality(amount = 1) = item.quality = [item.quality + amount, MAX_QUALITY].min
  end

  class AgedBrieUpdater < ItemUpdater
    def update
      increase_quality
      age_item
      increase_quality if expired?
    end
  end

  class BackstageUpdater < ItemUpdater
    def update
      increase_quality(quality_bonus)
      age_item
      item.quality = 0 if expired?
    end

    private

    def quality_bonus
      case item.sell_in
      when (..5) then 3
      when (..10) then 2
      else 1
      end
    end
  end

  class SulfurasUpdater < ItemUpdater
    def update = nil # Sulfuras never changes
  end
end
