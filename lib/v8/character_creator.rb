module CharacterCreatorKata
  # Refactored to fix:
  # - Long Parameter Lists: AbilityScores and CharacterInfo parameter objects
  # - Data Clumps: Stats grouped into AbilityScores, character info into CharacterInfo
  # - Primitive Obsession: AbilityScore class for individual stat + modifier
  require "active_support/all"

  def get_input(default)
    puts default
    default
  end

  # Primitive Obsession fix: Individual ability score with auto-calculated modifier
  class AbilityScore
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def modifier
      (value - 10) / 2
    end
  end

  # Data Clump fix: All six ability scores travel together
  class AbilityScores
    ABILITIES = [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma].freeze

    attr_reader :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma

    def initialize(str:, dex:, con:, int:, wis:, cha:)
      @strength = AbilityScore.new(str)
      @dexterity = AbilityScore.new(dex)
      @constitution = AbilityScore.new(con)
      @intelligence = AbilityScore.new(int)
      @wisdom = AbilityScore.new(wis)
      @charisma = AbilityScore.new(cha)
    end

    def to_h
      ABILITIES.each_with_object({}) do |ability, hash|
        score = send(ability)
        hash[ability] = { value: score.value, modifier: score.modifier }
      end
    end
  end

  # Data Clump fix: Character identity info travels together
  class CharacterIdentity
    attr_reader :name, :race, :character_class, :background, :level

    def initialize(name:, race:, character_class:, background:, level:)
      @name = name
      @race = race
      @character_class = character_class
      @background = background
      @level = level
    end
  end

  # Long Parameter List fix: Character uses composition instead of 21 parameters
  class DnDCharacter
    attr_reader :identity, :abilities, :skills
    attr_accessor :ac, :hitpoints

    def initialize(identity:, abilities:)
      @identity = identity
      @abilities = abilities
      @skills = SkillSet.new
      @ac = calculate_ac
      @hitpoints = calculate_hitpoints
    end

    def proficiency_bonus
      case identity.level
      when 1..4 then 2
      when 5..8 then 3
      when 9..12 then 4
      when 13..16 then 5
      else 6
      end
    end

    def context
      {
        name: identity.name,
        level: identity.level,
        race: identity.race,
        class: identity.character_class,
        background: identity.background,
        abilities: abilities.to_h,
        ac: ac,
        proficiency: proficiency_bonus,
        hitpoints: hitpoints
      }
    end

    private

    def calculate_ac
      10 + abilities.dexterity.modifier
    end

    def calculate_hitpoints
      HitPointCalculator.calculate(
        character_class: identity.character_class,
        level: identity.level,
        constitution_modifier: abilities.constitution.modifier
      )
    end
  end

  # Feature Envy fix: HP calculation belongs to a dedicated calculator
  class HitPointCalculator
    HIT_DIE = {
      'Barbarian' => 12,
      'Fighter' => 10, 'Paladin' => 10, 'Ranger' => 10,
      'Bard' => 8, 'Cleric' => 8, 'Druid' => 8, 'Monk' => 8, 'Rogue' => 8, 'Warlock' => 8,
      'Sorcerer' => 6, 'Wizard' => 6
    }.freeze

    def self.calculate(character_class:, level:, constitution_modifier:)
      die = HIT_DIE[character_class] || 8
      average_roll = (die / 2) + 1
      die + constitution_modifier + (level * (average_roll + constitution_modifier))
    end
  end

  # Data Clump fix: Skills grouped into a set
  class SkillSet
    SKILLS = [
      'athletics', 'acrobatics', 'sleight of hand', 'stealth', 'arcana', 'history',
      'investigation', 'nature', 'religion', 'animal handling', 'insight', 'medicine',
      'perception', 'survival', 'deception', 'intimidation', 'performance', 'persuasion'
    ].freeze

    def initialize
      @proficiencies = {}
      SKILLS.each { |skill| @proficiencies[skill] = false }
    end

    def proficient?(skill)
      @proficiencies[skill] || false
    end

    def add_proficiency(skill)
      @proficiencies[skill] = true if SKILLS.include?(skill)
    end

    def to_h
      @proficiencies.dup
    end
  end

  # Data Clump fix: Class proficiency options
  class ClassProficiencies
    OPTIONS = {
      'Barbarian' => ['animal handling', 'athletics', 'intimidation', 'nature', 'perception', 'survival'],
      'Bard' => SkillSet::SKILLS,
      'Cleric' => ['history', 'insight', 'medicine', 'persuasion', 'religion'],
      'Druid' => ['arcana', 'animal handling', 'insight', 'medicine', 'nature', 'perception', 'religion', 'survival'],
      'Fighter' => ['acrobatics', 'animal handling', 'athletics', 'history', 'insight', 'intimidation', 'perception', 'survival'],
      'Monk' => ['acrobatics', 'athletics', 'history', 'insight', 'religion', 'stealth'],
      'Paladin' => ['athletics', 'insight', 'intimidation', 'medicine', 'persuasion', 'religion'],
      'Ranger' => ['animal handling', 'athletics', 'insight', 'investigation', 'nature', 'perception', 'stealth', 'survival'],
      'Rogue' => ['acrobatics', 'athletics', 'deception', 'insight', 'intimidation', 'investigation', 'perception', 'performance', 'persuasion', 'sleight of hand', 'stealth'],
      'Sorcerer' => ['arcana', 'deception', 'insight', 'intimidation', 'persuasion', 'religion'],
      'Warlock' => ['arcana', 'deception', 'history', 'intimidation', 'investigation', 'nature', 'religion'],
      'Wizard' => ['arcana', 'history', 'insight', 'investigation', 'medicine', 'religion']
    }.freeze

    def self.for(character_class)
      OPTIONS[character_class] || []
    end
  end

  # Selection helpers
  module CharacterOptions
    CLASSES = ['Barbarian', 'Bard', 'Cleric', 'Druid', 'Fighter', 'Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Warlock', 'Wizard'].freeze
  
    RACES = ['Hill Dwarf', 'Mountain Dwarf', 'High Elf', 'Wood Elf', 'Lightfoot Halfling', 'Stout Halfling',
             'Human', 'Human Variant', 'Dragonborn', 'Rock Gnome', 'Forest Gnome', 'Half Elf', 'Half Orc', 'Tiefling'].freeze
  
    BACKGROUNDS = ['Acolyte', 'Charlatan', 'Criminal', 'Entertainer', 'Folk Hero', 'Gladiator',
                   'Guild Artisan', 'Guild Merchant', 'Hermit', 'Knight', 'Noble', 'Outlander',
                   'Pirate', 'Sage', 'Sailor', 'Soldier', 'Spy', 'Urchin'].freeze
  end

  def classpick
    puts CharacterOptions::CLASSES
    puts "What class is your character? "
    charclass = ""
    while !CharacterOptions::CLASSES.include?(charclass)
      charclass = get_input(CharacterOptions::CLASSES.first).capitalize.chomp
      puts "please select an option from the list" unless CharacterOptions::CLASSES.include?(charclass)
    end
    charclass
  end

  def racepick
    puts CharacterOptions::RACES
    puts "What race is your character? "
    race_choice = ""
    while !CharacterOptions::RACES.include?(race_choice)
      race_choice = get_input(CharacterOptions::RACES.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless CharacterOptions::RACES.include?(race_choice)
    end
    race_choice
  end

  def backgroundpick
    puts CharacterOptions::BACKGROUNDS
    puts "What background is your character? "
    background_choice = ""
    while !CharacterOptions::BACKGROUNDS.include?(background_choice)
      background_choice = get_input(CharacterOptions::BACKGROUNDS.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless CharacterOptions::BACKGROUNDS.include?(background_choice)
    end
    background_choice
  end

  def statroll
    stats = []
    6.times do
      dice = 4.times.map { rand(1..6) }
      stats << dice.sort.drop(1).sum
    end
    stats
  end

  def statpick(stats)
    loop do
      finalstats = []
      remaining = stats.dup
    
      puts "These are your stats: #{remaining.join(', ')}"

      %w[Strength Dexterity Constitution Intelligence Wisdom].each do |stat_name|
        puts "Which number would you like to be your #{stat_name} stat? "
      
        chosen = nil
        while chosen.nil?
          input = get_input(remaining.compact.first).to_i
          if remaining.include?(input)
            chosen = input
            remaining[remaining.index(input)] = nil
            remaining.compact!
          else
            puts "Please select one of the available numbers"
          end
        end
        finalstats << chosen
      end

      finalstats << remaining.first
      puts "So your stats are Strength: #{finalstats[0]}, Dexterity: #{finalstats[1]}, Constitution: #{finalstats[2]}, Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = get_input("y").chomp
    
      return finalstats if finish == "y"
    end
  end

  # Legacy compatibility aliases
  def hitpointcalculator(char_class, level, con)
    HitPointCalculator.calculate(
      character_class: char_class.chomp,
      level: level,
      constitution_modifier: con
    )
  end

  def my_modcalc(stat)
    AbilityScore.new(stat).modifier
  end

  def proficiency(level)
    identity = CharacterIdentity.new(name: '', race: '', character_class: '', background: '', level: level)
    char = DnDCharacter.new(
      identity: identity,
      abilities: AbilityScores.new(str: 10, dex: 10, con: 10, int: 10, wis: 10, cha: 10)
    )
    char.proficiency_bonus
  end

  def proficiency_by_class(character_class)
    ClassProficiencies.for(character_class)
  end

  def skillpopulator
    SkillSet.new.to_h.transform_values { 0 }
  end
end
