module CharacterCreatorKata
  def get_input(default)
    puts default
    default
  end

  def hitpointcalculator(char_class, level, con)
    hit_die = hit_die_for(char_class)
    hit_die + con + (level * (hit_die / 2 + 1 + con))
  end

  def my_modcalc(stat)
    (stat - 10) / 2
  end

  def proficiency(level)
    (level - 1) / 4 + 2
  end

  def armorcalc
    $charstats.ac = 10 + $charstats.dexmod
  end

  def backgroundpick
    pick_from_list(
      ["Acolyte", "Criminal", "Sage", "Soldier"],
      "What species is your character? "
    )
  end

  def background_bonuses(background)
    BACKGROUND_DATA.fetch(background) do
      { ability_bonuses: [], skill_proficiencies: [] }
    end
  end

  def classpick
    pick_from_list(
      %w[Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard],
      "What class is your character? "
    )
  end

  def speciespick
    pick_from_list(
      %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling],
      "What species is your character? "
    )
  end

  def skillpopulator
    Proficiencies::ALL.each_with_object({}) { |skill, hash| hash[skill] = 0 }
  end

  def proficiency_by_class(character_class)
    CLASS_PROFICIENCIES.fetch(character_class, [])
  end

  def statroll
    [15, 14, 13, 12, 10, 8]
  end

  def statpick(stats)
    stat_names = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma]

    loop do
      available = stats.dup
      finalstats = []

      stat_names.first(5).each do |name|
        chosen = pick_stat(available, name)
        finalstats << chosen
        available.delete_at(available.index(chosen))
      end

      finalstats << available.first

      puts "So your stats are  Strength: #{finalstats[0]}, Dexteriy: #{finalstats[1]}, Constitution: #{finalstats[2]},
    Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until finish == "y" || finish == "n"
        finish = get_input("y").chomp
        puts "Please select y to complete this process or n to start over" unless %w[y n].include?(finish)
      end

      return finalstats if finish == "y"
    end
  end

  def profpicker
    tempprof = Proficiencies::ALL.map { |s| s.tr(" ", "_") }

    puts "These are your stats: "
    (0...19).each { |n| puts $prof[n] }

    3.times do |i|
      slot = 19 + i
      ordinal = %w[first second third][i]
      puts "Which skill would you like to choose as your #{ordinal} proficiency (case sensitive)"

      while $prof[slot].nil?
        choice = get_input($prof.compact.first).chomp
        puts choice if i == 0

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

  BACKGROUND_DATA = {
    "Acolyte" => {
      ability_bonuses: ["Intelligence", "Wisdom", "Charisma"],
      skill_proficiencies: [Proficiencies::INSIGHT, Proficiencies::RELIGION]
    },
    "Criminal" => {
      ability_bonuses: ["Dexterity", "Constitution", "Intelligence"],
      skill_proficiencies: [Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH]
    },
    "Sage" => {
      ability_bonuses: ["Constitution", "Intelligence", "Wisdom"],
      skill_proficiencies: [Proficiencies::ARCANA, Proficiencies::HISTORY]
    },
    "Soldier" => {
      ability_bonuses: ["Strength", "Dexterity", "Constitution"],
      skill_proficiencies: [Proficiencies::ATHLETICS, Proficiencies::INTIMIDATION]
    },
  }.freeze

  CLASS_PROFICIENCIES = {
    "Barbarian" => [Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS,
                    Proficiencies::INTIMIDATION, Proficiencies::NATURE,
                    Proficiencies::PERCEPTION, Proficiencies::SURVIVAL],
    "Bard" => [Proficiencies::ATHLETICS, Proficiencies::ACROBATICS,
               Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH,
               Proficiencies::ARCANA, Proficiencies::HISTORY,
               Proficiencies::INVESTIGATION, Proficiencies::NATURE,
               Proficiencies::RELIGION, Proficiencies::RELIGION,
               Proficiencies::ANIMAL_HANDLING, Proficiencies::INSIGHT,
               Proficiencies::MEDICINE, Proficiencies::PERCEPTION,
               Proficiencies::SURVIVAL, Proficiencies::DECEPTION,
               Proficiencies::INTIMIDATION, Proficiencies::PERFORMANCE,
               Proficiencies::PERSUASION],
    "Cleric" => [Proficiencies::HISTORY, Proficiencies::INSIGHT,
                 Proficiencies::MEDICINE, Proficiencies::PERSUASION,
                 Proficiencies::RELIGION],
    "Druid" => [Proficiencies::ARCANA, Proficiencies::ANIMAL_HANDLING,
                Proficiencies::INSIGHT, Proficiencies::MEDICINE,
                Proficiencies::NATURE, Proficiencies::PERCEPTION,
                Proficiencies::RELIGION, Proficiencies::SURVIVAL],
    "Fighter" => [Proficiencies::ACROBATICS, Proficiencies::ANIMAL_HANDLING,
                  Proficiencies::ATHLETICS, Proficiencies::HISTORY,
                  Proficiencies::INSIGHT, Proficiencies::INTIMIDATION,
                  Proficiencies::PERCEPTION, Proficiencies::PERSUASION,
                  Proficiencies::SURVIVAL],
    "Monk" => [Proficiencies::ACROBATICS, Proficiencies::ATHLETICS,
               Proficiencies::HISTORY, Proficiencies::INSIGHT,
               Proficiencies::RELIGION, Proficiencies::STEALTH],
    "Paladin" => [Proficiencies::ATHLETICS, Proficiencies::INSIGHT,
                  Proficiencies::INTIMIDATION, Proficiencies::MEDICINE,
                  Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Ranger" => [Proficiencies::ANIMAL_HANDLING, Proficiencies::ATHLETICS,
                 Proficiencies::INSIGHT, Proficiencies::INVESTIGATION,
                 Proficiencies::NATURE, Proficiencies::PERCEPTION,
                 Proficiencies::STEALTH, Proficiencies::SURVIVAL],
    "Rogue" => [Proficiencies::ACROBATICS, Proficiencies::ATHLETICS,
                Proficiencies::DECEPTION, Proficiencies::INSIGHT,
                Proficiencies::INTIMIDATION, Proficiencies::INVESTIGATION,
                Proficiencies::PERCEPTION, Proficiencies::PERSUASION,
                Proficiencies::SLEIGHT_OF_HAND, Proficiencies::STEALTH],
    "Sorcerer" => [Proficiencies::ARCANA, Proficiencies::DECEPTION,
                   Proficiencies::INSIGHT, Proficiencies::INTIMIDATION,
                   Proficiencies::PERSUASION, Proficiencies::RELIGION],
    "Warlock" => [Proficiencies::ARCANA, Proficiencies::DECEPTION,
                  Proficiencies::HISTORY, Proficiencies::INTIMIDATION,
                  Proficiencies::INVESTIGATION, Proficiencies::NATURE,
                  Proficiencies::RELIGION],
    "Wizard" => [Proficiencies::ARCANA, Proficiencies::HISTORY,
                 Proficiencies::INSIGHT, Proficiencies::INVESTIGATION,
                 Proficiencies::MEDICINE, Proficiencies::NATURE,
                 Proficiencies::RELIGION],
  }.freeze

  private

  HIT_DICE = {
    "Barbarian" => 12,
    "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
    "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8,
    "Rogue" => 8, "Warlock" => 8,
    "Sorcerer" => 6, "Wizard" => 6,
  }.freeze

  def hit_die_for(char_class)
    HIT_DICE.fetch(char_class.chomp)
  end

  def pick_from_list(options, prompt)
    puts options
    puts prompt
    choice = ""
    until options.include?(choice)
      choice = get_input(options.first).split(/ |\_|\-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless options.include?(choice)
    end
    choice
  end

  def pick_stat(available, stat_name)
    puts "These are your remaining stats: " unless stat_name == "Strength"
    puts available.compact if stat_name != "Strength"
    puts "These are your stats: " if stat_name == "Strength"
    available.each { |s| puts s } if stat_name == "Strength"

    puts "Which number would you like to be your #{stat_name} stat? "

    chosen = nil
    while chosen.nil?
      input = get_input(available.compact.first).to_i
      if input.nil? || !available.include?(input)
        puts "Please select one of the available numbers"
      else
        chosen = input
      end
    end
    chosen
  end
end

if __FILE__ == $0
  include CharacterCreatorKata
  main
end
