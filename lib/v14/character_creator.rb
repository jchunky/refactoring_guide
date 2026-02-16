module CharacterCreatorKata
  require "active_support/all"

  def get_input(default)
    puts default
    default
    # gets
  end

  def hitpointcalculator(char_class, level, con)
    return 12 + con + (level * (7 + con)) if ["Barbarian"].include?(char_class.chomp)
    return 10 + con + (level * (6 + con)) if %w[Fighter Paladin Ranger].include?(char_class.chomp)
    return 8 + con + (level * (5 + con)) if %w[Bard Cleric Druid Monk Rogue Warlock].include?(char_class.chomp)

    6 + con + (level * (4 + con)) if %w[Sorcerer Wizard].include?(char_class.chomp)
  end

  # Artificer = d8

  def armorcalc
    armor = nil
    # no armor
    if armor.nil?
      $charstats.ac = 10 + $charstats.dexmod
    elsif !armor.nil?

    end
  end

  def backgroundpick
    backgrounds = %w[Acolyte Criminal Sage Soldier]
    puts backgrounds
    puts "What species is your character? "
    background_choice = ""
    while backgrounds.include?(background_choice) == false
      background_choice = get_input(backgrounds.first).split(/ |_|-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless backgrounds.include?(background_choice) == true
    end
    background_choice
  end

  def background_bonuses(background)
    ability_bonuses = []
    skill_proficiencies = []
    case background
    when "Acolyte"
      ability_bonuses = %w[Intelligence Wisdom Charisma]
      skill_proficiencies = [Proficiencies::INSIGHT, Proficiencies::RELIGION]
    when "Criminal"
      ability_bonuses = %w[Dexterity Constitution Intelligence]
      skill_proficiencies = [Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH]
    when "Sage"
      ability_bonuses = %w[Constitution Intelligence Wisdom]
      skill_proficiencies = [Proficiencies::ARCANA, Proficiencies::HISTORY]
    when "Soldier"
      ability_bonuses = %w[Strength Dexterity Constitution]
      skill_proficiencies = [Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION]
    else
      ability_bonuses = []
      skill_proficiencies = []
    end
  end

  class DnDchars
    attr_accessor :charname, :level, :species, :class_of_char, :background, :str, :strmod, :dex, :dexmod, :con, :conmod, :int, :intmod, :wis, :wismod, :cha, :chamod, :ac, :prof, :hitpoints, :skills

    def initialize(
      charname,
      level,
      species,
      class_of_char,
      background,
      str,
      strmod,
      dex,
      dexmod,
      con,
      conmod,
      int,
      intmod,
      wis,
      wismod,
      cha,
      chamod,
      ac,
      prof,
      hitpoints,
      skills
    )
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
    classes = %w[
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
    ]
    puts classes
    puts "What class is your character? "
    charclass = ""
    while classes.include?(charclass) == false
      charclass = get_input(classes.first).capitalize.chomp
      puts "please select an option from the list" unless classes.include?(charclass) == true
    end
    charclass
  end

  class Ranger
    attr_accessor :damage, :chancetohit, :armor, :weapon
  end

  def my_modcalc(stat)
    if stat < 2
      -5
    elsif stat < 4
      -4
    elsif stat < 6
      -3
    elsif stat < 8
      -2
    elsif stat < 10
      -1
    elsif stat < 12
      0
    elsif stat < 14
      1
    elsif stat < 16
      2
    elsif stat < 18
      3
    elsif stat < 20
      4
    elsif stat < 22
      5
    elsif stat < 24
      6
    elsif stat < 26
      7
    elsif stat < 28
      8
    else
      puts "error: str must be between 0 and 30"
    end
  end

  def proficiency(level)
    if level < 5
      2
    elsif level < 9
      3
    elsif level < 13
      4
    elsif level < 17
      5
    else
      6
    end
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
    proficiency_options = []
    proficiency_options = case character_class
                          when "Barbarian"
                            [
                              Proficiencies::ANIMAL_HANDLING,
                              Proficiencies::ATHLETICS,
                              Proficiencies::INTIMIDATION,
                              Proficiencies::NATURE,
                              Proficiencies::PERCEPTION,
                              Proficiencies::SURVIVAL,
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
                              Proficiencies::PERSUASION,
                            ]
                          when "Cleric"
                            [
                              Proficiencies::HISTORY,
                              Proficiencies::INSIGHT,
                              Proficiencies::MEDICINE,
                              Proficiencies::PERSUASION,
                              Proficiencies::RELIGION,
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
                              Proficiencies::SURVIVAL,
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
                              Proficiencies::SURVIVAL,
                            ]
                          when "Monk"
                            [
                              Proficiencies::ACROBATICS,
                              Proficiencies::ATHLETICS,
                              Proficiencies::HISTORY,
                              Proficiencies::INSIGHT,
                              Proficiencies::RELIGION,
                              Proficiencies::STEALTH,
                            ]
                          when "Paladin"
                            [
                              Proficiencies::ATHLETICS,
                              Proficiencies::INSIGHT,
                              Proficiencies::INTIMIDATION,
                              Proficiencies::MEDICINE,
                              Proficiencies::PERSUASION,
                              Proficiencies::RELIGION,
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
                              Proficiencies::SURVIVAL,
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
                              Proficiencies::STEALTH,
                            ]
                          when "Sorcerer"
                            [
                              Proficiencies::ARCANA,
                              Proficiencies::DECEPTION,
                              Proficiencies::INSIGHT,
                              Proficiencies::INTIMIDATION,
                              Proficiencies::PERSUASION,
                              Proficiencies::RELIGION,
                            ]
                          when "Warlock"
                            [
                              Proficiencies::ARCANA,
                              Proficiencies::DECEPTION,
                              Proficiencies::HISTORY,
                              Proficiencies::INTIMIDATION,
                              Proficiencies::INVESTIGATION,
                              Proficiencies::NATURE,
                              Proficiencies::RELIGION,
                            ]
                          when "Wizard"
                            [
                              Proficiencies::ARCANA,
                              Proficiencies::HISTORY,
                              Proficiencies::INSIGHT,
                              Proficiencies::INVESTIGATION,
                              Proficiencies::MEDICINE,
                              Proficiencies::NATURE,
                              Proficiencies::RELIGION,
                            ]
                          else
                            []
                          end
  end

  def profpicker
    tempprof = %w[
      athletics
      acrobatics
      sleight_of_hand
      stealth
      arcana
      history
      investigation
      nature
      religion
      animal_handling
      insight
      medicine
      perception
      survival
      deception
      intimidation
      performance
      persuasion
    ]

    puts "These are your stats: "
    (0...19).each do |n|
      puts $prof[n]
    end

    puts "Which skill would you like to choose as your first proficiency (case sensitive)"
    while $prof[19].nil?
      proficiency1 = get_input($prof.compact.first).chomp
      puts proficiency1
      if proficiency1.nil? || tempprof.include?(proficiency1) == false
        puts "please select one of the offered skills (case sensitive)"
      elsif tempprof.include?(proficiency1) == true
        $prof[19] = proficiency1
        (0...18).each do |n|
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
    while $prof[20].nil?
      proficiency2 = get_input($prof.compact.first).chomp
      if proficiency2.nil? || tempprof.include?(proficiency2) == false
        puts "please select one of the offered skills (case sensitive)"
      elsif tempprof.include?(proficiency2) == true
        $prof[20] = proficiency2
        (0...18).each do |n|
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
    while $prof[21].nil?
      proficiency3 = get_input($prof.compact.first).chomp
      if proficiency3.nil? || tempprof.include?(proficiency3) == false
        puts "please select one of the offered skills (case sensitive)"
      elsif tempprof.include?(proficiency3) == true
        $prof[21] = proficiency3
        (0...18).each do |n|
          if tempprof[n] == proficiency3
            tempprof[n] = nil
            break n
          end
        end
      end
    end
  end

  def speciespick
    species = %w[
      Dragonborn
      Dwarf
      Elf
      Gnome
      Goliath
      Halfling
      Human
      Orc
      Tiefling
    ]
    puts species
    puts "What species is your character? "
    species_choice = ""
    while species.include?(species_choice) == false
      species_choice = get_input(species.first).split(/ |_|-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless species.include?(species_choice) == true
    end
    species_choice
  end

  def skillpopulator
    {
      "athletics" => 0,
      "acrobatics" => 0,
      "sleight of hand" => 0,
      "stealth" => 0,
      "arcana" => 0,
      "history" => 0,
      "investigation" => 0,
      "nature" => 0,
      "religion" => 0,
      "animal handling" => 0,
      "insight" => 0,
      "medicine" => 0,
      "perception" => 0,
      "survival" => 0,
      "deception" => 0,
      "intimidation" => 0,
      "performance" => 0,
      "persuasion" => 0,
    }
  end

  def statpick(stats)
    loop do
      finalstats = []
      puts "These are your stats: "
      (0...6).each do |n|
        puts stats[n]
      end

      puts "Which number would you like to be your Strength stat? "

      while finalstats[0].nil?
        strength = get_input(stats.compact.first).to_i
        if strength.nil? || stats.include?(strength) == false
          puts "Please select one of the available numbers"
        elsif stats.include?(strength) == true
          finalstats[0] = strength
          (0...6).each do |n|
            if stats[n] == strength
              stats[n] = nil
              break n
            end
          end
        end
      end

      puts "These are your remaining stats: "
      stats.compact!
      puts stats

      puts "Which number would you like to be your Dexterity stat? "

      while finalstats[1].nil?
        dexterity = get_input(stats.compact.first).to_i
        if dexterity.nil? || stats.include?(dexterity) == false
          puts "Please select one of the available numbers"
        elsif stats.include?(dexterity) == true
          finalstats[1] = dexterity
          (0...6).each do |n|
            if stats[n] == dexterity
              stats[n] = nil
              break n
            end
          end
        end
      end

      puts "These are your remaining stats: "
      stats.compact!
      puts stats

      puts "Which number would you like to be your Constitution stat? "

      while finalstats[2].nil?
        constitution = get_input(stats.compact.first).to_i
        if constitution.nil? || stats.include?(constitution) == false
          puts "Please select one of the available numbers"
        elsif stats.include?(constitution) == true
          finalstats[2] = constitution
          (0...6).each do |n|
            if stats[n] == constitution
              stats[n] = nil
              break n
            end
          end
        end
      end

      puts "These are your remaining stats: "
      stats.compact!
      puts stats

      puts "Which number would you like to be your Intelligence stat? "

      while finalstats[3].nil?
        intelligence = get_input(stats.compact.first).to_i
        if intelligence.nil? || stats.include?(intelligence) == false
          puts "Please select one of the available numbers"
        elsif stats.include?(intelligence) == true
          finalstats[3] = intelligence
          (0...6).each do |n|
            if stats[n] == intelligence
              stats[n] = nil
              break n
            end
          end
        end
      end

      puts "These are your remaining stats: "
      stats.compact!
      puts stats

      puts "Which number would you like to be your Wisdom stat? "

      while finalstats[4].nil?
        wisdom = get_input(stats.compact.first).to_i
        if wisdom.nil? || stats.include?(wisdom) == false
          puts "Please select one of the available numbers"
        elsif stats.include?(wisdom) == true
          finalstats[4] = wisdom
          (0...6).each do |n|
            if stats[n] == wisdom
              stats[n] = nil
              break n
            end
          end
        end
      end

      (0...6).each do |n|
        unless stats[n].nil?
          finalstats[5] = stats[n]
        end
      end

      puts "So your stats are  Strength: #{finalstats[0]}, Dexteriy: #{finalstats[1]}, Constitution: #{finalstats[2]},
    Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until %w[y n].include?(finish)
        finish = get_input("y").chomp
        next unless finish == "n"

        (0...6).each do |n|
          stats[n] = finalstats[n]
          finalstats[n] = nil
        end
        puts "Please select y to complete this process or n to start over"
      end

      return finalstats if finish == "y"
    end
  end

  def statroll
    dice = []
    stats = []
    (0...6).each do |n|
      (0...4).each do |m|
        dice[m] = (rand * 6).ceil
      end
      stats[n] = dice[0...4].reduce(0, :+) - dice[0...4].min
    end
    stats
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $PROGRAM_NAME
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
    charname,
    level,
    species,
    charclass,
    background,
    str,
    strmod,
    dex,
    dexmod,
    con,
    conmod,
    int,
    intmod,
    wis,
    wismod,
    cha,
    chamod,
    10 + dexmod,
    prof,
    hitpoints,
    skills
  )

  puts "\n#{"=" * 40}"
  puts "Character Created!"
  puts "=" * 40
  puts $charstats.context
end
