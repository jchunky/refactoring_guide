# frozen_string_literal: true

module GildedRoseKata
  Item = Struct.new(:name, :sell_in, :quality)

  class GildedRose
    def initialize(items)
      @items = items
    end

    def update_quality
      @items.each { |item| update_item(item) }
    end

    private

    def update_item(item)
      case item.name
      when "Sulfuras, Hand of Ragnaros" then nil # legendary: never changes
      when "Aged Brie" then update_aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert" then update_backstage_pass(item)
      else update_normal(item)
      end
    end

    def update_aged_brie(item)
      item.quality += 1 if item.quality < 50
      item.sell_in -= 1
      item.quality += 1 if item.sell_in < 0 && item.quality < 50
    end

    def update_backstage_pass(item)
      if item.quality < 50
        item.quality += 1
        item.quality += 1 if item.sell_in < 11 && item.quality < 50
        item.quality += 1 if item.sell_in < 6 && item.quality < 50
      end
      item.sell_in -= 1
      item.quality = 0 if item.sell_in < 0
    end

    def update_normal(item)
      item.quality -= 1 if item.quality > 0
      item.sell_in -= 1
      item.quality -= 1 if item.sell_in < 0 && item.quality > 0
    end
  end
end
