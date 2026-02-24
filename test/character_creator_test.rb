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

class AbilityScoresWithBonusesTest < Minitest::Test
  def setup
    @scores = CharacterCreatorKata::AbilityScores.new(
      str: 15, dex: 14, con: 13, int: 12, wis: 10, cha: 8
    )
  end

  def test_with_bonuses_returns_new_scores
    new_scores = @scores.with_bonuses(int: 2, wis: 1)
    assert_equal 14, new_scores.int  # 12 + 2
    assert_equal 11, new_scores.wis  # 10 + 1
    assert_equal 15, new_scores.str  # unchanged
  end

  def test_with_bonuses_does_not_mutate_original
    @scores.with_bonuses(str: 2)
    assert_equal 15, @scores.str
  end

  def test_mod_for_returns_correct_modifier
    assert_equal 2,  @scores.mod_for(:str)  # 15 → +2
    assert_equal(-1, @scores.mod_for(:cha)) # 8 → -1
    assert_equal 0,  @scores.mod_for(:wis)  # 10 → 0
  end
end

class ClassSkillCountTest < Minitest::Test
  def test_barbarian_gets_2
    assert_equal 2, CharacterCreatorKata.class_skill_count("Barbarian")
  end

  def test_bard_gets_3
    assert_equal 3, CharacterCreatorKata.class_skill_count("Bard")
  end

  def test_ranger_gets_3
    assert_equal 3, CharacterCreatorKata.class_skill_count("Ranger")
  end

  def test_rogue_gets_4
    assert_equal 4, CharacterCreatorKata.class_skill_count("Rogue")
  end

  def test_unknown_class_defaults_to_2
    assert_equal 2, CharacterCreatorKata.class_skill_count("Artificer")
  end
end

class CalculateSkillsTest < Minitest::Test
  def setup
    @scores = CharacterCreatorKata::AbilityScores.new(
      str: 15, dex: 14, con: 13, int: 12, wis: 10, cha: 8
    )
    @prof_bonus = 2
  end

  def test_proficient_skill_gets_ability_mod_plus_prof_bonus
    skills = CharacterCreatorKata.calculate_skills(@scores, @prof_bonus, ["athletics"])
    # athletics → STR mod (+2) + prof bonus (+2) = 4
    assert_equal 4, skills["athletics"]
  end

  def test_non_proficient_skill_gets_only_ability_mod
    skills = CharacterCreatorKata.calculate_skills(@scores, @prof_bonus, [])
    # athletics → STR mod (+2), no prof bonus
    assert_equal 2, skills["athletics"]
  end

  def test_negative_modifier_skill
    skills = CharacterCreatorKata.calculate_skills(@scores, @prof_bonus, [])
    # deception → CHA mod (-1)
    assert_equal(-1, skills["deception"])
  end

  def test_proficient_negative_modifier_skill
    skills = CharacterCreatorKata.calculate_skills(@scores, @prof_bonus, ["deception"])
    # deception → CHA mod (-1) + prof bonus (+2) = 1
    assert_equal 1, skills["deception"]
  end

  def test_returns_all_18_skills
    skills = CharacterCreatorKata.calculate_skills(@scores, @prof_bonus, [])
    assert_equal 18, skills.size
  end

  def test_multiple_proficiencies
    proficient = ["athletics", "insight", "stealth"]
    skills = CharacterCreatorKata.calculate_skills(@scores, @prof_bonus, proficient)
    assert_equal 4, skills["athletics"]   # STR(+2) + prof(+2)
    assert_equal 2, skills["insight"]     # WIS(+0) + prof(+2)
    assert_equal 4, skills["stealth"]     # DEX(+2) + prof(+2)
    assert_equal 2, skills["acrobatics"]  # DEX(+2), not proficient
  end
end

class SkillAbilitiesMappingTest < Minitest::Test
  def test_all_skills_have_ability_mapping
    CharacterCreatorKata::ALL_SKILLS.each do |skill|
      assert CharacterCreatorKata::SKILL_ABILITIES.key?(skill),
             "#{skill} should have an ability mapping"
    end
  end

  def test_athletics_maps_to_str
    assert_equal :str, CharacterCreatorKata::SKILL_ABILITIES["athletics"]
  end

  def test_acrobatics_maps_to_dex
    assert_equal :dex, CharacterCreatorKata::SKILL_ABILITIES["acrobatics"]
  end

  def test_arcana_maps_to_int
    assert_equal :int, CharacterCreatorKata::SKILL_ABILITIES["arcana"]
  end

  def test_perception_maps_to_wis
    assert_equal :wis, CharacterCreatorKata::SKILL_ABILITIES["perception"]
  end

  def test_persuasion_maps_to_cha
    assert_equal :cha, CharacterCreatorKata::SKILL_ABILITIES["persuasion"]
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

    # Base scores [15,14,13,12,10,8] + Acolyte bonuses: INT +2, WIS +1
    assert_equal 15, character.ability_scores.str
    assert_equal 14, character.ability_scores.dex
    assert_equal 13, character.ability_scores.con
    assert_equal 14, character.ability_scores.int  # 12 + 2
    assert_equal 11, character.ability_scores.wis  # 10 + 1
    assert_equal 8,  character.ability_scores.cha

    assert_equal 12, character.ac   # 10 + DEX mod(+2)
    assert_equal 2,  character.proficiency_bonus
    assert_equal 21, character.hit_points
    assert_equal 18, character.skills.size
  end

  def test_main_applies_background_ability_bonuses
    character, _output = capture_stdout { main }

    # Acolyte default: +2 Intelligence, +1 Wisdom
    assert_equal 2, character.ability_scores.int_mod  # 14 → +2
    assert_equal 0, character.ability_scores.wis_mod  # 11 → +0
  end

  def test_main_calculates_skill_values
    character, _output = capture_stdout { main }

    # Proficient skills: insight, religion (Acolyte bg) + animal handling, athletics (Barbarian class picks)
    # Prof bonus = 2
    assert_equal 2, character.skills["insight"]         # WIS(+0) + prof(+2)
    assert_equal 4, character.skills["religion"]         # INT(+2) + prof(+2)
    assert_equal 2, character.skills["animal handling"]  # WIS(+0) + prof(+2)
    assert_equal 4, character.skills["athletics"]        # STR(+2) + prof(+2)

    # Non-proficient skills get only ability mod
    assert_equal 2, character.skills["acrobatics"]  # DEX(+2), not proficient
    assert_equal(-1, character.skills["deception"])  # CHA(-1), not proficient
  end

  def test_main_output_includes_key_elements
    _character, output = capture_stdout { main }

    assert_includes output, "D&D Character Creator"
    assert_includes output, "Choose your class:"
    assert_includes output, "Barbarian"
    assert_includes output, "Dragonborn"
    assert_includes output, "Adventurer"
    assert_includes output, "Skill Proficiencies"
    assert_includes output, "Level 1 Barbarian"
  end
end
