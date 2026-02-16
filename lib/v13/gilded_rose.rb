module GildedRoseKata
  Item = Struct.new(:name, :sell_in, :quality)

  class GildedRose
    def initialize(items)
      @items = items
    end

    def update_quality
      @items.each { Updater.for(it).update }
    end
  end

  class Updater < Data.define(:item)
    def self.for(item)
      case item.name
      when "Aged Brie"                                     then AgedBrie
      when "Backstage passes to a TAFKAL80ETC concert"     then BackstagePass
      when "Sulfuras, Hand of Ragnaros"                    then Sulfuras
      else                                                      Normal
      end.new(item:)
    end

    def update
      adjust_quality
      age
      adjust_quality_after_expiry if item.sell_in < 0
      item.quality = item.quality.clamp(0, 50)
    end

    private

    def age = item.sell_in -= 1
    def adjust_quality = item.quality -= 1
    def adjust_quality_after_expiry = item.quality -= 1
  end

  class Updater::AgedBrie < Updater
    private

    def adjust_quality = item.quality += 1
    def adjust_quality_after_expiry = item.quality += 1
  end

  class Updater::BackstagePass < Updater
    private

    def adjust_quality
      item.quality += 1
      item.quality += 1 if item.sell_in < 11
      item.quality += 1 if item.sell_in < 6
    end

    def adjust_quality_after_expiry = item.quality = 0
  end

  class Updater::Sulfuras < Updater
    def update = nil
  end

  class Updater::Normal < Updater; end
end
