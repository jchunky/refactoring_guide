module CharacterCreatorKata
  def get_input(default)
    puts default
    default
    # gets
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
  end

  HIT_DICE = {
    "Barbarian" => 12,
    "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
    "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
    "Sorcerer" => 6, "Wizard" => 6
  }.freeze

  def hitpointcalculator(char_class, level, con)
    die = HIT_DICE[char_class]
    die + con + (level * (die / 2 + 1 + con))
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

  def backgroundpick
    pick_from_list(
      ["Acolyte", "Criminal", "Sage", "Soldier"],
      "What species is your character? "
    )
  end

  BACKGROUND_BONUSES = {
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

  DEFAULT_BACKGROUND_BONUS = { ability_bonuses: [], skill_proficiencies: [] }.freeze

  def background_bonuses(background)
    BACKGROUND_BONUSES.fetch(background, DEFAULT_BACKGROUND_BONUS)
  end

  class Character
    attr_accessor :charname, :level, :species, :class_of_char, :background,
                  :str, :strmod, :dex, :dexmod, :con, :conmod,
                  :int, :intmod, :wis, :wismod, :cha, :chamod,
                  :ac, :prof, :hitpoints, :skills

    def initialize(charname:, level:, species:, class_of_char:, background:,
                   str:, strmod:, dex:, dexmod:, con:, conmod:,
                   int:, intmod:, wis:, wismod:, cha:, chamod:,
                   ac:, prof:, hitpoints:, skills:)
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
    pick_from_list(
      ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue",
       "Sorcerer", "Warlock", "Wizard"],
      "What class is your character? "
    )
  end

  def my_modcalc(stat)
    (stat - 10) / 2
  end

  def proficiency(level)
    (level - 1) / 4 + 2
  end

  CLASS_PROFICIENCIES = {
    "Barbarian" => %w[animal\ handling athletics intimidation nature perception survival],
    "Bard"      => %w[athletics acrobatics sleight\ of\ hand stealth arcana history investigation
                      nature religion religion animal\ handling insight medicine perception survival
                      deception intimidation performance persuasion],
    "Cleric"    => %w[history insight medicine persuasion religion],
    "Druid"     => %w[arcana animal\ handling insight medicine nature perception religion survival],
    "Fighter"   => %w[acrobatics animal\ handling athletics history insight intimidation perception persuasion survival],
    "Monk"      => %w[acrobatics athletics history insight religion stealth],
    "Paladin"   => %w[athletics insight intimidation medicine persuasion religion],
    "Ranger"    => %w[animal\ handling athletics insight investigation nature perception stealth survival],
    "Rogue"     => %w[acrobatics athletics deception insight intimidation investigation perception persuasion sleight\ of\ hand stealth],
    "Sorcerer"  => %w[arcana deception insight intimidation persuasion religion],
    "Warlock"   => %w[arcana deception history intimidation investigation nature religion],
    "Wizard"    => %w[arcana history insight investigation medicine nature religion]
  }.freeze

  def proficiency_by_class(character_class)
    CLASS_PROFICIENCIES.fetch(character_class, [])
  end


  def pick_one_proficiency(available_skills, prof_list, slot, prompt)
    puts prompt
    while prof_list[slot].nil?
      choice = get_input(prof_list.compact.first).chomp
      puts choice if slot == 19
      if available_skills.include?(choice)
        prof_list[slot] = choice
        available_skills.delete_at(available_skills.index(choice))
      else
        puts "please select one of the offered skills (case sensitive)"
      end
    end
  end

  def profpicker
    available_skills = %w[athletics acrobatics sleight_of_hand stealth arcana history investigation nature religion
                          animal_handling insight medicine perception survival deception intimidation performance
                          persuasion]

    puts "These are your stats: "
    (0...19).each { |n| puts $prof[n] }

    prompts = [
      "Which skill would you like to choose as your first proficiency (case sensitive)",
      "Which skill would you like to choose as your second proficiency (case sensitive)",
      "Which skill would you like to choose as your second proficiency (case sensitive)"
    ]

    [19, 20, 21].each_with_index do |slot, i|
      pick_one_proficiency(available_skills, $prof, slot, prompts[i])

      if i < 2
        puts "These are your remaining stats: "
        puts available_skills
      end
    end
  end


  def speciespick
    pick_from_list(
      ["Dragonborn", "Dwarf", "Elf", "Gnome", "Goliath", "Halfling",
       "Human", "Orc", "Tiefling"],
      "What species is your character? "
    )
  end

  ALL_SKILLS = [
    Proficiencies::ATHLETICS, Proficiencies::ACROBATICS, Proficiencies::SLEIGHT_OF_HAND,
    Proficiencies::STEALTH, Proficiencies::ARCANA, Proficiencies::HISTORY,
    Proficiencies::INVESTIGATION, Proficiencies::NATURE, Proficiencies::RELIGION,
    Proficiencies::ANIMAL_HANDLING, Proficiencies::INSIGHT, Proficiencies::MEDICINE,
    Proficiencies::PERCEPTION, Proficiencies::SURVIVAL, Proficiencies::DECEPTION,
    Proficiencies::INTIMIDATION, Proficiencies::PERFORMANCE, Proficiencies::PERSUASION
  ].freeze

  def skillpopulator
    ALL_SKILLS.each_with_object({}) { |skill, hash| hash[skill] = 0 }
  end


  STAT_NAMES = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom"].freeze

  def pick_one_stat(stats, finalstats, index, stat_name)
    puts "Which number would you like to be your #{stat_name} stat? "

    while finalstats[index].nil?
      value = get_input(stats.compact.first).to_i
      if stats.include?(value)
        finalstats[index] = value
        stats[stats.index(value)] = nil
      else
        puts "Please select one of the available numbers"
      end
    end
  end

  def statpick(stats)
    loop do
      finalstats = []
      puts "These are your stats: "
      stats.each { |s| puts s }

      STAT_NAMES.each_with_index do |name, index|
        pick_one_stat(stats, finalstats, index, name)

        if index < STAT_NAMES.length - 1
          puts "These are your remaining stats: "
          stats.compact!
          puts stats
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

    $charstats = Character.new(
      charname: charname, level: level, species: species, class_of_char: charclass, background: background,
      str: str, strmod: strmod, dex: dex, dexmod: dexmod, con: con, conmod: conmod,
      int: int, intmod: intmod, wis: wis, wismod: wismod, cha: cha, chamod: chamod,
      ac: 10 + dexmod, prof: prof, hitpoints: hitpoints, skills: skills
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
