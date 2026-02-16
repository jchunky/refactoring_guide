require "active_support/all"

def get_input(default)
  puts default
  default
end

def hitpointcalculator(char_class, level, con)
  base_hp = { "Barbarian" => [12, 7], "Fighter" => [10, 6], "Paladin" => [10, 6], "Ranger" => [10, 6],
              "Bard" => [8, 5], "Cleric" => [8, 5], "Druid" => [8, 5], "Monk" => [8, 5],
              "Rogue" => [8, 5], "Warlock" => [8, 5], "Sorcerer" => [6, 4], "Wizard" => [6, 4] }
  hp = base_hp[char_class.chomp]
  hp ? hp[0] + con + (level * (hp[1] + con)) : nil
end

def armorcalc
  $charstats.ac = 10 + $charstats.dexmod if $charstats
end

def backgroundpick
  backgrounds = ["Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Gladiator",
                 "Guild Artisan", "Guild Merchant", "Hermit", "Knight", "Noble", "Outlander",
                 "Pirate", "Sage", "Sailor", "Soldier", "Spy", "Urchin"]
  puts backgrounds
  puts "What race is your character? "
  get_input(backgrounds.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
end

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
    instance_variables.map { |attr| { attr => instance_variable_get(attr) } }
  end
end

def classpick
  classes = %w[Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard]
  puts classes
  puts "What class is your character? "
  get_input(classes.first).capitalize.chomp
end

class Ranger
  attr_accessor :damage, :chancetohit, :armor, :weapon
end

def my_modcalc(stat)
  (stat - 10) / 2
end

def proficiency(level)
  2 + (level - 1) / 4
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

PROFICIENCY_OPTIONS = {
  "Barbarian" => [Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION,
                  Proficiencies::NATURE, Proficiencies::PERCEPTION, Proficiencies::SURVIVAL],
  "Bard" => Proficiencies.constants.map { |c| Proficiencies.const_get(c) }.compact,
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

def proficiency_by_class(character_class)
  PROFICIENCY_OPTIONS[character_class] || []
end

def profpicker
  tempprof = %w[athletics acrobatics sleight_of_hand stealth arcana history investigation nature religion
                animal_handling insight medicine perception survival deception intimidation performance persuasion]

  puts "These are your stats: "
  $prof[0...19].each { |p| puts p }

  3.times do |i|
    puts "Which skill would you like to choose as proficiency #{i + 1}? (case sensitive)"
    choice = get_input($prof.compact.first).chomp
    if tempprof.include?(choice)
      $prof[19 + i] = choice
      tempprof.delete(choice)
    end
  end
end

def racepick
  races = ["Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Lightfoot Halfling", "Stout Halfling",
           "Human", "Human Variant", "Dragonborn", "Rock Gnome", "Forest Gnome", "Half Elf",
           "Half Orc", "Tiefling"]
  puts races
  puts "What race is your character? "
  get_input(races.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
end

def skillpopulator
  %w[athletics acrobatics sleight\ of\ hand stealth arcana history investigation nature religion
     animal\ handling insight medicine perception survival deception intimidation performance persuasion]
    .to_h { |skill| [skill, 0] }
end

def statpick(stats)
  finalstats = []
  stat_names = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma]

  stat_names.each_with_index do |name, i|
    puts "These are your stats: #{stats.compact.join(', ')}"
    puts "Which number would you like to be your #{name} stat? "
    choice = get_input(stats.compact.first).to_i
    if stats.include?(choice)
      finalstats[i] = choice
      stats[stats.index(choice)] = nil
    end
  end

  finalstats[5] = stats.compact.first if finalstats[5].nil?

  puts "So your stats are #{stat_names.zip(finalstats).map { |n, v| "#{n}: #{v}" }.join(', ')}"
  puts "Are you satisfied with this? (y/n)"
  finalstats
end

def statroll
  6.times.map do
    dice = 4.times.map { rand(1..6) }
    dice.sum - dice.min
  end
end
