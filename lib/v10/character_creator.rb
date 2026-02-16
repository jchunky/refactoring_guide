module CharacterCreatorKata
  require "active_support/all"

  HIT_DICE = {
    "Barbarian" => 12,
    "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
    "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
    "Sorcerer" => 6, "Wizard" => 6
  }.freeze

  CLASSES = HIT_DICE.keys.sort.freeze

  RACES = [
    "Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf",
    "Lightfoot Halfling", "Stout Halfling", "Human", "Human Variant",
    "Dragonborn", "Rock Gnome", "Forest Gnome", "Half Elf", "Half Orc", "Tiefling"
  ].freeze

  BACKGROUNDS = [
    "Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Gladiator",
    "Guild Artisan", "Guild Merchant", "Hermit", "Knight", "Noble", "Outlander",
    "Pirate", "Sage", "Sailor", "Soldier", "Spy", "Urchin"
  ].freeze

  SKILLS = [
    "athletics", "acrobatics", "sleight of hand", "stealth", "arcana", "history",
    "investigation", "nature", "religion", "animal handling", "insight", "medicine",
    "perception", "survival", "deception", "intimidation", "performance", "persuasion"
  ].freeze

  CLASS_PROFICIENCIES = {
    "Barbarian" => %w[animal\ handling athletics intimidation nature perception survival],
    "Bard"      => SKILLS.dup,
    "Cleric"    => %w[history insight medicine persuasion religion],
    "Druid"     => %w[arcana animal\ handling insight medicine nature perception religion survival],
    "Fighter"   => %w[acrobatics animal\ handling athletics history insight intimidation perception survival],
    "Monk"      => %w[acrobatics athletics history insight religion stealth],
    "Paladin"   => %w[athletics insight intimidation medicine persuasion religion],
    "Ranger"    => %w[animal\ handling athletics insight investigation nature perception stealth survival],
    "Rogue"     => %w[acrobatics athletics deception insight intimidation investigation perception performance persuasion sleight\ of\ hand stealth],
    "Sorcerer"  => %w[arcana deception insight intimidation persuasion religion],
    "Warlock"   => %w[arcana deception history intimidation investigation nature religion],
    "Wizard"    => %w[arcana history insight investigation medicine religion]
  }.freeze

  STAT_NAMES = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma].freeze

  def get_input(default)
    puts default
    default
  end

  def modifier(stat)
    (stat - 10) / 2
  end

  def proficiency_bonus(level)
    (level - 1) / 4 + 2
  end

  def hit_points(char_class, level, con_mod)
    die = HIT_DICE[char_class.chomp]
    return nil unless die
    avg_roll = die / 2 + 1
    die + con_mod + (level * (avg_roll + con_mod))
  end

  def pick_from_list(prompt, options, &formatter)
    formatter ||= ->(input) { input }
    puts options
    puts prompt
    choice = ""
    until options.include?(choice)
      choice = formatter.call(get_input(options.first)).chomp
      puts "please select an option from the list" unless options.include?(choice)
    end
    choice
  end

  def classpick
    pick_from_list("What class is your character? ", CLASSES) { |input| input.capitalize }
  end

  def racepick
    pick_from_list("What race is your character? ", RACES) { |input| input.split(/ |_|-/).map(&:capitalize).join(" ") }
  end

  def backgroundpick
    pick_from_list("What race is your character? ", BACKGROUNDS) { |input| input.split(/ |_|-/).map(&:capitalize).join(" ") }
  end

  def proficiency_by_class(character_class)
    CLASS_PROFICIENCIES.fetch(character_class, [])
  end

  def skillpopulator
    SKILLS.each_with_object({}) { |skill, hash| hash[skill] = 0 }
  end

  def statroll
    6.times.map do
      rolls = 4.times.map { rand(1..6) }
      rolls.sum - rolls.min
    end
  end

  def statpick(stats)
    loop do
      remaining = stats.dup
      final_stats = []

      STAT_NAMES[0..4].each do |stat_name|
        puts "These are your remaining stats: "
        puts remaining.compact
        puts "Which number would you like to be your #{stat_name} stat? "

        chosen = nil
        until chosen
          input = get_input(remaining.compact.first).to_i
          idx = remaining.index(input)
          if idx
            chosen = input
            remaining[idx] = nil
          else
            puts "Please select one of the available numbers"
          end
        end
        final_stats << chosen
      end

      final_stats << remaining.compact.first

      puts "So your stats are Strength: #{final_stats[0]}, Dexterity: #{final_stats[1]}, Constitution: #{final_stats[2]}, " \
           "Intelligence: #{final_stats[3]}, Wisdom: #{final_stats[4]}, and Charisma: #{final_stats[5]}"

      puts "Are you satisfied with this? (y/n)"
      finish = ""
      until %w[y n].include?(finish)
        finish = get_input("y").chomp
        puts "Please select y to complete this process or n to start over" unless %w[y n].include?(finish)
      end

      return final_stats if finish == "y"
    end
  end

  def profpicker
    available = SKILLS.dup
    selected = []

    3.times do |i|
      puts "These are your remaining stats: "
      puts available

      puts "Which skill would you like to choose as your #{%w[first second third][i]} proficiency (case sensitive)"
      chosen = nil
      until chosen
        input = get_input(available.first).chomp
        if available.include?(input)
          chosen = input
          available.delete_at(available.index(input))
          selected << chosen
        else
          puts "please select one of the offered skills (case sensitive)"
        end
      end
    end
    selected
  end

  class DnDchars
    ATTRIBUTES = %i[
      charname level race class_of_char background
      str strmod dex dexmod con conmod int intmod wis wismod cha chamod
      ac prof hitpoints skills
    ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(*args)
      ATTRIBUTES.each_with_index do |attr, i|
        instance_variable_set(:"@#{attr}", args[i])
      end
    end

    def context
      instance_variables.map do |attribute|
        { attribute => instance_variable_get(attribute) }
      end
    end
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata

  puts "Welcome to the D&D Character Creator!"
  puts "=" * 40

  charclass = classpick
  race = racepick
  background = backgroundpick

  stats = statroll
  puts "You rolled: #{stats.inspect}"
  finalstats = statpick(stats)

  level = 1
  str, dex, con, int, wis, cha = finalstats
  strmod = modifier(str)
  dexmod = modifier(dex)
  conmod = modifier(con)
  intmod = modifier(int)
  wismod = modifier(wis)
  chamod = modifier(cha)

  prof = proficiency_bonus(level)
  hp = hit_points(charclass, level, conmod)
  skills = skillpopulator

  puts "\nWhat is your character's name?"
  charname = get_input("Adventurer")

  $charstats = DnDchars.new(
    charname, level, race, charclass, background,
    str, strmod, dex, dexmod, con, conmod, int, intmod, wis, wismod, cha, chamod,
    10 + dexmod, prof, hp, skills
  )

  puts "\n" + "=" * 40
  puts "Character Created!"
  puts "=" * 40
  puts $charstats.context
end
