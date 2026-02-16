require_relative '../lib/version_loader'
VersionLoader.require_kata('gilded_rose')
include GildedRoseKata
require 'test/unit'

# Reference implementation used to verify behavior
class GildedRoseOld
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end
end

class TestGildedRose < Test::Unit::TestCase
  def test_behaves_exactly_like_old_implementation
    items = build_items
    items_old = build_items
    gilded_rose1 = GildedRose.new(items)
    gilded_rose2 = GildedRoseOld.new(items_old)

    50.times do
      gilded_rose1.update_quality
      gilded_rose2.update_quality

      items.size.times do |i|
        assert_equal items_old[i].to_s, items[i].to_s
      end
    end
  end

  def build_items
    [
      Item.new(name: "+5 Dexterity Vest", sell_in: 10, quality: 20),
      Item.new(name: "Aged Brie", sell_in: 2, quality: 0),
      Item.new(name: "Elixir of the Mongoose", sell_in: 5, quality: 7),
      Item.new(name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80),
      Item.new(name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 80),
      Item.new(name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 20),
      Item.new(name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 49),
      Item.new(name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 49),
      # This Conjured item does not work properly yet
      Item.new(name: "Conjured Mana Cake", sell_in: 3, quality: 6), # <-- :O
    ]
  end
end
