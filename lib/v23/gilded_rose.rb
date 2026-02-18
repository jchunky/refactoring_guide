module GildedRoseKata
  Item = Struct.new(:name, :sell_in, :quality)

  class GildedRose

    AGED_BRIE = "Aged Brie"
    BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
    SULFURAS = "Sulfuras, Hand of Ragnaros"

    def initialize(items)
      @items = items
    end

    def update_quality
      @items.each do |item|
        update_item_quality(item)
        update_sell_in(item)
        update_expired_item(item) if item.sell_in < 0
      end
    end

    private

    def update_item_quality(item)
      if normal_item?(item)
        decrease_quality(item)
        return
      end

      increase_quality(item)
      return unless backstage_pass?(item)

      increase_quality(item) if item.sell_in < 11
      increase_quality(item) if item.sell_in < 6
    end

    def update_sell_in(item)
      return if legendary?(item)

      item.sell_in -= 1
    end

    def update_expired_item(item)
      if normal_item?(item)
        decrease_quality(item)
      elsif backstage_pass?(item)
        item.quality = 0
      else
        increase_quality(item)
      end
    end

    def increase_quality(item)
      return if item.quality >= 50

      item.quality += 1
    end

    def decrease_quality(item)
      return if item.quality <= 0
      return if legendary?(item)

      item.quality -= 1
    end

    def normal_item?(item)
      !(brie?(item) || backstage_pass?(item))
    end

    def brie?(item)
      item.name == AGED_BRIE
    end

    def backstage_pass?(item)
      item.name == BACKSTAGE_PASS
    end

    def legendary?(item)
      item.name == SULFURAS
    end
  end
end
