Item = Struct.new(:name, :sell_in, :quality)

class GildedRose
  AGED_BRIE = "Aged Brie"
  BACKSTAGE = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"

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
      increase_quality(item)
      increase_quality(item) if item.sell_in <= 0
    when BACKSTAGE
      increase_quality(item)
      increase_quality(item) if item.sell_in < 11
      increase_quality(item) if item.sell_in < 6
      item.quality = 0 if item.sell_in <= 0
    else
      decrease_quality(item)
      decrease_quality(item) if item.sell_in <= 0
    end

    item.sell_in -= 1
  end

  def increase_quality(item)
    item.quality += 1 if item.quality < 50
  end

  def decrease_quality(item)
    item.quality -= 1 if item.quality > 0
  end
end
