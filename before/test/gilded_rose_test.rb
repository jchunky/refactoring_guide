require_relative '../lib/gilded_rose'
require 'test/unit'

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
