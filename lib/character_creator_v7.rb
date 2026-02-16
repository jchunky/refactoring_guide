require "active_support/all"

def get_input(default)
  puts default
  default
end

HIT_DICE = {
  "Barbarian" => 12,
  "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
  "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
  "Sorcerer" => 6, "Wizard" => 6
}.freeze

def hitpointcalculator(char_class, level, con)
  die = HIT_DICE[char_class.chomp]
  return nil unless die
  die + con + (level * (die / 2 + 1 + con))
end

CLASSES = %w[Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard].freeze

RACES = [
  "Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Lightfoot Halfling",
  "Stout Halfling", "Human", "Human Variant", "Dragonborn", "Rock Gnome",
  "Forest Gnome", "Half Elf", "Half Orc", "Tiefling"
].freeze

BACKGROUNDS = [
  "Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Gladiator",
  "Guild Artisan", "Guild Merchant", "Hermit", "Knight", "Noble", "Outlander",
  "Pirate", "Sage", "Sailor", "Soldier", "Spy", "Urchin"
].freeze

SKILLS = %w[
  athletics acrobatics sleight_of_hand stealth arcana history investigation nature
  religion animal_handling insight medicine perception survival deception
  intimidation performance persuasion
].freeze

module Proficiencies
  SKILLS.each { |skill| const_set(skill.upcase, skill.tr('_', ' ')) }
  NIL = nil
end

CLASS_PROFICIENCIES = {
  "Barbarian" => %i[animal_handling athletics intimidation nature perception survival],
  "Bard" => SKILLS.map(&:to_sym),
  "Cleric" => %i[history insight medicine persuasion religion],
  "Druid" => %i[arcana animal_handling insight medicine nature perception religion survival],
  "Fighter" => %i[acrobatics animal_handling athletics history insight intimidation perception survival],
  "Monk" => %i[acrobatics athletics history insight religion stealth],
  "Paladin" => %i[athletics insight intimidation medicine persuasion religion],
  "Ranger" => %i[animal_handling athletics insight investigation nature perception stealth survival],
  "Rogue" => %i[acrobatics athletics deception insight intimidation investigation perception performance persuasion sleight_of_hand stealth],
  "Sorcerer" => %i[arcana deception insight intimidation persuasion religion],
  "Warlock" => %i[arcana deception history intimidation investigation nature religion],
  "Wizard" => %i[arcana history insight investigation medicine religion]
}.freeze

def proficiency_by_class(character_class)
  CLASS_PROFICIENCIES[character_class]&.map { |s| Proficiencies.const_get(s.to_s.upcase) } || []
end

def my_modcalc(stat)
  return "error: str must be between 0 and 30" if stat < 0 || stat >= 30
  (stat - 10) / 2
end

def proficiency(level)
  ((level - 1) / 4) + 2
end

class DnDchars
  ATTRIBUTES = %i[
    charname level race class_of_char background
    str strmod dex dexmod con conmod int intmod wis wismod cha chamod
    ac prof hitpoints skills
  ].freeze

  attr_accessor(*ATTRIBUTES)

  def initialize(**attrs)
    ATTRIBUTES.each { |attr| instance_variable_set("@#{attr}", attrs[attr]) }
  end

  def context
    instance_variables.map { |attr| { attr => instance_variable_get(attr) } }
  end
end

class Ranger
  attr_accessor :damage, :chancetohit, :armor, :weapon
end

def pick_from_list(options, prompt)
  puts options
  puts prompt
  choice = ""
  until options.include?(choice)
    choice = get_input(options.first).split(/[ _-]/).map(&:capitalize).join(" ").chomp
    puts "please select an option from the list" unless options.include?(choice)
  end
  choice
end

def classpick
  pick_from_list(CLASSES, "What class is your character? ")
end

def racepick
  pick_from_list(RACES, "What race is your character? ")
end

def backgroundpick
  pick_from_list(BACKGROUNDS, "What race is your character? ")
end

def skillpopulator
  SKILLS.map { |s| [s.tr('_', ' '), 0] }.to_h
end

def statroll
  Array.new(6) do
    rolls = Array.new(4) { rand(1..6) }
    rolls.sum - rolls.min
  end
end

def statpick(stats)
  stat_names = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma]
  finalstats = []

  loop do
    remaining = stats.dup
    finalstats = []

    stat_names[0..4].each do |name|
      puts "These are your remaining stats: #{remaining.compact}"
      puts "Which number would you like to be your #{name} stat? "

      stat = nil
      until stat
        stat = get_input(remaining.compact.first).to_i
        if remaining.include?(stat)
          finalstats << stat
          remaining[remaining.index(stat)] = nil
        else
          puts "Please select one of the available numbers"
          stat = nil
        end
      end
    end

    finalstats << remaining.compact.first

    puts "So your stats are #{stat_names.zip(finalstats).map { |n, v| "#{n}: #{v}" }.join(', ')}"
    puts "Are you satisfied with this? (y/n)"

    finish = get_input("y").chomp
    return finalstats if finish == "y"
  end
end

def armorcalc
  # placeholder for armor calculation
end

def profpicker
  # placeholder for proficiency picker
end
