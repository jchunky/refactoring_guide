require 'minitest/autorun'
require 'minitest/reporters'
require 'stringio'
require_relative '../lib/version_loader'
VersionLoader.require_kata('character_creator')

Minitest::Reporters.use!

class AbilityScoresTest < Minitest::Test
  def setup
    @scores = CharacterCreatorKata::AbilityScores.new(
      str: 15, dex: 14, con: 13, int: 12, wis: 10, cha: 8
    )
  end

  def test_stores_ability_scores
    assert_equal 15, @scores.str
    assert_equal 14, @scores.dex
    assert_equal 13, @scores.con
    assert_equal 12, @scores.int
    assert_equal 10, @scores.wis
    assert_equal 8,  @scores.cha
  end

  def test_computes_positive_modifiers
    assert_equal 2, @scores.str_mod  # 15 → +2
    assert_equal 2, @scores.dex_mod  # 14 → +2
    assert_equal 1, @scores.con_mod  # 13 → +1
    assert_equal 1, @scores.int_mod  # 12 → +1
  end

  def test_computes_zero_modifier
    assert_equal 0, @scores.wis_mod  # 10 → 0
  end

  def test_computes_negative_modifier
    assert_equal(-1, @scores.cha_mod)  # 8 → -1
  end

  def test_modifier_edge_cases
    low = CharacterCreatorKata::AbilityScores.new(str: 1, dex: 3, con: 6, int: 9, wis: 10, cha: 11)
    assert_equal(-5, low.str_mod)  # 1 → -5
    assert_equal(-4, low.dex_mod)  # 3 → -4
    assert_equal(-2, low.con_mod)  # 6 → -2
    assert_equal(-1, low.int_mod)  # 9 → -1
    assert_equal 0,  low.wis_mod   # 10 → 0
    assert_equal 0,  low.cha_mod   # 11 → 0
  end

  def test_to_h_includes_scores_and_modifiers
    h = @scores.to_h
    assert_equal 15, h[:str]
    assert_equal 2,  h[:str_mod]
    assert_equal 8,  h[:cha]
    assert_equal(-1, h[:cha_mod])
  end
end

class AbilityModifierTest < Minitest::Test
  def test_standard_modifier_values
    expected = {
      1 => -5, 2 => -4, 3 => -4, 4 => -3, 5 => -3,
      6 => -2, 7 => -2, 8 => -1, 9 => -1, 10 => 0,
      11 => 0, 12 => 1, 13 => 1, 14 => 2, 15 => 2,
      16 => 3, 17 => 3, 18 => 4, 19 => 4, 20 => 5
    }
    expected.each do |score, mod|
      assert_equal mod, CharacterCreatorKata.ability_modifier(score),
                   "Expected modifier for score #{score} to be #{mod}"
    end
  end
end

class ProficiencyBonusTest < Minitest::Test
  def test_levels_1_through_4_have_bonus_2
    (1..4).each do |level|
      assert_equal 2, CharacterCreatorKata.proficiency_bonus(level)
    end
  end

  def test_levels_5_through_8_have_bonus_3
    (5..8).each do |level|
      assert_equal 3, CharacterCreatorKata.proficiency_bonus(level)
    end
  end

  def test_levels_9_through_12_have_bonus_4
    (9..12).each do |level|
      assert_equal 4, CharacterCreatorKata.proficiency_bonus(level)
    end
  end

  def test_levels_13_through_16_have_bonus_5
    (13..16).each do |level|
      assert_equal 5, CharacterCreatorKata.proficiency_bonus(level)
    end
  end

  def test_levels_17_through_20_have_bonus_6
    (17..20).each do |level|
      assert_equal 6, CharacterCreatorKata.proficiency_bonus(level)
    end
  end
end

