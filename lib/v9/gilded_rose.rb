# Gilded Rose Kata
#
# This models an inventory management system for a fantasy shop.
# Items have a sell_in (days until sell-by date) and quality value.
#
# Quality rules:
# - Quality degrades by 1 each day for normal items
# - Quality degrades twice as fast after sell_in date passes
# - Quality is never negative
# - Quality never exceeds 50 (except for Sulfuras)
#
# Special items have unique behaviors (see ITEM_TYPES below)

module GildedRoseKata
  # Data structure for inventory items
  Item = Struct.new(:name, :sell_in, :quality)

  class GildedRose
    # Quality boundaries
    MINIMUM_QUALITY = 0
    MAXIMUM_QUALITY = 50

    # Special item names (used for behavior matching)
    ITEM_TYPES = {
      aged_brie: "Aged Brie",
      backstage_pass: "Backstage passes to a TAFKAL80ETC concert",
      sulfuras: "Sulfuras, Hand of Ragnaros"
    }.freeze

    def initialize(items)
      @items = items
    end

    # Update quality for all items at end of day
    def update_quality
      @items.each { |item| update_item(item) }
    end

    private

    def update_item(item)
      case item.name
      when ITEM_TYPES[:sulfuras]
        # Sulfuras is legendary - never changes
        update_sulfuras(item)
      when ITEM_TYPES[:aged_brie]
        # Aged Brie increases in quality over time
        update_aged_brie(item)
      when ITEM_TYPES[:backstage_pass]
        # Backstage passes increase then drop to 0 after concert
        update_backstage_pass(item)
      else
        # Normal items degrade over time
        update_normal_item(item)
      end
    end

    # ============================================
    # SULFURAS: Legendary item, never changes
    # ============================================
    def update_sulfuras(item)
      # Sulfuras never changes in quality or sell_in
      # It is a legendary item with fixed quality of 80
    end

    # ============================================
    # AGED BRIE: Increases in quality as it ages
    # ============================================
    def update_aged_brie(item)
      increase_quality(item, amount: 1)

      decrement_sell_in(item)

      # Quality increases twice as fast after sell-by date
      if item.sell_in < 0
        increase_quality(item, amount: 1)
      end
    end

    # ============================================
    # BACKSTAGE PASS: Value increases approaching concert, drops to 0 after
    # ============================================
    def update_backstage_pass(item)
      if item.sell_in > 10
        # More than 10 days out: normal increase
        increase_quality(item, amount: 1)
      elsif item.sell_in > 5
        # 6-10 days out: quality increases by 2
        increase_quality(item, amount: 2)
      elsif item.sell_in > 0
        # 1-5 days out: quality increases by 3
        increase_quality(item, amount: 3)
      else
        # Concert has passed: worthless
        item.quality = 0
      end

      decrement_sell_in(item)

      # After sell_in goes negative, quality drops to 0
      if item.sell_in < 0
        item.quality = 0
      end
    end

    # ============================================
    # NORMAL ITEM: Degrades over time
    # ============================================
    def update_normal_item(item)
      decrease_quality(item, amount: 1)

      decrement_sell_in(item)

      # Degrades twice as fast after sell-by date
      if item.sell_in < 0
        decrease_quality(item, amount: 1)
      end
    end

    # ============================================
    # HELPER METHODS
    # ============================================

    def decrement_sell_in(item)
      item.sell_in -= 1
    end

    def increase_quality(item, amount:)
      item.quality = [item.quality + amount, MAXIMUM_QUALITY].min
    end

    def decrease_quality(item, amount:)
      item.quality = [item.quality - amount, MINIMUM_QUALITY].max
    end
  end
end
