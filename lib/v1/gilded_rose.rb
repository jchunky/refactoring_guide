# frozen_string_literal: true

module GildedRoseKata
  Item = Struct.new(:name, :sell_in, :quality)

  class GildedRose
    AGED_BRIE = "Aged Brie"
    SULFURAS = "Sulfuras, Hand of Ragnaros"
    BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"

    def initialize(items)
      @items = items
    end

    def update_quality
      @items.each { |item| update_item(item) }
    end

    private

    def update_item(item)
      return if item.name == SULFURAS

      case item.name
      when AGED_BRIE
        update_aged_brie(item)
      when BACKSTAGE_PASSES
        update_backstage_passes(item)
      else
        update_normal(item)
      end

      item.sell_in -= 1
    end

    def update_aged_brie(item)
      increment_quality(item)
      increment_quality(item) if item.sell_in <= 0
    end

    def update_backstage_passes(item)
      if item.sell_in <= 0
        item.quality = 0
      else
        increment_quality(item)
        increment_quality(item) if item.sell_in < 11
        increment_quality(item) if item.sell_in < 6
      end
    end

    def update_normal(item)
      decrement_quality(item)
      decrement_quality(item) if item.sell_in <= 0
    end

    def increment_quality(item)
      item.quality += 1 if item.quality < 50
    end

    def decrement_quality(item)
      item.quality -= 1 if item.quality > 0
    end
  end
end
