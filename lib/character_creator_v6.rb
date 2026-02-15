require "active_support/all"

def get_input(default)
  puts default
  default
end

# Polymorphic character classes for hit point calculation
class CharacterClass
  def self.for(class_name)
    CLASS_TYPES.fetch(class_name.to_s.chomp, BaseClass).new
  end

  def hit_die = 8
  def hitpoints(level, con) = hit_die + con + (level * (hit_die / 2 + 1 + con))
end

class BarbarianClass < CharacterClass
  def hit_die = 12
end

class FighterClass < CharacterClass
  def hit_die = 10
end

class PaladinClass < CharacterClass
  def hit_die = 10
end

class RangerClass < CharacterClass
  def hit_die = 10
end

class SorcererClass < CharacterClass
  def hit_die = 6
end

class WizardClass < CharacterClass
  def hit_die = 6
end

class BaseClass < CharacterClass
end

CLASS_TYPES = {
  "Barbarian" => BarbarianClass,
  "Fighter" => FighterClass,
  "Paladin" => PaladinClass,
  "Ranger" => RangerClass,
  "Bard" => BaseClass,
  "Cleric" => BaseClass,
  "Druid" => BaseClass,
  "Monk" => BaseClass,
  "Rogue" => BaseClass,
  "Warlock" => BaseClass,
  "Sorcerer" => SorcererClass,
  "Wizard" => WizardClass
}.freeze

def hitpointcalculator(char_class, level, con)
  CharacterClass.for(char_class).hitpoints(level, con)
end

# Stat modifier calculation - using lookup
class ModifierCalculator
  def self.calculate(stat)
    (stat - 10) / 2
  end
end

def my_modcalc(stat)
  return puts "error: str must be between 0 and 30" if stat >= 28
  ModifierCalculator.calculate(stat)
end

def proficiency(level)
  2 + (level - 1) / 4
end

# Character data class
class DnDchars
  ATTRIBUTES = %i[
    charname level race class_of_char background
    str strmod dex dexmod con conmod int intmod wis wismod cha chamod
    ac prof hitpoints skills
  ].freeze

  attr_accessor(*ATTRIBUTES)

  def initialize(attrs = {})
    ATTRIBUTES.each { |attr| send("#{attr}=", attrs[attr]) }
  end

  def context
    instance_variables.map { |attr| { attr => instance_variable_get(attr) } }
  end
end

class Ranger
  attr_accessor :damage, :chancetohit, :armor, :weapon
end

# Picker classes for selections
class ListPicker
  def initialize(items, prompt)
    @items = items
    @prompt = prompt
  end

  def pick
    display_options
    get_valid_selection
  end

  private

  def display_options
    puts @items
    puts @prompt
  end

  def get_valid_selection
    loop do
      choice = normalize_input(get_input(@items.first))
      return choice if @items.include?(choice)
      puts "please select an option from the list"
    end
  end

  def normalize_input(input)
    input.to_s.split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
  end
end

def racepick
  races = ["Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Lightfoot Halfling", "Stout Halfling",
           "Human", "Human Variant", "Dragonborn", "Rock Gnome", "Forest Gnome", "Half Elf",
           "Half Orc", "Tiefling"]
  ListPicker.new(races, "What race is your character? ").pick
end

def classpick
  classes = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue",
             "Sorcerer", "Warlock", "Wizard"]
  ListPicker.new(classes, "What class is your character? ").pick
end

def backgroundpick
  backgrounds = ["Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Gladiator",
                 "Guild Artisan", "Guild Merchant", "Hermit", "Knight", "Noble", "Outlander",
                 "Pirate", "Sage", "Sailor", "Soldier", "Spy", "Urchin"]
  ListPicker.new(backgrounds, "What race is your character? ").pick
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

  ALL = [ATHLETICS, ACROBATICS, SLEIGHT_OF_HAND, STEALTH, ARCANA, HISTORY, INVESTIGATION,
         NATURE, RELIGION, ANIMAL_HANDLING, INSIGHT, MEDICINE, PERCEPTION, SURVIVAL,
         DECEPTION, INTIMIDATION, PERFORMANCE, PERSUASION].freeze
end

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

def proficiency_by_class(character_class)
  CLASS_PROFICIENCIES.fetch(character_class, [])
end

def skillpopulator
  Proficiencies::ALL.each_with_object({}) { |skill, h| h[skill] = 0 }
end

class StatRoller
  def self.roll
    6.times.map { roll_stat }
  end

  def self.roll_stat
    dice = 4.times.map { rand(1..6) }
    dice.sum - dice.min
  end
end

def statroll
  StatRoller.roll
end

class StatPicker
  STAT_NAMES = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"].freeze

  def initialize(stats)
    @stats = stats.dup
    @final_stats = []
  end

  def pick
    loop do
      pick_all_stats
      return @final_stats if confirm_stats?
      reset_stats
    end
  end

  private

  def pick_all_stats
    STAT_NAMES[0..4].each { |name| pick_stat(name) }
    @final_stats << @stats.compact.first
  end

  def pick_stat(stat_name)
    display_remaining_stats
    puts "Which number would you like to be your #{stat_name} stat? "
    assign_stat(stat_name)
  end

  def assign_stat(stat_name)
    loop do
      value = get_input(@stats.compact.first).to_i
      return use_stat(value) if @stats.include?(value)
      puts "Please select one of the available numbers"
    end
  end

  def use_stat(value)
    @final_stats << value
    @stats[@stats.index(value)] = nil
    @stats.compact!
  end

  def display_remaining_stats
    puts "These are your stats: "
    puts @stats.compact
  end

  def confirm_stats?
    display_final_stats
    puts "Are you satisfied with this? (y/n)"
    get_input("y").chomp == "y"
  end

  def display_final_stats
    puts "So your stats are Strength: #{@final_stats[0]}, Dexterity: #{@final_stats[1]}, " \
         "Constitution: #{@final_stats[2]}, Intelligence: #{@final_stats[3]}, " \
         "Wisdom: #{@final_stats[4]}, and Charisma: #{@final_stats[5]}"
  end

  def reset_stats
    @stats = @final_stats.dup
    @final_stats = []
  end
end

def statpick(stats)
  StatPicker.new(stats).pick
end

def armorcalc
  $charstats.ac = 10 + $charstats.dexmod if armor.nil?
end

def profpicker
  puts "These are your stats: "
  $prof[0...19].each { |p| puts p }
  3.times { |i| pick_proficiency(i + 1) }
end

def pick_proficiency(number)
  puts "Which skill would you like to choose as proficiency ##{number} (case sensitive)"
  loop do
    choice = get_input($prof.compact.first).chomp
    return assign_proficiency(choice, number) if valid_proficiency?(choice)
    puts "please select one of the offered skills (case sensitive)"
  end
end

def valid_proficiency?(choice)
  Proficiencies::ALL.include?(choice)
end

def assign_proficiency(choice, number)
  $prof[18 + number] = choice
end
