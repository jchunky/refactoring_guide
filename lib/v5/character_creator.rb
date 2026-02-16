module CharacterCreatorKata
  # Refactored using 99 Bottles of OOP principles:
  # - Extract class for each concept (Character, CharacterClass, Race, etc.)
  # - Replace conditionals with polymorphism
  # - Small methods that do one thing
  # - Names reflect roles

  require "active_support/all"

  module CharacterCreator
    # Value object for ability scores
    class AbilityScores
      ABILITIES = [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma].freeze

      attr_reader :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma

      def initialize(str:, dex:, con:, int:, wis:, cha:)
        @strength = str
        @dexterity = dex
        @constitution = con
        @intelligence = int
        @wisdom = wis
        @charisma = cha
      end

      def modifier_for(ability)
        score = send(ability)
        (score - 10) / 2
      end

      def strength_mod = modifier_for(:strength)
      def dexterity_mod = modifier_for(:dexterity)
      def constitution_mod = modifier_for(:constitution)
      def intelligence_mod = modifier_for(:intelligence)
      def wisdom_mod = modifier_for(:wisdom)
      def charisma_mod = modifier_for(:charisma)
    end

    # Base class for character classes with polymorphic behavior
    class CharacterClass
      CLASSES = {
        "Barbarian" => { hit_die: 12, proficiency_count: 2 },
        "Bard" => { hit_die: 8, proficiency_count: 3 },
        "Cleric" => { hit_die: 8, proficiency_count: 2 },
        "Druid" => { hit_die: 8, proficiency_count: 2 },
        "Fighter" => { hit_die: 10, proficiency_count: 2 },
        "Monk" => { hit_die: 8, proficiency_count: 2 },
        "Paladin" => { hit_die: 10, proficiency_count: 2 },
        "Ranger" => { hit_die: 10, proficiency_count: 3 },
        "Rogue" => { hit_die: 8, proficiency_count: 4 },
        "Sorcerer" => { hit_die: 6, proficiency_count: 2 },
        "Warlock" => { hit_die: 8, proficiency_count: 2 },
        "Wizard" => { hit_die: 6, proficiency_count: 2 }
      }.freeze

      SKILL_OPTIONS = {
        "Barbarian" => %w[animal_handling athletics intimidation nature perception survival],
        "Bard" => %w[athletics acrobatics sleight_of_hand stealth arcana history investigation
                     nature religion animal_handling insight medicine perception survival
                     deception intimidation performance persuasion],
        "Cleric" => %w[history insight medicine persuasion religion],
        "Druid" => %w[arcana animal_handling insight medicine nature perception religion survival],
        "Fighter" => %w[acrobatics animal_handling athletics history insight intimidation perception survival],
        "Monk" => %w[acrobatics athletics history insight religion stealth],
        "Paladin" => %w[athletics insight intimidation medicine persuasion religion],
        "Ranger" => %w[animal_handling athletics insight investigation nature perception stealth survival],
        "Rogue" => %w[acrobatics athletics deception insight intimidation investigation
                      perception performance persuasion sleight_of_hand stealth],
        "Sorcerer" => %w[arcana deception insight intimidation persuasion religion],
        "Warlock" => %w[arcana deception history intimidation investigation nature religion],
        "Wizard" => %w[arcana history insight investigation medicine religion]
      }.freeze

      attr_reader :name

      def self.all_names
        CLASSES.keys
      end

      def self.for(name)
        raise "Unknown class: #{name}" unless CLASSES.key?(name)
        new(name)
      end

      def initialize(name)
        @name = name
        @config = CLASSES[name]
      end

      def hit_die
        @config[:hit_die]
      end

      def proficiency_count
        @config[:proficiency_count]
      end

      def skill_options
        SKILL_OPTIONS[name] || []
      end

      def calculate_hit_points(level, constitution_mod)
        hit_die + constitution_mod + (level * (average_hit_die_roll + constitution_mod))
      end

      private

      def average_hit_die_roll
        (hit_die / 2) + 1
      end
    end

    # Race configuration
    class Race
      RACES = [
        "Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf",
        "Lightfoot Halfling", "Stout Halfling", "Human", "Human Variant",
        "Dragonborn", "Rock Gnome", "Forest Gnome", "Half Elf",
        "Half Orc", "Tiefling"
      ].freeze

      attr_reader :name

      def self.all_names
        RACES
      end

      def self.for(name)
        raise "Unknown race: #{name}" unless RACES.include?(name)
        new(name)
      end

      def initialize(name)
        @name = name
      end
    end

    # Background configuration
    class Background
      BACKGROUNDS = [
        "Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero",
        "Gladiator", "Guild Artisan", "Guild Merchant", "Hermit", "Knight",
        "Noble", "Outlander", "Pirate", "Sage", "Sailor", "Soldier",
        "Spy", "Urchin"
      ].freeze

      attr_reader :name

      def self.all_names
        BACKGROUNDS
      end

      def self.for(name)
        raise "Unknown background: #{name}" unless BACKGROUNDS.include?(name)
        new(name)
      end

      def initialize(name)
        @name = name
      end
    end

    # Skill proficiency tracking
    class Skills
      ALL_SKILLS = %w[
        athletics acrobatics sleight_of_hand stealth arcana history
        investigation nature religion animal_handling insight medicine
        perception survival deception intimidation performance persuasion
      ].freeze

      def initialize
        @proficiencies = {}
      end

      def add_proficiency(skill)
        @proficiencies[skill] = true
      end

      def proficient?(skill)
        @proficiencies[skill] == true
      end

      def proficient_skills
        @proficiencies.keys.select { |skill| proficient?(skill) }
      end

      def to_hash
        ALL_SKILLS.each_with_object({}) { |skill, hash| hash[skill] = 0 }
      end
    end

    # Proficiency bonus calculator
    class ProficiencyBonus
      LEVEL_THRESHOLDS = [
        [1, 4, 2],
        [5, 8, 3],
        [9, 12, 4],
        [13, 16, 5],
        [17, 20, 6]
      ].freeze

      def self.for_level(level)
        LEVEL_THRESHOLDS.each do |min, max, bonus|
          return bonus if level >= min && level <= max
        end
        2
      end
    end

    # Dice roller for stat generation
    class StatRoller
      def self.roll_stats
        6.times.map { roll_single_stat }
      end

      def self.roll_single_stat
        dice = 4.times.map { rand(1..6) }
        dice.sum - dice.min
      end
    end

    # The main character class
    class Character
      attr_reader :name, :level, :race, :character_class, :background,
                  :ability_scores, :skills

      def initialize(
        name:,
        level: 1,
        race:,
        character_class:,
        background:,
        ability_scores:
      )
        @name = name
        @level = level
        @race = Race.for(race)
        @character_class = CharacterClass.for(character_class)
        @background = Background.for(background)
        @ability_scores = ability_scores
        @skills = Skills.new
      end

      def hit_points
        @character_class.calculate_hit_points(level, ability_scores.constitution_mod)
      end

      def armor_class
        10 + ability_scores.dexterity_mod
      end

      def proficiency_bonus
        ProficiencyBonus.for_level(level)
      end

      def to_hash
        {
          name: @name,
          level: @level,
          race: @race.name,
          character_class: @character_class.name,
          background: @background.name,
          hit_points: hit_points,
          armor_class: armor_class,
          proficiency_bonus: proficiency_bonus
        }
      end
    end
  end

  # Legacy compatibility - keeping original class name
  class DnDchars
    attr_accessor :charname, :level, :race, :class_of_char, :background,
                  :str, :strmod, :dex, :dexmod, :con, :conmod,
                  :int, :intmod, :wis, :wismod, :cha, :chamod,
                  :ac, :prof, :hitpoints, :skills

    def initialize(charname, level, race, class_of_char, background,
                   str, strmod, dex, dexmod, con, conmod, int, intmod,
                   wis, wismod, cha, chamod, ac, prof, hitpoints, skills)
      @charname = charname
      @level = level
      @race = race
      @class_of_char = class_of_char
      @background = background
      @str = str
      @strmod = strmod
      @dex = dex
      @dexmod = dexmod
      @con = con
      @conmod = conmod
      @int = int
      @intmod = intmod
      @wis = wis
      @wismod = wismod
      @cha = cha
      @chamod = chamod
      @ac = ac
      @prof = prof
      @hitpoints = hitpoints
      @skills = skills
    end

    def context
      instance_variables.map do |attribute|
        { attribute => instance_variable_get(attribute) }
      end
    end
  end

  # Legacy helper functions
  def get_input(default)
    puts default
    default
  end

  def hitpointcalculator(char_class, level, con)
    character_class = CharacterCreator::CharacterClass.for(char_class.chomp)
    character_class.calculate_hit_points(level, con)
  end

  def my_modcalc(stat)
    (stat - 10) / 2
  end

  def proficiency(level)
    CharacterCreator::ProficiencyBonus.for_level(level)
  end

  def statroll
    CharacterCreator::StatRoller.roll_stats
  end

  def classpick
    CharacterCreator::CharacterClass.all_names
  end

  def racepick
    CharacterCreator::Race.all_names
  end

  def backgroundpick
    CharacterCreator::Background.all_names
  end

  def skillpopulator
    CharacterCreator::Skills.new.to_hash
  end

  def proficiency_by_class(character_class)
    CharacterCreator::CharacterClass::SKILL_OPTIONS[character_class] || []
  end

  # Modules for skill constants
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

  # Placeholder class for equipment
  class Ranger
    attr_accessor :damage, :chancetohit, :armor, :weapon
  end
end