class HitPointCalculationTest < Minitest::Test
  def test_barbarian_level_1_con_mod_1
    # d12: 12 + 1 + (1 * (7 + 1)) = 21
    assert_equal 21, CharacterCreatorKata.calculate_hit_points("Barbarian", 1, 1)
  end

  def test_fighter_level_1_con_mod_2
    # d10: 10 + 2 + (1 * (6 + 2)) = 20
    assert_equal 20, CharacterCreatorKata.calculate_hit_points("Fighter", 1, 2)
  end

  def test_wizard_level_1_con_mod_0
    # d6: 6 + 0 + (1 * (4 + 0)) = 10
    assert_equal 10, CharacterCreatorKata.calculate_hit_points("Wizard", 1, 0)
  end

  def test_rogue_level_5_con_mod_1
    # d8: 8 + 1 + (5 * (5 + 1)) = 39
    assert_equal 39, CharacterCreatorKata.calculate_hit_points("Rogue", 5, 1)
  end

  def test_barbarian_level_10_con_mod_3
    # d12: 12 + 3 + (10 * (7 + 3)) = 115
    assert_equal 115, CharacterCreatorKata.calculate_hit_points("Barbarian", 10, 3)
  end

  def test_all_class_tiers_have_hit_dice
    CharacterCreatorKata::CLASSES.each do |char_class|
      assert CharacterCreatorKata::HIT_DICE.key?(char_class),
             "#{char_class} should have a hit die entry"
    end
  end
end

class BackgroundBonusesTest < Minitest::Test
  def test_acolyte_bonuses
    bonuses = CharacterCreatorKata.background_bonuses("Acolyte")
    assert_equal %w[Intelligence Wisdom Charisma], bonuses[:ability_bonuses]
    assert_includes bonuses[:skill_proficiencies], "insight"
    assert_includes bonuses[:skill_proficiencies], "religion"
  end

  def test_criminal_bonuses
    bonuses = CharacterCreatorKata.background_bonuses("Criminal")
    assert_equal %w[Dexterity Constitution Intelligence], bonuses[:ability_bonuses]
    assert_includes bonuses[:skill_proficiencies], "sleight of hand"
    assert_includes bonuses[:skill_proficiencies], "stealth"
  end

  def test_sage_bonuses
    bonuses = CharacterCreatorKata.background_bonuses("Sage")
    assert_equal %w[Constitution Intelligence Wisdom], bonuses[:ability_bonuses]
    assert_includes bonuses[:skill_proficiencies], "arcana"
    assert_includes bonuses[:skill_proficiencies], "history"
  end

  def test_soldier_bonuses
    bonuses = CharacterCreatorKata.background_bonuses("Soldier")
    assert_equal %w[Strength Dexterity Constitution], bonuses[:ability_bonuses]
    assert_includes bonuses[:skill_proficiencies], "athletics"
    assert_includes bonuses[:skill_proficiencies], "intimidation"
  end

  def test_unknown_background_returns_empty
    bonuses = CharacterCreatorKata.background_bonuses("Unknown")
    assert_empty bonuses[:ability_bonuses]
    assert_empty bonuses[:skill_proficiencies]
  end
end

class ClassProficienciesTest < Minitest::Test
  def test_each_class_has_proficiency_list
    CharacterCreatorKata::CLASSES.each do |char_class|
      profs = CharacterCreatorKata.proficiency_by_class(char_class)
      refute_empty profs, "#{char_class} should have skill proficiencies"
    end
  end

  def test_barbarian_proficiencies
    profs = CharacterCreatorKata.proficiency_by_class("Barbarian")
    assert_includes profs, "athletics"
    assert_includes profs, "intimidation"
    assert_includes profs, "survival"
  end

  def test_unknown_class_returns_empty
    assert_empty CharacterCreatorKata.proficiency_by_class("Artificer")
  end
end

