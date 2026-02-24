module CharacterCreatorKata
  # --- Constants ---

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

  ALL_SKILLS = [
    Proficiencies::ATHLETICS, Proficiencies::ACROBATICS, Proficiencies::SLEIGHT_OF_HAND,
    Proficiencies::STEALTH, Proficiencies::ARCANA, Proficiencies::HISTORY,
    Proficiencies::INVESTIGATION, Proficiencies::NATURE, Proficiencies::RELIGION,
    Proficiencies::ANIMAL_HANDLING, Proficiencies::INSIGHT, Proficiencies::MEDICINE,
    Proficiencies::PERCEPTION, Proficiencies::SURVIVAL, Proficiencies::DECEPTION,
    Proficiencies::INTIMIDATION, Proficiencies::PERFORMANCE, Proficiencies::PERSUASION
  ].freeze

  HIT_DICE = {
    "Barbarian" => 12,
    "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
    "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
    "Sorcerer" => 6, "Wizard" => 6
  }.freeze

  CLASSES = %w[Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard].freeze

  SPECIES = %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling].freeze

  BACKGROUNDS = %w[Acolyte Criminal Sage Soldier].freeze

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

  STAT_NAMES = %w[Strength Dexterity Constitution Intelligence Wisdom Charisma].freeze

  STANDARD_ARRAY = [15, 14, 13, 12, 10, 8].freeze

  # --- Value Objects ---

  class AbilityScores
    ABILITY_NAMES = %i[str dex con int wis cha].freeze

    attr_reader :str, :dex, :con, :int, :wis, :cha

    def initialize(str:, dex:, con:, int:, wis:, cha:)
      @str = str
      @dex = dex
      @con = con
      @int = int
      @wis = wis
      @cha = cha
    end

    def str_mod = modifier(str)
    def dex_mod = modifier(dex)
    def con_mod = modifier(con)
    def int_mod = modifier(int)
    def wis_mod = modifier(wis)
    def cha_mod = modifier(cha)

    def to_h
      {
        str: str, str_mod: str_mod,
        dex: dex, dex_mod: dex_mod,
        con: con, con_mod: con_mod,
        int: int, int_mod: int_mod,
        wis: wis, wis_mod: wis_mod,
        cha: cha, cha_mod: cha_mod
      }
    end

    private

    def modifier(score)
      (score - 10) / 2
    end
  end

  class Character
    attr_reader :name, :level, :species, :char_class, :background,
                :ability_scores, :ac, :proficiency_bonus, :hit_points, :skills

    def initialize(name:, level:, species:, char_class:, background:,
                   ability_scores:, ac:, proficiency_bonus:, hit_points:, skills:)
      @name = name
      @level = level
      @species = species
      @char_class = char_class
      @background = background
      @ability_scores = ability_scores
      @ac = ac
      @proficiency_bonus = proficiency_bonus
      @hit_points = hit_points
      @skills = skills
    end

    def to_h
      {
        name: name,
        level: level,
        species: species,
        char_class: char_class,
        background: background,
        **ability_scores.to_h,
        ac: ac,
        proficiency_bonus: proficiency_bonus,
        hit_points: hit_points,
        skills: skills
      }
    end
  end

  # --- Calculations ---

  def self.ability_modifier(score)
    (score - 10) / 2
  end

  def self.proficiency_bonus(level)
    (level - 1) / 4 + 2
  end

  def self.calculate_hit_points(char_class, level, con_mod)
    die = HIT_DICE[char_class]
    die + con_mod + (level * (die / 2 + 1 + con_mod))
  end

  def self.background_bonuses(background)
    BACKGROUND_BONUSES.fetch(background, DEFAULT_BACKGROUND_BONUS)
  end

  def self.proficiency_by_class(character_class)
    CLASS_PROFICIENCIES.fetch(character_class, [])
  end

  def self.initialize_skills
    ALL_SKILLS.each_with_object({}) { |skill, hash| hash[skill] = 0 }
  end

  def self.stat_roll
    STANDARD_ARRAY.dup
  end

  # --- Input Helpers ---

  def get_input(default)
    puts default
    default
    # gets
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

  def pick_class
    pick_from_list(CLASSES, "What class is your character? ")
  end

  def pick_species
    pick_from_list(SPECIES, "What species is your character? ")
  end

  def pick_background
    pick_from_list(BACKGROUNDS, "What background is your character? ")
  end

  def pick_one_stat(available, finalstats, index, stat_name)
    puts "Which number would you like to be your #{stat_name} stat? "

    while finalstats[index].nil?
      value = get_input(available.compact.first).to_i
      if available.include?(value)
        finalstats[index] = value
        available[available.index(value)] = nil
      else
        puts "Please select one of the available numbers"
      end
    end
  end

  def assign_stats(stats)
    pickable = STAT_NAMES[0...-1] # All except Charisma (auto-assigned)

    loop do
      finalstats = []
      puts "These are your stats: "
      stats.each { |s| puts s }

      pickable.each_with_index do |name, index|
        pick_one_stat(stats, finalstats, index, name)

        if index < pickable.length - 1
          puts "These are your remaining stats: "
          stats.compact!
          puts stats
        end
      end

      finalstats[5] = stats.compact.first

      puts "Your stats are: Strength: #{finalstats[0]}, Dexterity: #{finalstats[1]}, " \
           "Constitution: #{finalstats[2]}, Intelligence: #{finalstats[3]}, " \
           "Wisdom: #{finalstats[4]}, Charisma: #{finalstats[5]}"

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

  # --- Main Orchestration ---

  def main
    puts "Welcome to the D&D Character Creator!"
    puts "=" * 40

    char_class = pick_class
    species = pick_species
    background = pick_background

    stats = CharacterCreatorKata.stat_roll
    puts "You rolled: #{stats.inspect}"
    finalstats = assign_stats(stats)

    level = 1
    str, dex, con, int, wis, cha = finalstats
    ability_scores = AbilityScores.new(str: str, dex: dex, con: con, int: int, wis: wis, cha: cha)

    prof = CharacterCreatorKata.proficiency_bonus(level)
    hit_points = CharacterCreatorKata.calculate_hit_points(char_class, level, ability_scores.con_mod)
    skills = CharacterCreatorKata.initialize_skills

    puts "\nWhat is your character's name?"
    name = get_input("Adventurer")

    character = Character.new(
      name: name, level: level, species: species, char_class: char_class, background: background,
      ability_scores: ability_scores, ac: 10 + ability_scores.dex_mod,
      proficiency_bonus: prof, hit_points: hit_points, skills: skills
    )

    puts "\n" + "=" * 40
    puts "Character Created!"
    puts "=" * 40
    character.to_h.each { |key, value| puts "  #{key}: #{value}" }

    character
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata
  main
end
