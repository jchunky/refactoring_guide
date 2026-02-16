module CharacterCreatorKata
  require "active_support/all"

  def get_input(default)
    puts default
    default
  end

  # Data-driven hit point calculation
  HIT_DICE = {
    "Barbarian" => { base: 12, per_level: 7 },
    "Fighter" => { base: 10, per_level: 6 },
    "Paladin" => { base: 10, per_level: 6 },
    "Ranger" => { base: 10, per_level: 6 },
    "Bard" => { base: 8, per_level: 5 },
    "Cleric" => { base: 8, per_level: 5 },
    "Druid" => { base: 8, per_level: 5 },
    "Monk" => { base: 8, per_level: 5 },
    "Rogue" => { base: 8, per_level: 5 },
    "Warlock" => { base: 8, per_level: 5 },
    "Sorcerer" => { base: 6, per_level: 4 },
    "Wizard" => { base: 6, per_level: 4 }
  }.freeze

  def hitpointcalculator(char_class, level, con)
    dice = HIT_DICE[char_class.chomp]
    return nil unless dice
    dice[:base] + con + (level * (dice[:per_level] + con))
  end

  def armorcalc
    armor = nil
    $charstats.ac = 10 + $charstats.dexmod if armor.nil?
  end

  BACKGROUNDS = [
    "Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Gladiator",
    "Guild Artisan", "Guild Merchant", "Hermit", "Knight", "Noble", "Outlander",
    "Pirate", "Sage", "Sailor", "Soldier", "Spy", "Urchin"
  ].freeze

  def backgroundpick
    puts BACKGROUNDS
    puts "What race is your character? "
    pick_from_list(BACKGROUNDS)
  end

  CLASSES = [
    "Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk",
    "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"
  ].freeze

  def classpick
    puts CLASSES
    puts "What class is your character? "
    charclass = ""
    until CLASSES.include?(charclass)
      charclass = get_input(CLASSES.first).capitalize.chomp
      puts "please select an option from the list" unless CLASSES.include?(charclass)
    end
    charclass
  end

  RACES = [
    "Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Lightfoot Halfling",
    "Stout Halfling", "Human", "Human Variant", "Dragonborn", "Rock Gnome",
    "Forest Gnome", "Half Elf", "Half Orc", "Tiefling"
  ].freeze

  def racepick
    puts RACES
    puts "What race is your character? "
    pick_from_list(RACES)
  end

  def pick_from_list(list)
    choice = ""
    until list.include?(choice)
      choice = get_input(list.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless list.include?(choice)
    end
    choice
  end

  # Stat modifier lookup using ranges
  STAT_MODIFIERS = {
    (..1) => -5, (2..3) => -4, (4..5) => -3, (6..7) => -2, (8..9) => -1,
    (10..11) => 0, (12..13) => 1, (14..15) => 2, (16..17) => 3, (18..19) => 4,
    (20..21) => 5, (22..23) => 6, (24..25) => 7, (26..27) => 8
  }.freeze

  def my_modcalc(stat)
    STAT_MODIFIERS.find { |range, _| range.include?(stat) }&.last || (puts "error: str must be between 0 and 30")
  end

  # Proficiency bonus by level
  PROFICIENCY_BONUS = {
    (1..4) => 2, (5..8) => 3, (9..12) => 4, (13..16) => 5, (17..) => 6
  }.freeze

  def proficiency(level)
    PROFICIENCY_BONUS.find { |range, _| range.include?(level) }&.last
  end

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

    ALL = [ATHLETICS, ACROBATICS, SLEIGHT_OF_HAND, STEALTH, ARCANA, HISTORY,
           INVESTIGATION, NATURE, RELIGION, ANIMAL_HANDLING, INSIGHT, MEDICINE,
           PERCEPTION, SURVIVAL, DECEPTION, INTIMIDATION, PERFORMANCE, PERSUASION].freeze
  end

  # Data-driven class proficiency options
  CLASS_PROFICIENCIES = {
    "Barbarian" => [Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION,
                    Proficiencies::NATURE, Proficiencies::PERCEPTION, Proficiencies::SURVIVAL],
    "Bard" => Proficiencies::ALL,
    "Cleric" => [Proficiencies::HISTORY, Proficiencies::INSIGHT, Proficiencies::MEDICINE,
                 Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Druid" => [Proficiencies::ARCANA, Proficiencies::ANIMAL_HANDLING, Proficiencies::INSIGHT,
                Proficiencies::MEDICINE, Proficiencies::NATURE, Proficiencies::PERCEPTION,
                Proficiencies::RELIGION, Proficiencies::SURVIVAL],
    "Fighter" => [Proficiencies::ACROBATICS, Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS,
                  Proficiencies::HISTORY, Proficiencies::INSIGHT, Proficiencies::INTIMIDATION,
                  Proficiencies::PERCEPTION, Proficiencies::SURVIVAL],
    "Monk" => [Proficiencies::ACROBATICS, Proficiencies::ATHLETICS, Proficiencies::HISTORY,
               Proficiencies::INSIGHT, Proficiencies::RELIGION, Proficiencies::STEALTH],
    "Paladin" => [Proficiencies::ATHLETICS, Proficiencies::INSIGHT, Proficiencies::INTIMIDATION,
                  Proficiencies::MEDICINE, Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Ranger" => [Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS, Proficiencies::INSIGHT,
                 Proficiencies::INVESTIGATION, Proficiencies::NATURE, Proficiencies::PERCEPTION,
                 Proficiencies::STEALTH, Proficiencies::SURVIVAL],
    "Rogue" => [Proficiencies::ACROBATICS, Proficiencies::ATHLETICS, Proficiencies::DECEPTION,
                Proficiencies::INSIGHT, Proficiencies::INTIMIDATION, Proficiencies::INVESTIGATION,
                Proficiencies::PERCEPTION, Proficiencies::PERFORMANCE, Proficiencies::PERSUASION,
                Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH],
    "Sorcerer" => [Proficiencies::ARCANA, Proficiencies::DECEPTION, Proficiencies::INSIGHT,
                   Proficiencies::INTIMIDATION, Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Warlock" => [Proficiencies::ARCANA, Proficiencies::DECEPTION, Proficiencies::HISTORY,
                  Proficiencies::INTIMIDATION, Proficiencies::INVESTIGATION, Proficiencies::NATURE,
                  Proficiencies::RELIGION],
    "Wizard" => [Proficiencies::ARCANA, Proficiencies::HISTORY, Proficiencies::INSIGHT,
                 Proficiencies::INVESTIGATION, Proficiencies::MEDICINE, Proficiencies::RELIGION]
  }.freeze

  def proficiency_by_class(character_class) = CLASS_PROFICIENCIES.fetch(character_class, [])

  class DnDchars < Struct.new(:charname, :level, :race, :class_of_char, :background,
                              :str, :strmod, :dex, :dexmod, :con, :conmod,
                              :int, :intmod, :wis, :wismod, :cha, :chamod,
                              :ac, :prof, :hitpoints, :skills, keyword_init: true)
    def context = members.map { { it => self[it] } }
  end

  class Ranger < Struct.new(:damage, :chancetohit, :armor, :weapon, keyword_init: true)
  end

  def profpicker
    tempprof = Proficiencies::ALL.map { it.tr(" ", "_") }

    puts "These are your stats: "
    $prof[0...19].each { puts it }

    3.times do |n|
      slot = 19 + n
      puts "Which skill would you like to choose as your #{ordinal(n + 1)} proficiency (case sensitive)"

      while $prof[slot].nil?
        choice = get_input($prof.compact.first).chomp
        puts choice

        if choice.nil? || !tempprof.include?(choice)
          puts "please select one of the offered skills (case sensitive)"
        else
          $prof[slot] = choice
          tempprof.delete(choice)
        end
      end

      puts "These are your remaining stats: "
      puts tempprof.compact
    end
  end

  def ordinal(n)
    case n
    in 1 then "first"
    in 2 then "second"
    in 3 then "third"
    end
  end

  SKILL_LIST = {
    "athletics" => 0, "acrobatics" => 0, "sleight of hand" => 0, "stealth" => 0,
    "arcana" => 0, "history" => 0, "investigation" => 0, "nature" => 0, "religion" => 0,
    "animal handling" => 0, "insight" => 0, "medicine" => 0, "perception" => 0,
    "survival" => 0, "deception" => 0, "intimidation" => 0, "performance" => 0,
    "persuasion" => 0
  }.freeze

  def skillpopulator = SKILL_LIST.dup

  STAT_NAMES = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma].freeze

  def statpick(stats)
    loop do
      finalstats = []
      available = stats.dup

      puts "These are your stats: "
      puts available

      STAT_NAMES[0..4].each_with_index do |stat_name, idx|
        puts "Which number would you like to be your #{stat_name} stat? "

        while finalstats[idx].nil?
          choice = get_input(available.compact.first).to_i
          if choice.nil? || !available.include?(choice)
            puts "Please select one of the available numbers"
          else
            finalstats[idx] = choice
            available[available.index(choice)] = nil
            available.compact!
          end
        end

        puts "These are your remaining stats: "
        puts available
      end

      finalstats[5] = available.compact.first

      puts "So your stats are Strength: #{finalstats[0]}, Dexterity: #{finalstats[1]}, Constitution: #{finalstats[2]},
    Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until %w[y n].include?(finish)
        finish = get_input("y").chomp
        case finish
        when "n" then stats = finalstats.dup
        when "y" then return finalstats
        else puts "Please select y to complete this process or n to start over"
        end
      end
    end
  end

  def statroll
    6.times.map do
      rolls = 4.times.map { rand(1..6) }
      rolls.sum - rolls.min
    end
  end
end