class SkillInitializationTest < Minitest::Test
  def test_returns_all_18_skills
    skills = CharacterCreatorKata.initialize_skills
    assert_equal 18, skills.size
  end

  def test_all_skills_start_at_zero
    skills = CharacterCreatorKata.initialize_skills
    skills.each do |skill, value|
      assert_equal 0, value, "#{skill} should start at 0"
    end
  end

  def test_includes_expected_skills
    skills = CharacterCreatorKata.initialize_skills
    %w[athletics acrobatics stealth arcana perception].each do |skill|
      assert skills.key?(skill), "Should include #{skill}"
    end
  end
end

class StatRollTest < Minitest::Test
  def test_returns_standard_array
    assert_equal [15, 14, 13, 12, 10, 8], CharacterCreatorKata.stat_roll
  end

  def test_returns_new_array_each_time
    a = CharacterCreatorKata.stat_roll
    b = CharacterCreatorKata.stat_roll
    refute_same a, b
  end
end

class CharacterTest < Minitest::Test
  def setup
    @ability_scores = CharacterCreatorKata::AbilityScores.new(
      str: 15, dex: 14, con: 13, int: 12, wis: 10, cha: 8
    )
    @character = CharacterCreatorKata::Character.new(
      name: "Adventurer", level: 1, species: "Dragonborn",
      char_class: "Barbarian", background: "Acolyte",
      ability_scores: @ability_scores, ac: 12,
      proficiency_bonus: 2, hit_points: 21,
      skills: CharacterCreatorKata.initialize_skills
    )
  end

  def test_character_attributes
    assert_equal "Adventurer", @character.name
    assert_equal 1, @character.level
    assert_equal "Dragonborn", @character.species
    assert_equal "Barbarian", @character.char_class
    assert_equal "Acolyte", @character.background
    assert_equal 12, @character.ac
    assert_equal 2, @character.proficiency_bonus
    assert_equal 21, @character.hit_points
  end

  def test_character_ability_scores
    assert_equal 15, @character.ability_scores.str
    assert_equal 2, @character.ability_scores.str_mod
    assert_equal 14, @character.ability_scores.dex
    assert_equal 8, @character.ability_scores.cha
    assert_equal(-1, @character.ability_scores.cha_mod)
  end

  def test_to_h_includes_all_fields
    h = @character.to_h
    assert_equal "Adventurer", h[:name]
    assert_equal 1, h[:level]
    assert_equal "Barbarian", h[:char_class]
    assert_equal 15, h[:str]
    assert_equal 2, h[:str_mod]
    assert_equal 12, h[:ac]
    assert_equal 21, h[:hit_points]
    assert_equal 18, h[:skills].size
  end
end

class CharacterCreationIntegrationTest < Minitest::Test
  include CharacterCreatorKata

  def capture_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    result = yield
    [result, $stdout.string]
  ensure
    $stdout = old_stdout
  end

  def test_main_returns_a_character
    character, _output = capture_stdout { main }

    assert_instance_of CharacterCreatorKata::Character, character
    assert_equal "Adventurer", character.name
    assert_equal 1, character.level
    assert_equal "Barbarian", character.char_class
    assert_equal "Dragonborn", character.species
    assert_equal "Acolyte", character.background
    assert_equal 15, character.ability_scores.str
    assert_equal 14, character.ability_scores.dex
    assert_equal 13, character.ability_scores.con
    assert_equal 12, character.ability_scores.int
    assert_equal 10, character.ability_scores.wis
    assert_equal 8, character.ability_scores.cha
    assert_equal 12, character.ac
    assert_equal 2, character.proficiency_bonus
    assert_equal 21, character.hit_points
    assert_equal 18, character.skills.size
  end

  def test_main_output_includes_key_elements
    _character, output = capture_stdout { main }

    assert_includes output, "Welcome to the D&D Character Creator!"
    assert_includes output, "Character Created!"
    assert_includes output, "Adventurer"
    assert_includes output, "Barbarian"
    assert_includes output, "Dragonborn"
  end
end
