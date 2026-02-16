module CharacterCreatorKata
  require "active_support/all"

  HIT_DICE = {
    "Barbarian" => 12,
    "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
    "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
    "Sorcerer" => 6, "Wizard" => 6
  }.freeze

  SPECIES = %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling].freeze

  CLASSES = %w[Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard].freeze

  BACKGROUNDS = %w[Acolyte Criminal Sage Soldier].freeze

  STAT_NAMES = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma].freeze

  SKILLS = [
    "athletics", "acrobatics", "sleight of hand", "stealth", "arcana", "history",
    "investigation", "nature", "religion", "animal handling", "insight", "medicine",
    "perception", "survival", "deception", "intimidation", "performance", "persuasion"
  ].freeze

  BACKGROUND_DATA = {
    "Acolyte"  => { abilities: %w[Intelligence Wisdom Charisma], skills: %w[insight religion] },
    "Criminal" => { abilities: %w[Dexterity Constitution Intelligence], skills: ["sleight of hand", "stealth"] },
    "Sage"     => { abilities: %w[Constitution Intelligence Wisdom], skills: %w[arcana history] },
    "Soldier"  => { abilities: %w[Strength Dexterity Constitution], skills: %w[athletics intimidation] }
  }.freeze

  CLASS_SKILLS = {
    "Barbarian" => %w[animal\ handling athletics intimidation nature perception survival],
    "Bard"      => SKILLS,
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

  def get_input(default)
    puts default
    default
  end

  def modifier(stat) = (stat - 10) / 2

  def proficiency(level)
    case level
    in (..4)  then 2
    in (..8)  then 3
    in (..12) then 4
    in (..16) then 5
    else 6
    end
  end

  def hitpoints(char_class, level, con_mod)
    die = HIT_DICE.fetch(char_class)
    die + con_mod + level * (die / 2 + 1 + con_mod)
  end

  def statroll
    6.times.map {
      4.times.map { rand(1..6) }.sort.drop(1).sum
    }
  end

  def pick_from(label, options)
    puts options
    puts "What #{label} is your character? "
    choice = ""
    until options.include?(choice)
      choice = get_input(options.first).split(/ |_|-/).map(&:capitalize).join(" ").chomp
      puts "please select an option from the list" unless options.include?(choice)
    end
    choice
  end

  def classpick = pick_from("class", CLASSES)
  def speciespick = pick_from("species", SPECIES)
  def backgroundpick = pick_from("background", BACKGROUNDS)

  def background_bonuses(background) = BACKGROUND_DATA.fetch(background, { abilities: [], skills: [] })
  def proficiency_by_class(character_class) = CLASS_SKILLS.fetch(character_class, [])
  def skillpopulator = SKILLS.each_with_object({}) { |s, h| h[s] = 0 }

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
      instance_variables.map { |attr| { attr => instance_variable_get(attr) } }
    end
  end

  class Ranger
    attr_accessor :damage, :chancetohit, :armor, :weapon
  end

  def my_modcalc(stat) = modifier(stat)

  def armorcalc
    $charstats.ac = 10 + $charstats.dexmod if true
  end

  def profpicker
    tempprof = SKILLS.dup
    3.times do |i|
      puts "These are your #{i.zero? ? '' : 'remaining '}stats: "
      puts tempprof.compact
      puts "Which skill would you like to choose as your #{%w[first second third][i]} proficiency (case sensitive)"

      chosen = nil
      until chosen
        input = get_input(tempprof.compact.first).chomp
        if tempprof.include?(input)
          chosen = input
          tempprof.delete_at(tempprof.index(input))
          $prof[19 + i] = chosen
        else
          puts "please select one of the offered skills (case sensitive)"
        end
      end
    end
  end

  def statpick(stats)
    loop do
      remaining = stats.dup
      finalstats = []

      STAT_NAMES[0..4].each do |name|
        puts "These are your #{finalstats.empty? ? '' : 'remaining '}stats: "
        puts remaining.compact
        puts "Which number would you like to be your #{name} stat? "

        chosen = nil
        until chosen
          input = get_input(remaining.compact.first).to_i
          idx = remaining.index(input)
          if idx
            chosen = input
            finalstats << chosen
            remaining[idx] = nil
            remaining.compact!
          else
            puts "Please select one of the available numbers"
          end
        end
      end

      finalstats << remaining.compact.first

      puts "So your stats are  Strength: #{finalstats[0]}, Dexteriy: #{finalstats[1]}, Constitution: #{finalstats[2]},
    Intelligence: #{finalstats[3]}, Wisdom: #{finalstats[4]}, and Charisma: #{finalstats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until %w[y n].include?(finish)
        finish = get_input("y").chomp
        puts "Please select y to complete this process or n to start over" unless %w[y n].include?(finish)
      end

      return finalstats if finish == "y"
    end
  end
end

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
  hp = hitpoints(charclass, level, conmod)
  skills = skillpopulator

  puts "\nWhat is your character's name?"
  charname = get_input("Adventurer")

  $charstats = DnDchars.new(
    charname, level, species, charclass, background,
    str, strmod, dex, dexmod, con, conmod, int, intmod, wis, wismod, cha, chamod,
    10 + dexmod, prof, hp, skills
  )

  puts "\n" + "=" * 40
  puts "Character Created!"
  puts "=" * 40
  puts $charstats.context
end
