require 'minitest/autorun'
require 'minitest/reporters'
require 'stringio'
require_relative '../lib/version_loader'
VersionLoader.require_kata('character_creator')
include CharacterCreatorKata

Minitest::Reporters.use!

class CharacterCreatorTest < Minitest::Test
  def run_character_creation
    main
  end

  def capture_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end

  def test_character_creation_output_matches_expectation
    output = capture_stdout { run_character_creation }

    expected_output = <<~OUTPUT
      Welcome to the D&D Character Creator!
      ========================================
      Barbarian
      Bard
      Cleric
      Druid
      Fighter
      Monk
      Paladin
      Ranger
      Rogue
      Sorcerer
      Warlock
      Wizard
      What class is your character?
      Barbarian
      Dragonborn
      Dwarf
      Elf
      Gnome
      Goliath
      Halfling
      Human
      Orc
      Tiefling
      What species is your character?
      Dragonborn
      Acolyte
      Criminal
      Sage
      Soldier
      What species is your character?
      Acolyte
      You rolled: [15, 14, 13, 12, 10, 8]
      These are your stats:
      15
      14
      13
      12
      10
      8
      Which number would you like to be your Strength stat?
      15
      These are your remaining stats:
      14
      13
      12
      10
      8
      Which number would you like to be your Dexterity stat?
      14
      These are your remaining stats:
      13
      12
      10
      8
      Which number would you like to be your Constitution stat?
      13
      These are your remaining stats:
      12
      10
      8
      Which number would you like to be your Intelligence stat?
      12
      These are your remaining stats:
      10
      8
      Which number would you like to be your Wisdom stat?
      10
      So your stats are  Strength: 15, Dexteriy: 14, Constitution: 13,
          Intelligence: 12, Wisdom: 10, and Charisma: 8
      Are you satisfied with this? (y/n)
      y
      
      What is your character's name?
      Adventurer
      
      ========================================
      Character Created!
      ========================================
      {"@charname": "Adventurer"}
      {"@level": 1}
      {"@species": "Dragonborn"}
      {"@class_of_char": "Barbarian"}
      {"@background": "Acolyte"}
      {"@str": 15}
      {"@strmod": 2}
      {"@dex": 14}
      {"@dexmod": 2}
      {"@con": 13}
      {"@conmod": 1}
      {"@int": 12}
      {"@intmod": 1}
      {"@wis": 10}
      {"@wismod": 0}
      {"@cha": 8}
      {"@chamod": -1}
      {"@ac": 12}
      {"@prof": 2}
      {"@hitpoints": 21}
      {"@skills": {"athletics" => 0, "acrobatics" => 0, "sleight of hand" => 0, "stealth" => 0, "arcana" => 0, "history" => 0, "investigation" => 0, "nature" => 0, "religion" => 0, "animal handling" => 0, "insight" => 0, "medicine" => 0, "perception" => 0, "survival" => 0, "deception" => 0, "intimidation" => 0, "performance" => 0, "persuasion" => 0}}
    OUTPUT

    assert_equal normalize(expected_output), normalize(output)
  end

  def normalize(s)
    s.lines.map(&:rstrip).join("\n") + "\n"
  end
end
