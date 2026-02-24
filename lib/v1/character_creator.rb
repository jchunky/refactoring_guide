module CharacterCreatorKata
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

  CLASSES = %w[Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard].freeze

  SPECIES = %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling].freeze

  BACKGROUNDS = %w[Acolyte Criminal Sage Soldier].freeze

  HIT_DICE = {
    "Barbarian" => 12,
    "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
    "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
    "Sorcerer" => 6, "Wizard" => 6
  }.freeze

  BACKGROUND_DATA = {
    "Acolyte" => {
      ability_bonuses: %w[Intelligence Wisdom Charisma],
      skill_proficiencies: [Proficiencies::INSIGHT, Proficiencies::RELIGION]
    },
    "Criminal" => {
      ability_bonuses: %w[Dexterity Constitution Intelligence],
      skill_proficiencies: [Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH]
    },
    "Sage" => {
      ability_bonuses: %w[Constitution Intelligence Wisdom],
      skill_proficiencies: [Proficiencies::ARCANA, Proficiencies::HISTORY]
    },
    "Soldier" => {
      ability_bonuses: %w[Strength Dexterity Constitution],
      skill_proficiencies: [Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION]
    }
  }.freeze

  CLASS_PROFICIENCIES = {
    "Barbarian" => [Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION,
                    Proficiencies::NATURE, Proficiencies::PERCEPTION, Proficiencies::SURVIVAL],
    "Bard" => [Proficiencies::ATHLETICS, Proficiencies::ACROBATICS, Proficiencies::SLEIGHT_OF_HAND,
               Proficiencies::STEALTH, Proficiencies::ARCANA, Proficiencies::HISTORY,
               Proficiencies::INVESTIGATION, Proficiencies::NATURE, Proficiencies::RELIGION,
               Proficiencies::RELIGION, Proficiencies::ANIMAL_HANDLING, Proficiencies::INSIGHT,
               Proficiencies::MEDICINE, Proficiencies::PERCEPTION, Proficiencies::SURVIVAL,
               Proficiencies::DECEPTION, Proficiencies::INTIMIDATION, Proficiencies::PERFORMANCE,
               Proficiencies::PERSUASION],
    "Cleric" => [Proficiencies::HISTORY, Proficiencies::INSIGHT, Proficiencies::MEDICINE,
                 Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Druid" => [Proficiencies::ARCANA, Proficiencies::ANIMAL_HANDLING, Proficiencies::INSIGHT,
                Proficiencies::MEDICINE, Proficiencies::NATURE, Proficiencies::PERCEPTION,
                Proficiencies::RELIGION, Proficiencies::SURVIVAL],
    "Fighter" => [Proficiencies::ACROBATICS, Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS,
                  Proficiencies::HISTORY, Proficiencies::INSIGHT, Proficiencies::INTIMIDATION,
                  Proficiencies::PERCEPTION, Proficiencies::PERSUASION, Proficiencies::SURVIVAL],
    "Monk" => [Proficiencies::ACROBATICS, Proficiencies::ATHLETICS, Proficiencies::HISTORY,
               Proficiencies::INSIGHT, Proficiencies::RELIGION, Proficiencies::STEALTH],
    "Paladin" => [Proficiencies::ATHLETICS, Proficiencies::INSIGHT, Proficiencies::INTIMIDATION,
                  Proficiencies::MEDICINE, Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Ranger" => [Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS, Proficiencies::INSIGHT,
                 Proficiencies::INVESTIGATION, Proficiencies::NATURE, Proficiencies::PERCEPTION,
                 Proficiencies::STEALTH, Proficiencies::SURVIVAL],
    "Rogue" => [Proficiencies::ACROBATICS, Proficiencies::ATHLETICS, Proficiencies::DECEPTION,
                Proficiencies::INSIGHT, Proficiencies::INTIMIDATION, Proficiencies::INVESTIGATION,
                Proficiencies::PERCEPTION, Proficiencies::PERSUASION, Proficiencies::SLEIGHT_OF_HAND,
                Proficiencies::STEALTH],
    "Sorcerer" => [Proficiencies::ARCANA, Proficiencies::DECEPTION, Proficiencies::INSIGHT,
                   Proficiencies::INTIMIDATION, Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Warlock" => [Proficiencies::ARCANA, Proficiencies::DECEPTION, Proficiencies::HISTORY,
                  Proficiencies::INTIMIDATION, Proficiencies::INVESTIGATION, Proficiencies::NATURE,
                  Proficiencies::RELIGION],
    "Wizard" => [Proficiencies::ARCANA, Proficiencies::HISTORY, Proficiencies::INSIGHT,
                 Proficiencies::INVESTIGATION, Proficiencies::MEDICINE, Proficiencies::NATURE,
                 Proficiencies::RELIGION]
  }.freeze

  STAT_NAMES = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma].freeze

  def get_input(default)
    puts default
    default
  end

  def hitpointcalculator(char_class, level, con)
    hit_die = HIT_DICE[char_class.chomp]
    return nil unless hit_die

    hit_die + con + (level * (hit_die / 2 + 1 + con))
  end

  def armorcalc
    if $charstats
      $charstats.ac = 10 + $charstats.dexmod
    end
  end

  def backgroundpick
    puts BACKGROUNDS
    puts "What species is your character? "
    background_choice = ""
    until BACKGROUNDS.include?(background_choice)
      background_choice = get_input(BACKGROUNDS.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless BACKGROUNDS.include?(background_choice)
    end
    background_choice
  end

  def background_bonuses(background)
    BACKGROUND_DATA.fetch(background, { ability_bonuses: [], skill_proficiencies: [] })
  end

  class DnDchars
    attr_accessor :charname, :level, :species, :class_of_char, :background,
                  :str, :strmod, :dex, :dexmod, :con, :conmod,
                  :int, :intmod, :wis, :wismod, :cha, :chamod,
                  :ac, :prof, :hitpoints, :skills

    def initialize(charname, level, species, class_of_char, background,
                   str, strmod, dex, dexmod, con, conmod, int, intmod,
                   wis, wismod, cha, chamod, ac, prof, hitpoints, skills)
      @charname = charname
      @level = level
      @species = species
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

  class Ranger
    attr_accessor :damage, :chancetohit, :armor, :weapon
  end

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

  def my_modcalc(stat)
    if stat < 2 then -5
    elsif stat < 30 then (stat - 10) / 2
    else puts "error: str must be between 0 and 30"
    end
  end

  def proficiency(level)
    case level
    when 1..4 then 2
    when 5..8 then 3
    when 9..12 then 4
    when 13..16 then 5
    else 6
    end
  end

  def proficiency_by_class(character_class)
    CLASS_PROFICIENCIES.fetch(character_class, [])
  end

  def profpicker
    tempprof = %w[athletics acrobatics sleight_of_hand stealth arcana history investigation nature religion
                  animal_handling insight medicine perception survival deception intimidation performance
                  persuasion]

    puts "These are your stats: "
    (0...19).each { |n| puts $prof[n] }

    3.times do |pick|
      slot = 19 + pick
      label = pick == 0 ? "first" : (pick == 1 ? "second" : "second")
      puts "Which skill would you like to choose as your #{label} proficiency (case sensitive)"

      while $prof[slot].nil?
        choice = get_input($prof.compact.first).chomp
        puts choice if pick == 0

        if choice.nil? || !tempprof.include?(choice)
          puts "please select one of the offered skills (case sensitive)"
        else
          $prof[slot] = choice
          tempprof[tempprof.index(choice)] = nil
          tempprof.compact!
        end
      end

      puts "These are your remaining stats: "
      puts tempprof

      if pick < 2
        puts "Which skill would you like to choose as your second proficiency (case sensitive)"
      end
    end
  end

  def speciespick
    puts SPECIES
    puts "What species is your character? "
    species_choice = ""
    until SPECIES.include?(species_choice)
      species_choice = get_input(SPECIES.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless SPECIES.include?(species_choice)
    end
    species_choice
  end

  def skillpopulator
    {
      "athletics" => 0, "acrobatics" => 0, "sleight of hand" => 0, "stealth" => 0,
      "arcana" => 0, "history" => 0, "investigation" => 0, "nature" => 0, "religion" => 0,
      "animal handling" => 0, "insight" => 0, "medicine" => 0, "perception" => 0, "survival" => 0,
      "deception" => 0, "intimidation" => 0, "performance" => 0, "persuasion" => 0
    }
  end

  def statpick(stats)
    loop do
      finalstats = []
      puts "These are your stats: "
      (0...6).each { |n| puts stats[n] }

      STAT_NAMES[0..4].each_with_index do |stat_name, index|
        puts "These are your remaining stats: " if index > 0
        stats.compact!
        puts stats if index > 0
        puts "Which number would you like to be your #{stat_name} stat? "

        while finalstats[index].nil?
          value = get_input(stats.compact.first).to_i
          if value.nil? || !stats.include?(value)
            puts "Please select one of the available numbers"
          else
            finalstats[index] = value
            idx = stats.index(value)
            stats[idx] = nil
          end
        end
      end

      finalstats[5] = stats.compact.first

      puts "So your stats are  Strength: #{finalstats[0]}, Dexteriy: #{finalstats[1]}, Constitution: #{finalstats[2]},
    Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until finish == "y" || finish == "n"
        finish = get_input("y").chomp
        if finish == "n"
          (0...6).each do |n|
            stats[n] = finalstats[n]
            finalstats[n] = nil
          end
        elsif finish != "y"
          puts "Please select y to complete this process or n to start over"
        end
      end

      return finalstats if finish == "y"
    end
  end

  def statroll
    [15, 14, 13, 12, 10, 8]
  end

  def main
    puts "Welcome to the D&D Character Creator!"
    puts "=" * 40

    charclass = classpick
    species = speciespick
    background = backgroundpick

    stats = statroll
    puts "You rolled: #{stats.inspect}"
    finalstats = statpick(stats)

    level = 1
    str, dex, con, int, wis, cha = finalstats
    strmod = my_modcalc(str)
    dexmod = my_modcalc(dex)
    conmod = my_modcalc(con)
    intmod = my_modcalc(int)
    wismod = my_modcalc(wis)
    chamod = my_modcalc(cha)

    prof = proficiency(level)
    hitpoints = hitpointcalculator(charclass, level, conmod)
    skills = skillpopulator

    puts "\nWhat is your character's name?"
    charname = get_input("Adventurer")

    $charstats = DnDchars.new(
      charname, level, species, charclass, background,
      str, strmod, dex, dexmod, con, conmod, int, intmod, wis, wismod, cha, chamod,
      10 + dexmod, prof, hitpoints, skills
    )

    puts "\n" + "=" * 40
    puts "Character Created!"
    puts "=" * 40
    puts $charstats.context
  end
end

if __FILE__ == $0
  include CharacterCreatorKata
  main
end
