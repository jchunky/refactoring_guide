# Refactored using 99 Bottles of OOP principles:
# - Replace conditionals with polymorphism
# - Extract class for each item type concept
# - Open/Closed principle via factory method
# - Each item type knows how to age itself

Item = Struct.new(:name, :sell_in, :quality)

class ItemUpdater
  def self.for(item)
    case item.name
    when "Aged Brie"
      AgedBrieUpdater
    when "Backstage passes to a TAFKAL80ETC concert"
      BackstagePassUpdater
    when "Sulfuras, Hand of Ragnaros"
      SulfurasUpdater
    else
      NormalItemUpdater
    end.new(item)
  end

  def initialize(item)
    @item = item
  end

  def update
    update_quality
    update_sell_in
    update_quality_after_sell_date if expired?
  end

  private

  attr_reader :item

  def update_sell_in
    item.sell_in -= 1
  end

  def expired?
    item.sell_in < 0
  end

  def decrease_quality(amount = 1)
    item.quality = [item.quality - amount, 0].max
  end

  def increase_quality(amount = 1)
    item.quality = [item.quality + amount, 50].min
  end
end

class NormalItemUpdater < ItemUpdater
  def update_quality
    decrease_quality
  end

  def update_quality_after_sell_date
    decrease_quality
  end
end

class AgedBrieUpdater < ItemUpdater
  def update_quality
    increase_quality
  end

  def update_quality_after_sell_date
    increase_quality
  end
end

class BackstagePassUpdater < ItemUpdater
  def update_quality
    increase_quality
    increase_quality if item.sell_in < 11
    increase_quality if item.sell_in < 6
  end

  def update_quality_after_sell_date
    item.quality = 0
  end
end

class SulfurasUpdater < ItemUpdater
  def update
    # Sulfuras never changes
  end

  def update_quality; end
  def update_sell_in; end
  def update_quality_after_sell_date; end
end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      ItemUpdater.for(item).update
    end
  end
end
