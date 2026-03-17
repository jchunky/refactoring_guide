module CharacterCreatorKata
  def get_input(default)
    puts default
    default
    # gets
  end

  def hitpointcalculator(char_class, level, con)
    hit_die = case char_class.chomp
              when "Barbarian" then 12
              when "Fighter", "Paladin", "Ranger" then 10
              when "Bard", "Cleric", "Druid", "Monk", "Rogue", "Warlock" then 8
              when "Sorcerer", "Wizard" then 6
              end
    return nil unless hit_die

    avg_roll = hit_die / 2 + 1
    hit_die + con + (level * (avg_roll + con))
  end

  # Artificer = d8

  def armorcalc
    armor = nil
    if armor == nil
      $charstats.ac = 10 + $charstats.dexmod
    elsif armor != nil

    end
  end

  def backgroundpick
    backgrounds = ["Acolyte", "Criminal", "Sage", "Soldier"]
    puts backgrounds
    puts "What species is your character? "
    background_choice = ""
    while backgrounds.include?(background_choice) == false
      background_choice = get_input(backgrounds.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless backgrounds.include?(background_choice)
    end
    background_choice
  end

  def background_bonuses(background)
    case background
    when "Acolyte"
      {
        ability_bonuses: ["Intelligence", "Wisdom", "Charisma"],
        skill_proficiencies: [Proficiencies::INSIGHT, Proficiencies::RELIGION]
      }
    when "Criminal"
      {
        ability_bonuses: ["Dexterity", "Constitution", "Intelligence"],
        skill_proficiencies: [Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH]
      }
    when "Sage"
      {
        ability_bonuses: ["Constitution", "Intelligence", "Wisdom"],
        skill_proficiencies: [Proficiencies::ARCANA, Proficiencies::HISTORY]
      }
    when "Soldier"
      {
        ability_bonuses: ["Strength", "Dexterity", "Constitution"],
        skill_proficiencies: [Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION]
      }
    else
      {
        ability_bonuses: [],
        skill_proficiencies: []
      }
    end
  end

  class DnDchars
    attr_accessor :charname, :level, :species, :class_of_char, :background,
                  :str, :strmod, :dex, :dexmod, :con, :conmod,
                  :int, :intmod, :wis, :wismod, :cha, :chamod,
                  :ac, :prof, :hitpoints, :skills

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
    classes = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue",
               "Sorcerer", "Warlock", "Wizard"]
    puts classes
    puts "What class is your character? "
    charclass = ""
    while classes.include?(charclass) == false
      charclass = get_input(classes.first).capitalize.chomp
      puts "please select an option from the list" unless classes.include?(charclass)
    end
    charclass
  end

  class Ranger
    attr_accessor :damage, :chancetohit, :armor, :weapon
  end

  def my_modcalc(stat)
    if stat < 0 || stat >= 28
      puts "error: str must be between 0 and 30"
      return nil
    end
    (stat - 10) / 2
  end

  def proficiency(level)
    if level < 5 then 2
    elsif level < 9 then 3
    elsif level < 13 then 4
    elsif level < 17 then 5
    else 6
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

  def pick_proficiency_from_list(prof_array, available, slot_index, ordinal)
    puts "Which skill would you like to choose as your #{ordinal} proficiency (case sensitive)"
    while prof_array[slot_index].nil?
      choice = get_input(prof_array.compact.first).chomp
      puts choice
      if choice.nil? || !available.include?(choice)
        puts "please select one of the offered skills (case sensitive)"
      else
        prof_array[slot_index] = choice
        available.delete_at(available.index(choice))
      end
    end
  end

  def profpicker
    tempprof = ["athletics", "acrobatics", "sleight_of_hand", "stealth", "arcana", "history", "investigation", "nature", "religion",
                "animal_handling", "insight", "medicine", "perception", "survival", "deception", "intimidation", "performance",
                "persuasion"]

    puts "These are your stats: "
    for n in 0...19
      puts $prof[n]
    end

    pick_proficiency_from_list($prof, tempprof, 19, "first")

    puts "These are your remaining stats: "
    tempprof.compact!
    puts tempprof

    pick_proficiency_from_list($prof, tempprof, 20, "second")

    puts "These are your remaining stats: "
    tempprof.compact!
    puts tempprof

    pick_proficiency_from_list($prof, tempprof, 21, "third")
  end

  def speciespick
    species = ["Dragonborn", "Dwarf", "Elf", "Gnome", "Goliath", "Halfling",
               "Human", "Orc", "Tiefling"]
    puts species
    puts "What species is your character? "
    species_choice = ""
    while species.include?(species_choice) == false
      species_choice = get_input(species.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless species.include?(species_choice)
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
      "persuasion" => 0
    }
  end

  def pick_stat(stats, finalstats, index, stat_name, show_remaining: true)
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
    if show_remaining
      puts "These are your remaining stats: "
      stats.compact!
      puts stats
    end
  end

  def statpick(stats)
    loop do
      finalstats = []

      puts "These are your stats: "
      stats.each { |s| puts s }

      pick_stat(stats, finalstats, 0, "Strength")
      pick_stat(stats, finalstats, 1, "Dexterity")
      pick_stat(stats, finalstats, 2, "Constitution")
      pick_stat(stats, finalstats, 3, "Intelligence")
      pick_stat(stats, finalstats, 4, "Wisdom", show_remaining: false)

      finalstats[5] = stats.compact.first

      puts "So your stats are  Strength: #{finalstats[0]}, Dexteriy: #{finalstats[1]}, Constitution: #{finalstats[2]},
    Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until finish == "y" || finish == "n"
        finish = get_input("y").chomp
        if finish == "n"
          6.times do |n|
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

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata

  main
end
