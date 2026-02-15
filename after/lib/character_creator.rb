require "active_support/all"

def get_input(default)
  puts default
  default
  # gets
end

def hitpointcalculator(char_class, level, con)
  return 12 + con + (level * (7 + con)) if ["Barbarian"].include?(char_class.chomp)
  return 10 + con + (level * (6 + con)) if ["Fighter", "Paladin", "Ranger"].include?(char_class.chomp)
  return 8 + con + (level * (5 + con)) if ["Bard", "Cleric", "Druid", "Monk", "Rogue", "Warlock"].include?(char_class.chomp)
  return 6 + con + (level * (4 + con)) if ["Sorcerer", "Wizard"].include?(char_class.chomp)
end

# Artificer = d8

def armorcalc
  armor = nil
  #no armor
  if armor == nil
    $charstats.ac = 10 + $charstats.dexmod
  elsif armor != nil

  end
end



def backgroundpick
  backgrounds = ["Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Gladiator",
           "Guild Artisan", "Guild Merchant", "Hermit", "Knight", "Noble", "Outlander",
           "Pirate", "Sage", "Sailor", "Soldier", "Spy", "Urchin"]
  puts backgrounds
  puts "What race is your character? "
  background_choice = ""
  while backgrounds.include?(background_choice) == false
    background_choice = get_input(backgrounds.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
    puts "please select an option from the list" unless backgrounds.include?(background_choice) == true
  end
  return background_choice
end

class DnDchars

  attr_accessor :charname
  attr_accessor :level
  attr_accessor :race
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

  def initialize(charname, level, race, class_of_char, background, str, strmod, dex, dexmod, con, conmod, int, intmod,
                 wis, wismod, cha, chamod, ac, prof, hitpoints, skills
  )
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
    self.instance_variables.map do |attribute|
      { attribute => self.instance_variable_get(attribute)}
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
    puts "please select an option from the list" unless classes.include?(charclass) == true
  end
  return charclass
end


class Ranger

  attr_accessor :damage
  attr_accessor :chancetohit
  attr_accessor :armor
  attr_accessor :weapon



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
  case character_class
  when "Barbarian"
    proficiency_options = [
        Proficiencies::ANIMAL_HANDLING,
        Proficiencies::ATHLETICS,
        Proficiencies::INTIMIDATION,
        Proficiencies::NATURE,
        Proficiencies::PERCEPTION,
        Proficiencies::SURVIVAL
    ]
  when "Bard"
    proficiency_options = [
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
    proficiency_options = [
        Proficiencies::HISTORY,
        Proficiencies::INSIGHT,
        Proficiencies::MEDICINE,
        Proficiencies::PERSUASION,
        Proficiencies::RELIGION
       ]
  when "Druid"
    proficiency_options = [
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
    proficiency_options = [
        Proficiencies::ACROBATICS,
        Proficiencies::ANIMAL_HANDLING,
        Proficiencies::ATHLETICS,
        Proficiencies::HISTORY,
        Proficiencies::INSIGHT,
        Proficiencies::INTIMIDATION,
        Proficiencies::PERCEPTION,
        Proficiencies::SURVIVAL
    ]
  when "Monk"
    proficiency_options = [
        Proficiencies::ACROBATICS,
        Proficiencies::ATHLETICS,
        Proficiencies::HISTORY,
        Proficiencies::INSIGHT,
        Proficiencies::RELIGION,
        Proficiencies::STEALTH
    ]
  when "Paladin"
    proficiency_options = [
        Proficiencies::ATHLETICS,
        Proficiencies::INSIGHT,
        Proficiencies::INTIMIDATION,
        Proficiencies::MEDICINE,
        Proficiencies::PERSUASION,
        Proficiencies::RELIGION
    ]
  when "Ranger"
    proficiency_options = [
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
    proficiency_options = [
        Proficiencies::ACROBATICS,
        Proficiencies::ATHLETICS,
        Proficiencies::DECEPTION,
        Proficiencies::INSIGHT,
        Proficiencies::INTIMIDATION,
        Proficiencies::INVESTIGATION,
        Proficiencies::PERCEPTION,
        Proficiencies::PERFORMANCE,
        Proficiencies::PERSUASION,
        Proficiencies::SLEIGHT_OF_HAND,
        Proficiencies::STEALTH
    ]
  when "Sorcerer"
    proficiency_options = [
        Proficiencies::ARCANA,
        Proficiencies::DECEPTION,
        Proficiencies::INSIGHT,
        Proficiencies::INTIMIDATION,
        Proficiencies::PERSUASION,
        Proficiencies::RELIGION
    ]
  when "Warlock"
    proficiency_options = [
        Proficiencies::ARCANA,
        Proficiencies::DECEPTION,
        Proficiencies::HISTORY,
        Proficiencies::INTIMIDATION,
        Proficiencies::INVESTIGATION,
        Proficiencies::NATURE,
        Proficiencies::RELIGION
    ]
  when "Wizard"
    proficiency_options = [
        Proficiencies::ARCANA,
        Proficiencies::HISTORY,
        Proficiencies::INSIGHT,
        Proficiencies::INVESTIGATION,
        Proficiencies::MEDICINE,
        Proficiencies::RELIGION
    ]
  else
    proficiency_options = []
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

  puts "Which skill would you like to choose as your first proficiency (case sensitive)"
  while $prof[19] == nil
    proficiency1 = get_input($prof.compact.first).chomp
    puts proficiency1
    if proficiency1 == nil || tempprof.include?(proficiency1) == false
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
    if proficiency2 == nil || tempprof.include?(proficiency2) == false
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
    if proficiency3 == nil || tempprof.include?(proficiency3) == false
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


def racepick
  races = ["Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Lightfoot Halfling", "Stout Halfling",
           "Human", "Human Variant", "Dragonborn", "Rock Gnome", "Forest Gnome", "Half Elf",
           "Half Orc", "Tiefling"]
  puts races
  puts "What race is your character? "
  race_choice = ""
  while races.include?(race_choice) == false
    race_choice = get_input(races.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
    puts "please select an option from the list" unless races.include?(race_choice) == true
  end
  return race_choice
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
  return skillhash
  end


def statpick(stats)

  loop do
  finalstats = []
  puts "These are your stats: "
  for n in 0...6
    puts stats[n]
  end

  puts "Which number would you like to be your Strength stat? "

  while finalstats[0] == nil
    strength = get_input(stats.compact.first).to_i
    if strength == nil || stats.include?(strength) == false
      puts "Please select one of the available numbers"
    elsif stats.include?(strength) == true
      finalstats[0] = strength
      for n in 0...6
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

  while finalstats[1] == nil
    dexterity = get_input(stats.compact.first).to_i
    if dexterity == nil ||stats.include?(dexterity) == false
      puts "Please select one of the available numbers"
    elsif stats.include?(dexterity) == true
      finalstats[1] = dexterity
      for n in 0...6
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

  while finalstats[2] == nil
    constitution = get_input(stats.compact.first).to_i
    if constitution == nil ||stats.include?(constitution) == false
      puts "Please select one of the available numbers"
    elsif stats.include?(constitution) == true
      finalstats[2] = constitution
      for n in 0...6
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

  while finalstats[3] == nil
    intelligence = get_input(stats.compact.first).to_i
    if intelligence == nil ||stats.include?(intelligence) == false
      puts "Please select one of the available numbers"
    elsif stats.include?(intelligence) == true
      finalstats[3] = intelligence
      for n in 0...6
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

  while finalstats[4] == nil
      wisdom = get_input(stats.compact.first).to_i
    if wisdom == nil ||stats.include?(wisdom) == false
      puts "Please select one of the available numbers"
    elsif stats.include?(wisdom) == true
      finalstats[4] = wisdom
      for n in 0...6
        if stats[n] == wisdom
          stats[n] = nil
          break n
        end
      end
    end
  end

  for n in 0...6
    if stats[n] != nil
    finalstats[5] = stats[n]
    end
  end

  puts "So your stats are  Strength: #{finalstats[0]}, Dexteriy: #{finalstats[1]}, Constitution: #{finalstats[2]},
  Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

  puts "Are you satisfied with this? (y/n)"
  finish = ""
  until finish == "y" || finish == "n"
  finish = get_input("y").chomp
    if finish == "n"
      for n in 0...6
        stats[n] = finalstats[n]
        finalstats[n] = nil
      end

    elsif finish == "y"
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
    stats[n] = dice[0...4].inject(0,:+) - dice[0...4].min
  end
  return stats
end
