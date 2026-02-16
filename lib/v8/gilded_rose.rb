module GildedRoseKata
  # Refactored to fix Feature Envy: Item now handles its own quality updates
  # Each item type knows how to update itself - ask objects to do things, don't reach into them

  # Keep original Item Struct for compatibility with tests
  Item = Struct.new(:name, :sell_in, :quality)

  # Base class for updatable items - encapsulates update behavior
  class UpdatableItem
    attr_accessor :name, :sell_in, :quality

    def initialize(item)
      @name = item.name
      @sell_in = item.sell_in
      @quality = item.quality
      @original_item = item
    end

    def update
      decrease_quality
      decrease_sell_in
      decrease_quality if expired?
      sync_to_original
    end

    def expired?
      sell_in < 0
    end

    protected

    def decrease_sell_in
      @sell_in -= 1
    end

    def decrease_quality
      @quality -= 1 if @quality > 0
    end

    def increase_quality
      @quality += 1 if @quality < 50
    end

    def sync_to_original
      @original_item.sell_in = @sell_in
      @original_item.quality = @quality
    end
  end

  class AgedBrie < UpdatableItem
    def update
      increase_quality
      decrease_sell_in
      increase_quality if expired?
      sync_to_original
    end
  end

  class Sulfuras < UpdatableItem
    def update
      # Sulfuras never changes
    end
  end

  class BackstagePass < UpdatableItem
    def update
      increase_quality
      increase_quality if sell_in < 11
      increase_quality if sell_in < 6
      decrease_sell_in
      @quality = 0 if expired?
      sync_to_original
    end
  end

  class GildedRose
    SPECIAL_ITEMS = {
      'Aged Brie' => AgedBrie,
      'Sulfuras, Hand of Ragnaros' => Sulfuras,
      'Backstage passes to a TAFKAL80ETC concert' => BackstagePass
    }.freeze

    def initialize(items)
      @items = items
      @updatable_items = items.map { |item| wrap_item(item) }
    end

    def update_quality
      @updatable_items.each(&:update)
    end

    private

    def wrap_item(item)
      klass = SPECIAL_ITEMS[item.name] || UpdatableItem
      klass.new(item)
    end
  end
end
