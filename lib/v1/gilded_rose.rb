module GildedRoseKata
  Item = Struct.new(:name, :sell_in, :quality)

  class GildedRose
    UPDATERS = {
      "Aged Brie" => :update_aged_brie,
      "Backstage passes to a TAFKAL80ETC concert" => :update_backstage_pass,
      "Sulfuras, Hand of Ragnaros" => :update_sulfuras,
    }.freeze

    def initialize(items)
      @items = items
    end

    def update_quality
      @items.each { |item| update_item(item) }
    end

    private

    def update_item(item)
      method = UPDATERS.fetch(item.name, :update_normal)
      send(method, item)
    end

    def update_normal(item)
      item.sell_in -= 1
      item.quality -= item.sell_in < 0 ? 2 : 1
      item.quality = [item.quality, 0].max
    end

    def update_aged_brie(item)
      item.sell_in -= 1
      item.quality += item.sell_in < 0 ? 2 : 1
      item.quality = [item.quality, 50].min
    end

    def update_backstage_pass(item)
      item.quality += if item.sell_in < 6
                        3
                      elsif item.sell_in < 11
                        2
                      else
                        1
                      end
      item.sell_in -= 1
      item.quality = if item.sell_in < 0
                       0
                     else
                       [item.quality, 50].min
                     end
    end

    def update_sulfuras(_item)
      # Sulfuras never changes
    end
  end
end
