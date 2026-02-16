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

  # A single ability score with its derived modifier
  class Stat
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def modifier
      (value - 10) / 2
    end

    def to_i
      value
    end

    def to_s
      value.to_s
    end
  end

  # Groups all six ability scores into a single object
  class AbilityScores
    NAMES = STAT_NAMES

    attr_reader :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma

    def initialize(values)
      @strength, @dexterity, @constitution, @intelligence, @wisdom, @charisma =
        values.map { |v| Stat.new(v) }
    end

    def each_with_name(&block)
      stats.zip(NAMES).each { |stat, name| block.call(name, stat) }
    end

    def stats
      [strength, dexterity, constitution, intelligence, wisdom, charisma]
    end

    def to_summary
      NAMES.zip(stats).map { |name, stat| "#{name}: #{stat.value}" }.join(", ")
    end
  end

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
    attr_accessor :charname, :level, :race, :class_of_char, :background,
                  :ability_scores, :ac, :prof, :hitpoints, :skills

    def initialize(charname:, level:, race:, class_of_char:, background:,
                   ability_scores:, ac:, prof:, hitpoints:, skills:)
      @charname = charname
      @level = level
      @race = race
      @class_of_char = class_of_char
      @background = background
      @ability_scores = ability_scores
      @ac = ac
      @prof = prof
      @hitpoints = hitpoints
      @skills = skills
    end

    # Convenience accessors that delegate to ability_scores
    def str;    ability_scores.strength.value;     end
    def strmod; ability_scores.strength.modifier;  end
    def dex;    ability_scores.dexterity.value;    end
    def dexmod; ability_scores.dexterity.modifier; end
    def con;    ability_scores.constitution.value;     end
    def conmod; ability_scores.constitution.modifier;  end
    def int;    ability_scores.intelligence.value;     end
    def intmod; ability_scores.intelligence.modifier;  end
    def wis;    ability_scores.wisdom.value;       end
    def wismod; ability_scores.wisdom.modifier;    end
    def cha;    ability_scores.charisma.value;     end
    def chamod; ability_scores.charisma.modifier;  end

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
  ability_scores = AbilityScores.new(finalstats)

  prof = proficiency_bonus(level)
  hp = hit_points(charclass, level, ability_scores.constitution.modifier)
  skills = skillpopulator

  puts "\nWhat is your character's name?"
  charname = get_input("Adventurer")

  $charstats = DnDchars.new(
    charname: charname,
    level: level,
    race: race,
    class_of_char: charclass,
    background: background,
    ability_scores: ability_scores,
    ac: 10 + ability_scores.dexterity.modifier,
    prof: prof,
    hitpoints: hp,
    skills: skills
  )

  puts "\n" + "=" * 40
  puts "Character Created!"
  puts "=" * 40
  puts $charstats.context
end
