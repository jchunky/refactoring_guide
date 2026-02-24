module CharacterCreatorKata
  # --- Constants ---

  ALL_SKILLS = %w[
    athletics acrobatics sleight\ of\ hand stealth
    arcana history investigation nature religion
    animal\ handling insight medicine perception survival
    deception intimidation performance persuasion
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
    "Acolyte"  => { ability_bonuses: %w[Intelligence Wisdom Charisma],    skill_proficiencies: %w[insight religion] },
    "Criminal" => { ability_bonuses: %w[Dexterity Constitution Intelligence], skill_proficiencies: ["sleight of hand", "stealth"] },
    "Sage"     => { ability_bonuses: %w[Constitution Intelligence Wisdom], skill_proficiencies: %w[arcana history] },
    "Soldier"  => { ability_bonuses: %w[Strength Dexterity Constitution],  skill_proficiencies: %w[athletics intimidation] }
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

  SKILL_ABILITIES = {
    "athletics" => :str,
    "acrobatics" => :dex, "sleight of hand" => :dex, "stealth" => :dex,
    "arcana" => :int, "history" => :int, "investigation" => :int, "nature" => :int, "religion" => :int,
    "animal handling" => :wis, "insight" => :wis, "medicine" => :wis, "perception" => :wis, "survival" => :wis,
    "deception" => :cha, "intimidation" => :cha, "performance" => :cha, "persuasion" => :cha
  }.freeze

  # D&D 2024: Number of skill proficiencies each class grants
  CLASS_SKILL_COUNTS = {
    "Barbarian" => 2, "Bard" => 3, "Cleric" => 2, "Druid" => 2,
    "Fighter" => 2, "Monk" => 2, "Paladin" => 2, "Ranger" => 3,
    "Rogue" => 4, "Sorcerer" => 2, "Warlock" => 2, "Wizard" => 2
  }.freeze

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

    ABILITY_NAMES.each do |name|
      define_method(:"#{name}_mod") { CharacterCreatorKata.ability_modifier(send(name)) }
    end

    def mod_for(ability_key)
      CharacterCreatorKata.ability_modifier(send(ability_key))
    end

    def with_bonuses(bonuses = {})
      args = ABILITY_NAMES.each_with_object({}) do |name, h|
        h[name] = send(name) + (bonuses[name] || 0)
      end
      AbilityScores.new(**args)
    end

    def to_h
      ABILITY_NAMES.each_with_object({}) do |name, h|
        h[name] = send(name)
        h[:"#{name}_mod"] = send(:"#{name}_mod")
      end
    end
  end

  Character = Struct.new(
    :name, :level, :species, :char_class, :background,
    :ability_scores, :ac, :proficiency_bonus, :hit_points, :skills,
    keyword_init: true
  ) do
    def to_h
      super.merge(**ability_scores.to_h).tap { |h| h.delete(:ability_scores) }
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

  def self.class_skill_count(char_class)
    CLASS_SKILL_COUNTS.fetch(char_class, 2)
  end

  def self.calculate_skills(ability_scores, proficiency_bonus, proficient_skills)
    ALL_SKILLS.each_with_object({}) do |skill, hash|
      ability_key = SKILL_ABILITIES[skill]
      base_mod = ability_scores.mod_for(ability_key)
      bonus = proficient_skills.include?(skill) ? proficiency_bonus : 0
      hash[skill] = base_mod + bonus
    end
  end

  # --- Input Helpers ---

  def get_input(default)
    puts default
    default
  end

  def pick_first(options)
    choice = options.first
    puts "  → #{choice}"
    choice
  end

  def assign_stats(stats)
    finalstats = []
    available = stats.dup

    STAT_NAMES[0...-1].each_with_index do |name, i|
      value = get_input(available.compact.first).to_i
      finalstats[i] = value
      available[available.index(value)] = nil
    end
    finalstats[5] = available.compact.first

    finalstats
  end

  def apply_background_bonuses(background, ability_scores)
    bonuses = CharacterCreatorKata.background_bonuses(background)
    candidates = bonuses[:ability_bonuses]
    bg_skills = bonuses[:skill_proficiencies]

    return [ability_scores, bg_skills] if candidates.empty?

    plus2_name = candidates.first
    plus1_name = (candidates - [plus2_name]).first

    bonus_hash = {
      plus2_name.downcase[0..2].to_sym => 2,
      plus1_name.downcase[0..2].to_sym => 1
    }
    [ability_scores.with_bonuses(bonus_hash), bg_skills]
  end

  def pick_class_skills(char_class, background_skills)
    available = CharacterCreatorKata.proficiency_by_class(char_class) - background_skills
    count = CharacterCreatorKata.class_skill_count(char_class)
    available.first(count)
  end

  # --- Main Orchestration ---

  def main
    puts "D&D Character Creator"

    char_class  = pick_first(CLASSES)
    species     = pick_first(SPECIES)
    background  = pick_first(BACKGROUNDS)

    finalstats = assign_stats(CharacterCreatorKata.stat_roll)

    level = 1
    str, dex, con, int, wis, cha = finalstats
    base_scores = AbilityScores.new(str: str, dex: dex, con: con, int: int, wis: wis, cha: cha)

    ability_scores, background_skills = apply_background_bonuses(background, base_scores)
    class_skills = pick_class_skills(char_class, background_skills)
    all_proficient_skills = (background_skills + class_skills).uniq

    prof = CharacterCreatorKata.proficiency_bonus(level)
    hit_points = CharacterCreatorKata.calculate_hit_points(char_class, level, ability_scores.con_mod)
    skills = CharacterCreatorKata.calculate_skills(ability_scores, prof, all_proficient_skills)

    name = get_input("Adventurer").to_s.strip
    name = "Adventurer" if name.empty?

    Character.new(
      name: name, level: level, species: species, char_class: char_class, background: background,
      ability_scores: ability_scores, ac: 10 + ability_scores.dex_mod,
      proficiency_bonus: prof, hit_points: hit_points, skills: skills
    )
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata
  main
end
