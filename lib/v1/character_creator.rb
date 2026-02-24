module CharacterCreatorKata
  # --- Constants ---

  SKILL_ABILITIES = {
    athletics: :str,
    acrobatics: :dex, sleight_of_hand: :dex, stealth: :dex,
    arcana: :int, history: :int, investigation: :int, nature: :int, religion: :int,
    animal_handling: :wis, insight: :wis, medicine: :wis, perception: :wis, survival: :wis,
    deception: :cha, intimidation: :cha, performance: :cha, persuasion: :cha
  }.freeze

  ALL_SKILLS = SKILL_ABILITIES.keys.freeze

  ABILITY_NAMES = %i[str dex con int wis cha].freeze


  STANDARD_ARRAY = [15, 14, 13, 12, 10, 8].freeze

  CLASSES = {
    "Barbarian" => { hit_die: 12, skill_count: 2, saving_throws: %i[str con], skills: %i[animal_handling athletics intimidation nature perception survival] },
    "Bard"      => { hit_die: 8,  skill_count: 3, saving_throws: %i[dex cha], skills: ALL_SKILLS.dup },
    "Cleric"    => { hit_die: 8,  skill_count: 2, saving_throws: %i[wis cha], skills: %i[history insight medicine persuasion religion] },
    "Druid"     => { hit_die: 8,  skill_count: 2, saving_throws: %i[int wis], skills: %i[arcana animal_handling insight medicine nature perception religion survival] },
    "Fighter"   => { hit_die: 10, skill_count: 2, saving_throws: %i[str con], skills: %i[acrobatics animal_handling athletics history insight intimidation perception persuasion survival] },
    "Monk"      => { hit_die: 8,  skill_count: 2, saving_throws: %i[str dex], skills: %i[acrobatics athletics history insight religion stealth] },
    "Paladin"   => { hit_die: 10, skill_count: 2, saving_throws: %i[wis cha], skills: %i[athletics insight intimidation medicine persuasion religion] },
    "Ranger"    => { hit_die: 10, skill_count: 3, saving_throws: %i[str dex], skills: %i[animal_handling athletics insight investigation nature perception stealth survival] },
    "Rogue"     => { hit_die: 8,  skill_count: 4, saving_throws: %i[dex int], skills: %i[acrobatics athletics deception insight intimidation investigation perception persuasion sleight_of_hand stealth] },
    "Sorcerer"  => { hit_die: 6,  skill_count: 2, saving_throws: %i[con cha], skills: %i[arcana deception insight intimidation persuasion religion] },
    "Warlock"   => { hit_die: 8,  skill_count: 2, saving_throws: %i[wis cha], skills: %i[arcana deception history intimidation investigation nature religion] },
    "Wizard"    => { hit_die: 6,  skill_count: 2, saving_throws: %i[int wis], skills: %i[arcana history insight investigation medicine nature religion] }
  }.freeze

  SPECIES = {
    "Dragonborn" => { speed: 30 },
    "Dwarf"      => { speed: 30 },
    "Elf"        => { speed: 30 },
    "Gnome"      => { speed: 30 },
    "Goliath"    => { speed: 35 },
    "Halfling"   => { speed: 30 },
    "Human"      => { speed: 30 },
    "Orc"        => { speed: 30 },
    "Tiefling"   => { speed: 30 }
  }.freeze

  LANGUAGES = %w[Common Draconic Dwarvish Elvish Giant Gnomish Goblin Halfling Orc
                 Abyssal Celestial Infernal Primordial Sylvan Undercommon
                 Deep\ Speech Druidic Thieves'\ Cant].freeze

  BACKGROUNDS = {
    "Acolyte"      => { ability_bonuses: %i[int wis cha], skill_proficiencies: %i[insight religion] },
    "Artisan"      => { ability_bonuses: %i[str dex int], skill_proficiencies: %i[investigation persuasion] },
    "Charlatan"    => { ability_bonuses: %i[dex con cha], skill_proficiencies: %i[deception sleight_of_hand] },
    "Criminal"     => { ability_bonuses: %i[dex con int], skill_proficiencies: %i[sleight_of_hand stealth] },
    "Entertainer"  => { ability_bonuses: %i[str dex cha], skill_proficiencies: %i[acrobatics performance] },
    "Farmer"       => { ability_bonuses: %i[str con wis], skill_proficiencies: %i[animal_handling nature] },
    "Guard"        => { ability_bonuses: %i[str con wis], skill_proficiencies: %i[athletics perception] },
    "Guide"        => { ability_bonuses: %i[dex con wis], skill_proficiencies: %i[stealth survival] },
    "Hermit"       => { ability_bonuses: %i[con wis cha], skill_proficiencies: %i[medicine religion] },
    "Merchant"     => { ability_bonuses: %i[con int cha], skill_proficiencies: %i[animal_handling persuasion] },
    "Noble"        => { ability_bonuses: %i[str int cha], skill_proficiencies: %i[history persuasion] },
    "Sage"         => { ability_bonuses: %i[con int wis], skill_proficiencies: %i[arcana history] },
    "Sailor"       => { ability_bonuses: %i[str dex wis], skill_proficiencies: %i[acrobatics perception] },
    "Scribe"       => { ability_bonuses: %i[dex int wis], skill_proficiencies: %i[investigation perception] },
    "Soldier"      => { ability_bonuses: %i[str dex con], skill_proficiencies: %i[athletics intimidation] },
    "Wayfarer"     => { ability_bonuses: %i[dex wis cha], skill_proficiencies: %i[insight stealth] }
  }.freeze


  # --- Value Objects ---

  AbilityScores = Data.define(:str, :dex, :con, :int, :wis, :cha) do
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
      self.class.new(**args)
    end

    def to_h
      ABILITY_NAMES.each_with_object({}) do |name, h|
        h[name] = send(name)
        h[:"#{name}_mod"] = send(:"#{name}_mod")
      end
    end
  end

  Character = Data.define(
    :name, :level, :species, :char_class, :background,
    :ability_scores, :ac, :speed, :proficiency_bonus, :hit_points, :initiative,
    :passive_perception, :passive_insight, :passive_investigation,
    :saving_throws, :languages, :skills
  ) do
    def to_h
      super.merge(**ability_scores.to_h).tap { |h| h.delete(:ability_scores) }
    end

    def to_s
      s = ability_scores
      lines = []
      lines << "--- #{name} (Level #{level} #{char_class}) ---"
      lines << "Species: #{species} | Background: #{background}"
      lines << "STR: #{s.str} (%+d)  DEX: #{s.dex} (%+d)  CON: #{s.con} (%+d)" % [s.str_mod, s.dex_mod, s.con_mod]
      lines << "INT: #{s.int} (%+d)  WIS: #{s.wis} (%+d)  CHA: #{s.cha} (%+d)" % [s.int_mod, s.wis_mod, s.cha_mod]
      lines << "AC: #{ac}  HP: #{hit_points}  Speed: #{speed} ft  Prof Bonus: +#{proficiency_bonus}  Initiative: %+d" % initiative
      lines << "Passive Perception: #{passive_perception}  Insight: #{passive_insight}  Investigation: #{passive_investigation}"
      saves = saving_throws.map { |ab, val| "#{ab.to_s.upcase} %+d" % val }.join("  ")
      lines << "Saving Throws: #{saves}"
      lines << "Languages: #{languages.join(", ")}"
      lines << "Skills:"
      skills.sort_by { |name, _| name }.each do |skill, val|
        lines << "  %-20s %+d" % [CharacterCreatorKata.display_name(skill), val]
      end
      lines.join("\n")
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
    die = CLASSES.dig(char_class, :hit_die)
    die + con_mod + (level * (die / 2 + 1 + con_mod))
  end

  def self.background_bonuses(background)
    BACKGROUNDS.fetch(background, { ability_bonuses: [], skill_proficiencies: [] })
  end

  def self.proficiency_by_class(character_class)
    CLASSES.dig(character_class, :skills) || []
  end

  def self.initialize_skills
    ALL_SKILLS.each_with_object({}) { |skill, hash| hash[skill] = 0 }
  end

  def self.stat_roll
    STANDARD_ARRAY.dup
  end

  def self.class_skill_count(char_class)
    CLASSES.dig(char_class, :skill_count) || 2
  end

  def self.saving_throws_for_class(char_class)
    CLASSES.dig(char_class, :saving_throws) || []
  end

  def self.calculate_saving_throws(ability_scores, proficiency_bonus, char_class)
    proficient = saving_throws_for_class(char_class)
    ABILITY_NAMES.each_with_object({}) do |ability, hash|
      base = ability_scores.mod_for(ability)
      bonus = proficient.include?(ability) ? proficiency_bonus : 0
      hash[ability] = base + bonus
    end
  end

  def self.calculate_skills(ability_scores, proficiency_bonus, proficient_skills)
    ALL_SKILLS.each_with_object({}) do |skill, hash|
      ability_key = SKILL_ABILITIES[skill]
      base_mod = ability_scores.mod_for(ability_key)
      bonus = proficient_skills.include?(skill) ? proficiency_bonus : 0
      hash[skill] = base_mod + bonus
    end
  end

  # --- Display Helpers ---

  def self.display_name(sym)
    sym.to_s.split("_").map(&:capitalize).join(" ")
  end

  # --- Input Helpers ---

  def get_input(default)
    puts default
    default
  end

  def pick_from_list(options, prompt, display: ->(o) { o.to_s })
    puts "\n#{prompt}"
    options.each_with_index { |opt, i| puts "  #{i + 1}) #{display.call(opt)}" }
    choice = options[get_input("1").to_i - 1]
    puts "  → #{display.call(choice)}"
    choice
  end

  def ability_abbrev(sym)
    sym.to_s.upcase
  end

  def assign_stats(stats)
    available = stats.dup
    finalstats = []

    puts "\nAssign Ability Scores (Standard Array: #{stats.inspect})"
    ABILITY_NAMES[0...-1].each_with_index do |name, i|
      puts "  #{ability_abbrev(name)} from #{available.compact.inspect}:"
      value = get_input(available.compact.first).to_i
      finalstats[i] = value
      available[available.index(value)] = nil
    end
    finalstats[5] = available.compact.first
    puts "  CHA: #{finalstats[5]} (auto-assigned)"
    finalstats
  end

  def apply_background_bonuses(background, ability_scores)
    bonuses = CharacterCreatorKata.background_bonuses(background)
    candidates = bonuses[:ability_bonuses]
    bg_skills = bonuses[:skill_proficiencies]

    return [ability_scores, bg_skills] if candidates.empty?

    dn = method(:ability_abbrev)
    plus2 = pick_from_list(candidates, "#{background}: Which ability gets +2?", display: dn)
    plus1 = pick_from_list(candidates - [plus2], "#{background}: Which ability gets +1?", display: dn)

    [ability_scores.with_bonuses(plus2 => 2, plus1 => 1), bg_skills]
  end

  def pick_class_skills(char_class, background_skills)
    available = CharacterCreatorKata.proficiency_by_class(char_class) - background_skills
    count = CharacterCreatorKata.class_skill_count(char_class)
    chosen = []

    dn = method(:display_name)
    bg_names = background_skills.map { |s| CharacterCreatorKata.display_name(s) }.join(", ")
    puts "\n  Background skills: #{bg_names}" unless background_skills.empty?

    count.times do |i|
      chosen << pick_from_list(available - chosen, "#{char_class} skill #{i + 1}/#{count}:", display: dn)
    end
    chosen
  end

  def pick_languages
    chosen = ["Common"]
    available = LANGUAGES - chosen
    2.times do |i|
      lang = pick_from_list(available - chosen, "Choose language #{i + 1}/2:")
      chosen << lang
    end
    chosen
  end

  def display_name(sym)
    CharacterCreatorKata.display_name(sym)
  end

  # --- Main Orchestration ---

  def main
    puts "D&D Character Creator"
    puts "=" * 30

    char_class = pick_from_list(CLASSES.keys, "Choose your class:")
    species    = pick_from_list(SPECIES.keys, "Choose your species:")
    background = pick_from_list(BACKGROUNDS.keys, "Choose your background:")

    finalstats = assign_stats(CharacterCreatorKata.stat_roll)

    level = 1
    str, dex, con, int, wis, cha = finalstats
    base_scores = AbilityScores.new(str: str, dex: dex, con: con, int: int, wis: wis, cha: cha)

    ability_scores, background_skills = apply_background_bonuses(background, base_scores)
    class_skills = pick_class_skills(char_class, background_skills)
    all_proficient_skills = (background_skills + class_skills).uniq

    prof = CharacterCreatorKata.proficiency_bonus(level)
    hit_points = CharacterCreatorKata.calculate_hit_points(char_class, level, ability_scores.con_mod)
    saving_throws = CharacterCreatorKata.calculate_saving_throws(ability_scores, prof, char_class)
    skills = CharacterCreatorKata.calculate_skills(ability_scores, prof, all_proficient_skills)

    languages = pick_languages

    puts "\nWhat is your character's name?"
    name = get_input("Adventurer").to_s.strip
    name = "Adventurer" if name.empty?

    character = Character.new(
      name: name, level: level, species: species, char_class: char_class, background: background,
      ability_scores: ability_scores, ac: 10 + ability_scores.dex_mod, speed: SPECIES.dig(species, :speed) || 30,
      proficiency_bonus: prof, hit_points: hit_points,
      initiative: ability_scores.dex_mod,
      passive_perception: 10 + skills[:perception],
      passive_insight: 10 + skills[:insight],
      passive_investigation: 10 + skills[:investigation],
      saving_throws: saving_throws, languages: languages, skills: skills
    )

    puts "\n#{character}"
    character
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata
  main
end
