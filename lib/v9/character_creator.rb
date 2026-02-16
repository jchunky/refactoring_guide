# Character Creator Kata - D&D Character Builder
#
# Creates characters for Dungeons & Dragons 5th Edition.
# Handles character attributes, class selection, race bonuses, and skill proficiencies.
#
# Character creation flow:
# 1. Choose class (determines hit dice and skill options)
# 2. Choose race (determines ability score bonuses)
# 3. Choose background (determines additional proficiencies)
# 4. Roll and assign ability scores
# 5. Calculate derived stats (modifiers, hit points, armor class)

module CharacterCreatorKata
  require "active_support/all"

  # ============================================
  # CONFIGURATION CONSTANTS
  # ============================================

  # Ability score modifier formula: (score - 10) / 2, rounded down
  # This lookup table provides quick access to modifiers by score
  ABILITY_SCORE_MODIFIERS = {
    1 => -5, 2 => -4, 3 => -4, 4 => -3, 5 => -3,
    6 => -2, 7 => -2, 8 => -1, 9 => -1, 10 => 0,
    11 => 0, 12 => 1, 13 => 1, 14 => 2, 15 => 2,
    16 => 3, 17 => 3, 18 => 4, 19 => 4, 20 => 5,
    21 => 5, 22 => 6, 23 => 6, 24 => 7, 25 => 7,
    26 => 8, 27 => 8, 28 => 9, 29 => 9, 30 => 10
  }.freeze

  # Proficiency bonus by character level
  PROFICIENCY_BONUS_BY_LEVEL = {
    (1..4) => 2,
    (5..8) => 3,
    (9..12) => 4,
    (13..16) => 5,
    (17..20) => 6
  }.freeze

  # Hit dice by class (d12, d10, d8, d6)
  HIT_DICE_BY_CLASS = {
    "Barbarian" => { hit_die: 12, average_roll: 7 },
    "Fighter" => { hit_die: 10, average_roll: 6 },
    "Paladin" => { hit_die: 10, average_roll: 6 },
    "Ranger" => { hit_die: 10, average_roll: 6 },
    "Bard" => { hit_die: 8, average_roll: 5 },
    "Cleric" => { hit_die: 8, average_roll: 5 },
    "Druid" => { hit_die: 8, average_roll: 5 },
    "Monk" => { hit_die: 8, average_roll: 5 },
    "Rogue" => { hit_die: 8, average_roll: 5 },
    "Warlock" => { hit_die: 8, average_roll: 5 },
    "Sorcerer" => { hit_die: 6, average_roll: 4 },
    "Wizard" => { hit_die: 6, average_roll: 4 }
  }.freeze

  # Available character classes
  CHARACTER_CLASSES = HIT_DICE_BY_CLASS.keys.freeze

  # Available player races
  PLAYABLE_RACES = [
    "Hill Dwarf", "Mountain Dwarf",
    "High Elf", "Wood Elf",
    "Lightfoot Halfling", "Stout Halfling",
    "Human", "Human Variant",
    "Dragonborn",
    "Rock Gnome", "Forest Gnome",
    "Half Elf", "Half Orc",
    "Tiefling"
  ].freeze

  # Available character backgrounds
  CHARACTER_BACKGROUNDS = [
    "Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero",
    "Gladiator", "Guild Artisan", "Guild Merchant", "Hermit", "Knight",
    "Noble", "Outlander", "Pirate", "Sage", "Sailor", "Soldier", "Spy", "Urchin"
  ].freeze

  # All available skill proficiencies
  SKILLS = {
    strength: ["Athletics"],
    dexterity: ["Acrobatics", "Sleight of Hand", "Stealth"],
    intelligence: ["Arcana", "History", "Investigation", "Nature", "Religion"],
    wisdom: ["Animal Handling", "Insight", "Medicine", "Perception", "Survival"],
    charisma: ["Deception", "Intimidation", "Performance", "Persuasion"]
  }.freeze

  ALL_SKILLS = SKILLS.values.flatten.freeze

  # Skill proficiency options by class
  CLASS_SKILL_OPTIONS = {
    "Barbarian" => ["Animal Handling", "Athletics", "Intimidation", "Nature", "Perception", "Survival"],
    "Bard" => ALL_SKILLS,
    "Cleric" => ["History", "Insight", "Medicine", "Persuasion", "Religion"],
    "Druid" => ["Arcana", "Animal Handling", "Insight", "Medicine", "Nature", "Perception", "Religion", "Survival"],
    "Fighter" => ["Acrobatics", "Animal Handling", "Athletics", "History", "Insight", "Intimidation", "Perception", "Survival"],
    "Monk" => ["Acrobatics", "Athletics", "History", "Insight", "Religion", "Stealth"],
    "Paladin" => ["Athletics", "Insight", "Intimidation", "Medicine", "Persuasion", "Religion"],
    "Ranger" => ["Animal Handling", "Athletics", "Insight", "Investigation", "Nature", "Perception", "Stealth", "Survival"],
    "Rogue" => ["Acrobatics", "Athletics", "Deception", "Insight", "Intimidation", "Investigation", "Perception", "Performance", "Persuasion", "Sleight of Hand", "Stealth"],
    "Sorcerer" => ["Arcana", "Deception", "Insight", "Intimidation", "Persuasion", "Religion"],
    "Warlock" => ["Arcana", "Deception", "History", "Intimidation", "Investigation", "Nature", "Religion"],
    "Wizard" => ["Arcana", "History", "Insight", "Investigation", "Medicine", "Religion"]
  }.freeze

  # ============================================
  # CHARACTER DATA CLASS
  # ============================================

  class Character
    attr_accessor :name, :level, :race, :character_class, :background,
                  :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma,
                  :armor_class, :proficiency_bonus, :hit_points, :skill_proficiencies

    def initialize(attributes = {})
      @name = attributes[:name] || "Unnamed Hero"
      @level = attributes[:level] || 1
      @race = attributes[:race]
      @character_class = attributes[:character_class]
      @background = attributes[:background]
      @strength = attributes[:strength] || 10
      @dexterity = attributes[:dexterity] || 10
      @constitution = attributes[:constitution] || 10
      @intelligence = attributes[:intelligence] || 10
      @wisdom = attributes[:wisdom] || 10
      @charisma = attributes[:charisma] || 10
      @armor_class = attributes[:armor_class] || 10
      @proficiency_bonus = attributes[:proficiency_bonus] || 2
      @hit_points = attributes[:hit_points] || 10
      @skill_proficiencies = attributes[:skill_proficiencies] || []
    end

    # Ability score modifiers
    def strength_modifier
      calculate_modifier(@strength)
    end

    def dexterity_modifier
      calculate_modifier(@dexterity)
    end

    def constitution_modifier
      calculate_modifier(@constitution)
    end

    def intelligence_modifier
      calculate_modifier(@intelligence)
    end

    def wisdom_modifier
      calculate_modifier(@wisdom)
    end

    def charisma_modifier
      calculate_modifier(@charisma)
    end

    # Get all character attributes as a hash
    def to_hash
      {
        name: @name,
        level: @level,
        race: @race,
        character_class: @character_class,
        background: @background,
        strength: @strength,
        strength_modifier: strength_modifier,
        dexterity: @dexterity,
        dexterity_modifier: dexterity_modifier,
        constitution: @constitution,
        constitution_modifier: constitution_modifier,
        intelligence: @intelligence,
        intelligence_modifier: intelligence_modifier,
        wisdom: @wisdom,
        wisdom_modifier: wisdom_modifier,
        charisma: @charisma,
        charisma_modifier: charisma_modifier,
        armor_class: @armor_class,
        proficiency_bonus: @proficiency_bonus,
        hit_points: @hit_points,
        skill_proficiencies: @skill_proficiencies
      }
    end

    private

    def calculate_modifier(ability_score)
      ABILITY_SCORE_MODIFIERS.fetch(ability_score, 0)
    end
  end

  # ============================================
  # CALCULATOR MODULES
  # ============================================

  module StatCalculator
    # Calculate ability score modifier
    # Formula: (score - 10) / 2, rounded down
    def self.calculate_modifier(ability_score)
      return "Error: ability score must be between 1 and 30" unless (1..30).include?(ability_score)
      ABILITY_SCORE_MODIFIERS[ability_score]
    end

    # Calculate proficiency bonus by level
    def self.proficiency_bonus(level)
      PROFICIENCY_BONUS_BY_LEVEL.find { |range, _| range.include?(level) }&.last || 2
    end

    # Calculate hit points for a character
    # Formula: hit_die_max + con_mod + (level - 1) * (average_roll + con_mod)
    def self.calculate_hit_points(character_class:, level:, constitution_modifier:)
      hit_dice_info = HIT_DICE_BY_CLASS[character_class]
      return 0 unless hit_dice_info

      first_level_hp = hit_dice_info[:hit_die] + constitution_modifier
      additional_levels_hp = (level - 1) * (hit_dice_info[:average_roll] + constitution_modifier)

      [first_level_hp + additional_levels_hp, 1].max
    end

    # Calculate armor class (unarmored)
    def self.calculate_armor_class(dexterity_modifier:, armor: nil)
      base_ac = 10
      base_ac + dexterity_modifier
    end
  end

  module DiceRoller
    NUMBER_OF_ABILITY_SCORES = 6
    DICE_PER_ROLL = 4
    DICE_SIDES = 6

    # Roll ability scores using 4d6 drop lowest method
    # Rolls 4 six-sided dice, drops the lowest, sums the remaining 3
    def self.roll_ability_scores
      NUMBER_OF_ABILITY_SCORES.times.map { roll_4d6_drop_lowest }
    end

    private

    def self.roll_4d6_drop_lowest
      rolls = DICE_PER_ROLL.times.map { rand(1..DICE_SIDES) }
      rolls.sum - rolls.min
    end
  end

  # ============================================
  # INPUT HELPERS (for interactive mode)
  # ============================================

  module InputHelper
    def self.get_input(default_value)
      puts default_value
      default_value
    end

    def self.select_from_list(options, prompt)
      puts options
      puts prompt
      options.first
    end
  end

  # ============================================
  # CHARACTER BUILDER
  # ============================================

  class CharacterBuilder
    def initialize
      @character = Character.new
    end

    def set_name(name)
      @character.name = name
      self
    end

    def set_level(level)
      @character.level = level
      @character.proficiency_bonus = StatCalculator.proficiency_bonus(level)
      self
    end

    def set_class(character_class)
      @character.character_class = character_class
      self
    end

    def set_race(race)
      @character.race = race
      self
    end

    def set_background(background)
      @character.background = background
      self
    end

    def set_ability_scores(strength:, dexterity:, constitution:, intelligence:, wisdom:, charisma:)
      @character.strength = strength
      @character.dexterity = dexterity
      @character.constitution = constitution
      @character.intelligence = intelligence
      @character.wisdom = wisdom
      @character.charisma = charisma
      self
    end

    def calculate_derived_stats
      @character.hit_points = StatCalculator.calculate_hit_points(
        character_class: @character.character_class,
        level: @character.level,
        constitution_modifier: @character.constitution_modifier
      )
      @character.armor_class = StatCalculator.calculate_armor_class(
        dexterity_modifier: @character.dexterity_modifier
      )
      self
    end

    def set_skill_proficiencies(skills)
      @character.skill_proficiencies = skills
      self
    end

    def build
      @character
    end
  end

  # ============================================
  # LEGACY COMPATIBILITY FUNCTIONS
  # These maintain backward compatibility with the original API
  # ============================================

  def get_input(default)
    InputHelper.get_input(default)
  end

  def hitpointcalculator(char_class, level, constitution_modifier)
    StatCalculator.calculate_hit_points(
      character_class: char_class.to_s.chomp,
      level: level,
      constitution_modifier: constitution_modifier
    )
  end

  def my_modcalc(stat)
    StatCalculator.calculate_modifier(stat)
  end

  def proficiency(level)
    StatCalculator.proficiency_bonus(level)
  end

  def classpick
    InputHelper.select_from_list(CHARACTER_CLASSES, "What class is your character?")
  end

  def racepick
    InputHelper.select_from_list(PLAYABLE_RACES, "What race is your character?")
  end

  def backgroundpick
    InputHelper.select_from_list(CHARACTER_BACKGROUNDS, "What background is your character?")
  end

  def proficiency_by_class(character_class)
    CLASS_SKILL_OPTIONS.fetch(character_class, [])
  end

  def skillpopulator
    ALL_SKILLS.each_with_object({}) { |skill, hash| hash[skill.downcase] = 0 }
  end

  def statroll
    DiceRoller.roll_ability_scores
  end

  def statpick(stats)
    # Returns the stats in order for assignment
    stats.dup
  end

  def armorcalc
    # Placeholder for armor calculation
  end

  def profpicker
    # Placeholder for proficiency picking
  end

  # Legacy class aliases
  DnDchars = Character
  Ranger = Class.new { attr_accessor :damage, :chancetohit, :armor, :weapon }

  # Legacy constants module
  module Proficiencies
    ATHLETICS = "athletics"
    ACROBATICS = "acrobatics"
    SLEIGHT_OF_HAND = "sleight of hand"
    STEALTH = "stealth"
    ARCANA = "arcana"
    HISTORY = "history"
    INVESTIGATION = "investigation"
    NATURE = "nature"
    RELIGION = "religion"
    ANIMAL_HANDLING = "animal handling"
    INSIGHT = "insight"
    MEDICINE = "medicine"
    PERCEPTION = "perception"
    SURVIVAL = "survival"
    DECEPTION = "deception"
    INTIMIDATION = "intimidation"
    PERFORMANCE = "performance"
    PERSUASION = "persuasion"
    NIL = nil
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata

  puts "Welcome to the D&D Character Creator!"
  puts "=" * 40

  builder = CharacterBuilder.new

  # Interactive character creation
  character_class = classpick
  race = racepick
  background = backgroundpick
  stats = statroll

  puts "You rolled: #{stats.inspect}"

  builder
    .set_name("Adventurer")
    .set_level(1)
    .set_class(character_class)
    .set_race(race)
    .set_background(background)
    .set_ability_scores(
      strength: stats[0],
      dexterity: stats[1],
      constitution: stats[2],
      intelligence: stats[3],
      wisdom: stats[4],
      charisma: stats[5]
    )
    .calculate_derived_stats

  character = builder.build

  puts "\n" + "=" * 40
  puts "Character Created!"
  puts "=" * 40
  puts character.to_hash
end
