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

      1. Barbarian
      2. Bard
      3. Cleric
      4. Druid
      5. Fighter
      6. Monk
      7. Paladin
      8. Ranger
      9. Rogue
      10. Sorcerer
      11. Warlock
      12. Wizard
      Pick class: 1
      Selected: Barbarian

      1. Dragonborn
      2. Dwarf
      3. Elf
      4. Gnome
      5. Goliath
      6. Halfling
      7. Human
      8. Orc
      9. Tiefling
      Pick species: 1
      Selected: Dragonborn

      1. Acolyte
      2. Criminal
      3. Sage
      4. Soldier
      Pick background: 1
      Selected: Acolyte
      Background Skills: Insight, Religion

      Pick level (1-20): 1

      Pick name: Adventurer

      You rolled: 15, 14, 13, 12, 10, 8

      Remaining stats: 15, 14, 13, 12, 10, 8
      Pick STR: 15

      Remaining stats: 14, 13, 12, 10, 8
      Pick DEX: 14

      Remaining stats: 13, 12, 10, 8
      Pick CON: 13

      Remaining stats: 12, 10, 8
      Pick INT: 12

      Remaining stats: 10, 8
      Pick WIS: 10

      CHA (auto): 8

      1. Animal Handling
      2. Athletics
      3. Intimidation
      4. Nature
      5. Perception
      6. Survival
      Pick skill (1/2): 1
      Selected: Animal Handling

      1. Athletics
      2. Intimidation
      3. Nature
      4. Perception
      5. Survival
      Pick skill (2/2): 1
      Selected: Athletics

      ========================================
      Character Created!
      ========================================
                      Name: Adventurer
                     Level: 1
                   Species: Dragonborn
                     Class: Barbarian
                Background: Acolyte

                        HP: 13
                        AC: 12
         Proficiency Bonus: +2

                    Skills: Animal Handling, Athletics, Insight, Religion

                       STR: 15 (+2)
                       DEX: 14 (+2)
                       CON: 13 (+1)
                       INT: 13 (+1)
                       WIS: 11 (+0)
                       CHA:  9 (-1)
    OUTPUT

    assert_equal normalize(expected_output), normalize(output)
  end

  def normalize(s)
    s.lines.map(&:rstrip).join("\n") + "\n"
  end
end
