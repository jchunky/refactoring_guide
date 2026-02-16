Item = Struct.new(:name, :sell_in, :quality)

class GildedRose
  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each { |item| update_item(item) }
  end

  private

  def update_item(item)
    return if legendary?(item)

    update_quality_before_sell_date(item)
    decrement_sell_in(item)
    update_quality_after_sell_date(item) if expired?(item)
  end

  def update_quality_before_sell_date(item)
    case item.name
    when AGED_BRIE
      increase_quality(item)
    when BACKSTAGE_PASS
      increase_quality(item)
      increase_quality(item) if item.sell_in < 11
      increase_quality(item) if item.sell_in < 6
    else
      decrease_quality(item)
    end
  end

  def update_quality_after_sell_date(item)
    case item.name
    when AGED_BRIE
      increase_quality(item)
    when BACKSTAGE_PASS
      item.quality = MIN_QUALITY
    else
      decrease_quality(item)
    end
  end

  def increase_quality(item)
    item.quality += 1 if item.quality < MAX_QUALITY
  end

  def decrease_quality(item)
    item.quality -= 1 if item.quality > MIN_QUALITY
  end

  def decrement_sell_in(item)
    item.sell_in -= 1
  end

  def legendary?(item)
    item.name == SULFURAS
  end

  def expired?(item)
    item.sell_in < 0
  end
end
