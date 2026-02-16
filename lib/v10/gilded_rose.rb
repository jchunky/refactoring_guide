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
      when "Sulfuras, Hand of Ragnaros"
        # Sulfuras never changes
      when "Aged Brie"
        update_aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert"
        update_backstage_pass(item)
      else
        update_normal_item(item)
      end
    end

    def update_aged_brie(item)
      item.sell_in -= 1
      increase = item.sell_in < 0 ? 2 : 1
      item.quality = [item.quality + increase, 50].min
    end

    def update_backstage_pass(item)
      item.quality += 1
      item.quality += 1 if item.sell_in < 11
      item.quality += 1 if item.sell_in < 6
      item.sell_in -= 1
      item.quality = item.sell_in < 0 ? 0 : [item.quality, 50].min
    end

    def update_normal_item(item)
      item.sell_in -= 1
      degradation = item.sell_in < 0 ? 2 : 1
      item.quality = [item.quality - degradation, 0].max
    end
  end
end
