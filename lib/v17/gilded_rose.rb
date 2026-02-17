module GildedRoseKata
  class Item < Struct.new(:name, :sell_in, :quality)
    def receive(message)
      case message
      in :update then update_self
      in :to_s then to_s
      end
    end

    private

    def update_self
      case name
      when "Aged Brie"
        self.sell_in -= 1
        self.quality += sell_in < 0 ? 2 : 1
        self.quality = quality.clamp(0, 50)
      when "Backstage passes to a TAFKAL80ETC concert"
        self.sell_in -= 1
        self.quality += case sell_in
                        when (10..) then 1
                        when (5..) then 2
                        when (0..) then 3
                        else -quality
                        end
        self.quality = quality.clamp(0, 50)
      when "Sulfuras, Hand of Ragnaros"
        # legendary item — no changes
      else
        self.sell_in -= 1
        self.quality -= sell_in < 0 ? 2 : 1
        self.quality = quality.clamp(0, 50)
      end
    end
  end

  class GildedRose < Struct.new(:items)
    def update_quality
      items.each { it.receive(:update) }
    end
  end
end
