module CharacterCreatorKata
  require "active_support/all"

  CLASS_HIT_DICE = {
    "Barbarian" => 12,
    "Fighter" => 10,
    "Paladin" => 10,
    "Ranger" => 10,
    "Bard" => 8,
    "Cleric" => 8,
    "Druid" => 8,
    "Monk" => 8,
    "Rogue" => 8,
    "Warlock" => 8,
    "Sorcerer" => 6,
    "Wizard" => 6
  }.freeze

  BACKGROUNDS = ["Acolyte", "Criminal", "Sage", "Soldier"].freeze
  CLASSES = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue",
             "Sorcerer", "Warlock", "Wizard"].freeze
  SPECIES = ["Dragonborn", "Dwarf", "Elf", "Gnome", "Goliath", "Halfling",
             "Human", "Orc", "Tiefling"].freeze
  SKILL_NAMES = ["athletics", "acrobatics", "sleight_of_hand", "stealth", "arcana", "history", "investigation",
                 "nature", "religion", "animal_handling", "insight", "medicine", "perception", "survival",
                 "deception", "intimidation", "performance", "persuasion"].freeze

  def get_input(default)
    puts default
    default
    # gets
  end

  def hitpointcalculator(char_class, level, con)
    hit_die = CLASS_HIT_DICE[char_class.chomp]
    return if hit_die.nil?

    hit_die + con + (level * ((hit_die - 5) + con))
  end

  # Artificer = d8

  def armorcalc
    armor = nil
    #no armor
    if armor.nil?
      $charstats.ac = 10 + $charstats.dexmod
    end
  end

  def backgroundpick
    puts BACKGROUNDS
    puts "What species is your character? "
    prompt_choice(BACKGROUNDS, BACKGROUNDS.first) do |choice|
      normalize_choice(choice)
    end
  end

  def background_bonuses(background)
    case background
    when "Acolyte"
      [
        ["Intelligence", "Wisdom", "Charisma"],
        [Proficiencies::INSIGHT, Proficiencies::RELIGION]
      ]
    when "Criminal"
      [
        ["Dexterity", "Constitution", "Intelligence"],
        [Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH]
      ]
    when "Sage"
      [
        ["Constitution", "Intelligence", "Wisdom"],
        [Proficiencies::ARCANA, Proficiencies::HISTORY]
      ]
    when "Soldier"
      [
        ["Strength", "Dexterity", "Constitution"],
        [Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION]
      ]
    else
      [[], []]
    end
  end

  class DnDchars

    attr_accessor :charname
    attr_accessor :level
    attr_accessor :species
    attr_accessor :class_of_char
    attr_accessor :background
    attr_accessor :str
    attr_accessor :strmod
    attr_accessor :dex
    attr_accessor :dexmod
    attr_accessor :con
    attr_accessor :conmod
    attr_accessor :int
    attr_accessor :intmod
    attr_accessor :wis
    attr_accessor :wismod
    attr_accessor :cha
    attr_accessor :chamod
    attr_accessor :ac
    attr_accessor :prof
    attr_accessor :hitpoints
    attr_accessor :skills

    def initialize(charname, level, species, class_of_char, background, str, strmod, dex, dexmod, con, conmod, int, intmod,
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

  def classpick
    puts CLASSES
    puts "What class is your character? "
    prompt_choice(CLASSES, CLASSES.first) do |choice|
      choice.capitalize.chomp
    end
  end


  class Ranger

    attr_accessor :damage
    attr_accessor :chancetohit
    attr_accessor :armor
    attr_accessor :weapon



  end


  def my_modcalc(stat)
    return puts "error: str must be between 0 and 30" if stat < 0 || stat > 30

    (stat - 10) / 2
  end

  def proficiency(level)
    return 2 if level < 5
    return 3 if level < 9
    return 4 if level < 13
    return 5 if level < 17

    6
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
  end

  def proficiency_by_class(character_class)
    case character_class
    when "Barbarian"
      [
          Proficiencies::ANIMAL_HANDLING,
          Proficiencies::ATHLETICS,
          Proficiencies::INTIMIDATION,
          Proficiencies::NATURE,
          Proficiencies::PERCEPTION,
          Proficiencies::SURVIVAL
      ]
    when "Bard"
      [
          Proficiencies::ATHLETICS,
          Proficiencies::ACROBATICS,
          Proficiencies::SLEIGHT_OF_HAND,
          Proficiencies::STEALTH,
          Proficiencies::ARCANA,
          Proficiencies::HISTORY,
          Proficiencies::INVESTIGATION,
          Proficiencies::NATURE,
          Proficiencies::RELIGION,
          Proficiencies::RELIGION,
          Proficiencies::ANIMAL_HANDLING,
          Proficiencies::INSIGHT,
          Proficiencies::MEDICINE,
          Proficiencies::PERCEPTION,
          Proficiencies::SURVIVAL,
          Proficiencies::DECEPTION,
          Proficiencies::INTIMIDATION,
          Proficiencies::PERFORMANCE,
          Proficiencies::PERSUASION
      ]
    when "Cleric"
      [
          Proficiencies::HISTORY,
          Proficiencies::INSIGHT,
          Proficiencies::MEDICINE,
          Proficiencies::PERSUASION,
          Proficiencies::RELIGION
      ]
    when "Druid"
      [
          Proficiencies::ARCANA,
          Proficiencies::ANIMAL_HANDLING,
          Proficiencies::INSIGHT,
          Proficiencies::MEDICINE,
          Proficiencies::NATURE,
          Proficiencies::PERCEPTION,
          Proficiencies::RELIGION,
          Proficiencies::SURVIVAL
      ]
    when "Fighter"
      [
          Proficiencies::ACROBATICS,
          Proficiencies::ANIMAL_HANDLING,
          Proficiencies::ATHLETICS,
          Proficiencies::HISTORY,
          Proficiencies::INSIGHT,
          Proficiencies::INTIMIDATION,
          Proficiencies::PERCEPTION,
          Proficiencies::PERSUASION,
          Proficiencies::SURVIVAL
      ]
    when "Monk"
      [
          Proficiencies::ACROBATICS,
          Proficiencies::ATHLETICS,
          Proficiencies::HISTORY,
          Proficiencies::INSIGHT,
          Proficiencies::RELIGION,
          Proficiencies::STEALTH
      ]
    when "Paladin"
      [
          Proficiencies::ATHLETICS,
          Proficiencies::INSIGHT,
          Proficiencies::INTIMIDATION,
          Proficiencies::MEDICINE,
          Proficiencies::PERSUASION,
          Proficiencies::RELIGION
      ]
    when "Ranger"
      [
          Proficiencies::ANIMAL_HANDLING,
          Proficiencies::ATHLETICS,
          Proficiencies::INSIGHT,
          Proficiencies::INVESTIGATION,
          Proficiencies::NATURE,
          Proficiencies::PERCEPTION,
          Proficiencies::STEALTH,
          Proficiencies::SURVIVAL
      ]
    when "Rogue"
      [
          Proficiencies::ACROBATICS,
          Proficiencies::ATHLETICS,
          Proficiencies::DECEPTION,
          Proficiencies::INSIGHT,
          Proficiencies::INTIMIDATION,
          Proficiencies::INVESTIGATION,
          Proficiencies::PERCEPTION,
          Proficiencies::PERSUASION,
          Proficiencies::SLEIGHT_OF_HAND,
          Proficiencies::STEALTH
      ]
    when "Sorcerer"
      [
          Proficiencies::ARCANA,
          Proficiencies::DECEPTION,
          Proficiencies::INSIGHT,
          Proficiencies::INTIMIDATION,
          Proficiencies::PERSUASION,
          Proficiencies::RELIGION
      ]
    when "Warlock"
      [
          Proficiencies::ARCANA,
          Proficiencies::DECEPTION,
          Proficiencies::HISTORY,
          Proficiencies::INTIMIDATION,
          Proficiencies::INVESTIGATION,
          Proficiencies::NATURE,
          Proficiencies::RELIGION
      ]
    when "Wizard"
      [
          Proficiencies::ARCANA,
          Proficiencies::HISTORY,
          Proficiencies::INSIGHT,
          Proficiencies::INVESTIGATION,
          Proficiencies::MEDICINE,
          Proficiencies::NATURE,
          Proficiencies::RELIGION
      ]
    else
      []
    end
  end


  def profpicker
    tempprof = SKILL_NAMES.dup

    puts "These are your stats: "
    for n in 0...19
      puts $prof[n]
    end

    puts "Which skill would you like to choose as your first proficiency (case sensitive)"
    while $prof[19] == nil
      proficiency1 = get_input($prof.compact.first).chomp
      puts proficiency1
      if proficiency1.nil? || tempprof.include?(proficiency1) == false
        puts "please select one of the offered skills (case sensitive)"
      elsif tempprof.include?(proficiency1) == true
        $prof[19] = proficiency1
        for n in 0...18
          if tempprof[n] == proficiency1
            tempprof[n] = nil
            break n
          end
        end
      end
    end

    puts "These are your remaining stats: "
    tempprof.compact!
    puts tempprof

    puts "Which skill would you like to choose as your second proficiency (case sensitive)"
    while $prof[20] == nil
      proficiency2 = get_input($prof.compact.first).chomp
      if proficiency2.nil? || tempprof.include?(proficiency2) == false
        puts "please select one of the offered skills (case sensitive)"
      elsif tempprof.include?(proficiency2) == true
        $prof[20] = proficiency2
        for n in 0...18
          if tempprof[n] == proficiency2
            tempprof[n] = nil
            break n
          end
        end
      end
    end

    puts "These are your remaining stats: "
    tempprof.compact!
    puts tempprof

    puts "Which skill would you like to choose as your second proficiency (case sensitive)"
    while $prof[21] == nil
      proficiency3 = get_input($prof.compact.first).chomp
      if proficiency3.nil? || tempprof.include?(proficiency3) == false
        puts "please select one of the offered skills (case sensitive)"
      elsif tempprof.include?(proficiency3) == true
        $prof[21] = proficiency3
        for n in 0...18
          if tempprof[n] == proficiency3
            tempprof[n] = nil
            break n
          end
        end
      end
    end
  end

  def speciespick
    puts SPECIES
    puts "What species is your character? "
    prompt_choice(SPECIES, SPECIES.first) do |choice|
      normalize_choice(choice)
    end
  end

  def skillpopulator
    skillhash = {
        "athletics" => 0,
        "acrobatics"=> 0,
        "sleight of hand" => 0,
        "stealth" => 0,
        "arcana" => 0,
        "history" => 0,
        "investigation" => 0,
        "nature" => 0,
        "religion" => 0,
        "animal handling" => 0,
        "insight"=> 0,
        "medicine" => 0,
        "perception" => 0,
        "survival" => 0,
        "deception" => 0,
        "intimidation" => 0,
        "performance" => 0,
        "persuasion" => 0
    }
    skillhash
  end


  def statpick(stats)

    loop do
      finalstats = []
      puts "These are your stats: "
      stats.each { |stat| puts stat }

      finalstats[0] = pick_stat("Strength", stats)
      finalstats[1] = pick_stat("Dexterity", stats)
      finalstats[2] = pick_stat("Constitution", stats)
      finalstats[3] = pick_stat("Intelligence", stats)
      finalstats[4] = pick_stat("Wisdom", stats)
      finalstats[5] = stats.compact.first

      puts "So your stats are  Strength: #{finalstats[0]}, Dexteriy: #{finalstats[1]}, Constitution: #{finalstats[2]},\n" \
      "Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until finish == "y" || finish == "n"
        finish = get_input("y").chomp
        if finish == "n"
          stats.replace(finalstats)
          finalstats = []
        elsif finish == "y"
          # done
        else
          puts "Please select y to complete this process or n to start over"
        end
      end

      return finalstats if finish == "y"
    end
  end

  def statroll
    dice = []
    stats = []
    for n in 0...6
      for m in 0...4
        dice[m] = (rand*6).ceil
      end
      stats[n] = dice[0...4].inject(0, :+) - dice[0...4].min
    end
    stats
  end

  def prompt_choice(options, default)
    choice = ""
    until options.include?(choice)
      choice = yield(get_input(default)).chomp
      puts "please select an option from the list" unless options.include?(choice)
    end
    choice
  end

  def normalize_choice(choice)
    choice.split(/ |_|\-/).map(&:capitalize).join(" ").chomp
  end

  def pick_stat(name, stats)
    puts "Which number would you like to be your #{name} stat? "
    selection = nil
    while selection.nil?
      value = get_input(stats.compact.first).to_i
      if value.nil? || stats.include?(value) == false
        puts "Please select one of the available numbers"
      else
        selection = value
        stats[stats.index(value)] = nil
      end
    end
    puts "These are your remaining stats: "
    stats.compact!
    puts stats
    selection
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata

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
