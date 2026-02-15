Item = Struct.new(:name, :sell_in, :quality) do
  def update
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
    else
      self.sell_in -= 1
      self.quality -= sell_in < 0 ? 2 : 1
      self.quality = quality.clamp(0, 50)
    end
  end
end

class GildedRose < Struct.new(:items)
  def update_quality = items.each(&:update)
end
