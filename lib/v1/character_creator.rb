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
  STAT_ABBREVS = STAT_NAMES.map { |n| n[0..2].upcase }.freeze

  STANDARD_ARRAY = [15, 14, 13, 12, 10, 8].freeze

  # D&D 2024: Each skill maps to a governing ability
  SKILL_ABILITIES = {
    Proficiencies::ATHLETICS      => :str,
    Proficiencies::ACROBATICS     => :dex,
    Proficiencies::SLEIGHT_OF_HAND => :dex,
    Proficiencies::STEALTH        => :dex,
    Proficiencies::ARCANA         => :int,
    Proficiencies::HISTORY        => :int,
    Proficiencies::INVESTIGATION  => :int,
    Proficiencies::NATURE         => :int,
    Proficiencies::RELIGION       => :int,
    Proficiencies::ANIMAL_HANDLING => :wis,
    Proficiencies::INSIGHT        => :wis,
    Proficiencies::MEDICINE       => :wis,
    Proficiencies::PERCEPTION     => :wis,
    Proficiencies::SURVIVAL       => :wis,
    Proficiencies::DECEPTION      => :cha,
    Proficiencies::INTIMIDATION   => :cha,
    Proficiencies::PERFORMANCE    => :cha,
    Proficiencies::PERSUASION     => :cha
  }.freeze

  # D&D 2024: Number of skill proficiencies each class grants
  CLASS_SKILL_COUNTS = {
    "Barbarian" => 2, "Bard" => 3, "Cleric" => 2, "Druid" => 2,
    "Fighter" => 2, "Monk" => 2, "Paladin" => 2, "Ranger" => 3,
    "Rogue" => 4, "Sorcerer" => 2, "Warlock" => 2, "Wizard" => 2
  }.freeze

  TOTAL_STEPS = 7

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

    def to_sheet
      s = ability_scores
      w = 40

      lines = []
      lines << "┌#{"─" * w}┐"
      lines << "│#{center("CHARACTER SHEET", w)}│"
      lines << "├#{"─" * w}┤"
      lines << "│#{pad("Name: #{name}", w)}│"
      lines << "│#{pad("Level: #{level}  Class: #{char_class}", w)}│"
      lines << "│#{pad("Species: #{species}", w)}│"
      lines << "│#{pad("Background: #{background}", w)}│"
      lines << "├#{"─" * w}┤"
      lines << "│#{pad("  STR: #{fmt_score(s.str, s.str_mod)}    DEX: #{fmt_score(s.dex, s.dex_mod)}", w)}│"
      lines << "│#{pad("  CON: #{fmt_score(s.con, s.con_mod)}    INT: #{fmt_score(s.int, s.int_mod)}", w)}│"
      lines << "│#{pad("  WIS: #{fmt_score(s.wis, s.wis_mod)}    CHA: #{fmt_score(s.cha, s.cha_mod)}", w)}│"
      lines << "├#{"─" * w}┤"
      lines << "│#{pad("  AC: #{ac}    HP: #{hit_points}    Prof Bonus: +#{proficiency_bonus}", w)}│"
      lines << "├#{"─" * w}┤"
      lines << "│#{center("SKILLS", w)}│"
      skills.each do |skill, value|
        sign = value >= 0 ? "+" : ""
        lines << "│#{pad("  #{skill.ljust(16)} #{sign}#{value}", w)}│"
      end
      lines << "└#{"─" * w}┘"
      lines.join("\n")
    end

    private

    def fmt_score(score, mod)
      sign = mod >= 0 ? "+" : ""
      format("%2d (%s%d)", score, sign, mod)
    end

    def pad(text, width)
      text.ljust(width)
    end

    def center(text, width)
      text.center(width)
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

  # --- Display Helpers ---

  def print_banner(title)
    w = 40
    puts "┌#{"─" * w}┐"
    puts "│#{title.center(w)}│"
    puts "└#{"─" * w}┘"
  end

  def print_step_header(step, title)
    label = "Step #{step}/#{TOTAL_STEPS}: #{title}"
    puts "\n── #{label} #{"─" * [0, 36 - label.length].max}"
  end

  def print_numbered_grid(options, columns: 3)
    col_width = 22
    options.each_slice(columns).each do |row|
      line = row.each_with_index.map do |opt, col_i|
        idx = options.index(opt) + 1
        format("  %2d) %-#{col_width - 6}s", idx, opt)
      end
      puts line.join
    end
  end

  # --- Input Helpers ---

  def get_input(default)
    puts default
    default
    # gets
  end

  def pick_from_list(options, prompt, step: nil, columns: 3)
    print_step_header(step, prompt) if step
    puts
    print_numbered_grid(options, columns: columns)
    puts

    choice = nil
    until choice
      input = get_input("1").to_s.strip
      index = input.to_i - 1
      if input.match?(/^\d+$/) && index >= 0 && index < options.length
        choice = options[index]
      elsif options.map(&:downcase).include?(input.downcase)
        choice = options[options.map(&:downcase).index(input.downcase)]
      else
        puts "  Please enter a number (1-#{options.length})"
      end
    end

    puts "  → #{choice}"
    choice
  end

  def pick_class
    pick_from_list(CLASSES, "Choose Your Class", step: 1)
  end

  def pick_species
    pick_from_list(SPECIES, "Choose Your Species", step: 2)
  end

  def pick_background
    pick_from_list(BACKGROUNDS, "Choose Your Background", step: 3, columns: 2)
  end

  def print_stat_progress(finalstats, available)
    parts = STAT_ABBREVS.each_with_index.map do |abbrev, i|
      if finalstats[i]
        "#{abbrev}: #{format("%2d", finalstats[i])}"
      elsif i == 5
        "#{abbrev}: (auto)"
      else
        "#{abbrev}: __"
      end
    end
    puts "  #{parts[0..2].join("  │  ")}"
    puts "  #{parts[3..5].join("  │  ")}"
    puts "  Available: #{available.compact.inspect}" unless available.compact.empty?
  end

  def pick_one_stat(available, finalstats, index, stat_name)
    puts "\n  Choose your #{stat_name} score from: #{available.compact.inspect}"

    while finalstats[index].nil?
      value = get_input(available.compact.first).to_i
      if available.include?(value)
        finalstats[index] = value
        available[available.index(value)] = nil
        puts "  → #{stat_name}: #{value}"
      else
        puts "  Please select one of: #{available.compact.inspect}"
      end
    end
  end

  def pick_background_bonuses(background, ability_scores)
    bonuses = CharacterCreatorKata.background_bonuses(background)
    candidates = bonuses[:ability_bonuses]
    bg_skills = bonuses[:skill_proficiencies]

    return [ability_scores, bg_skills] if candidates.empty?

    print_step_header(5, "Background Ability Bonuses")
    puts "\n  #{background} lets you add +2 to one and +1 to another:"

    plus2_name = pick_from_list(candidates, "Which ability gets +2?", columns: 3)
    plus1_name = pick_from_list(candidates - [plus2_name], "Which ability gets +1?", columns: 3)

    bonus_hash = {
      plus2_name.downcase[0..2].to_sym => 2,
      plus1_name.downcase[0..2].to_sym => 1
    }
    [ability_scores.with_bonuses(bonus_hash), bg_skills]
  end

  def pick_class_skills(char_class, background_skills)
    available = CharacterCreatorKata.proficiency_by_class(char_class) - background_skills
    count = CharacterCreatorKata.class_skill_count(char_class)
    chosen = []

    print_step_header(6, "Choose Skill Proficiencies")
    puts "\n  #{char_class} can choose #{count} from their class skills."
    puts "  (Background already grants: #{background_skills.join(", ")})" unless background_skills.empty?

    count.times do |i|
      chosen << pick_from_list(available - chosen, "Pick skill #{i + 1}/#{count}", columns: 2)
    end

    puts "\n  Class skill proficiencies: #{chosen.join(", ")}"
    chosen
  end

  def assign_stats(stats)
    pickable = STAT_NAMES[0...-1] # All except Charisma (auto-assigned)

    loop do
      finalstats = []

      print_step_header(4, "Assign Ability Scores")
      puts "\n  Standard Array: #{stats.inspect}\n"

      pickable.each_with_index do |name, index|
        pick_one_stat(stats, finalstats, index, name)
      end

      finalstats[5] = stats.compact.first
      puts "  → Charisma: #{finalstats[5]} (auto-assigned)"

      puts "\n  Your ability scores:"
      print_stat_progress(finalstats, [])

      puts "\n  Are you satisfied? (y/n)"
      finish = ""
      until finish == "y" || finish == "n"
        finish = get_input("y").to_s.strip.downcase
        if finish == "n"
          6.times do |n|
            stats[n] = finalstats[n]
            finalstats[n] = nil
          end
        elsif finish != "y"
          puts "  Please enter y or n"
        end
      end

      return finalstats if finish == "y"
    end
  end

  # --- Main Orchestration ---

  def main
    print_banner("D&D Character Creator")
    puts

    char_class = pick_class
    species = pick_species
    background = pick_background

    stats = CharacterCreatorKata.stat_roll
    finalstats = assign_stats(stats)

    level = 1
    str, dex, con, int, wis, cha = finalstats
    base_scores = AbilityScores.new(str: str, dex: dex, con: con, int: int, wis: wis, cha: cha)

    # Step 5: Apply background ability bonuses (+2/+1)
    ability_scores, background_skills = pick_background_bonuses(background, base_scores)

    # Step 6: Pick class skill proficiencies
    class_skills = pick_class_skills(char_class, background_skills)
    all_proficient_skills = (background_skills + class_skills).uniq

    prof = CharacterCreatorKata.proficiency_bonus(level)
    hit_points = CharacterCreatorKata.calculate_hit_points(char_class, level, ability_scores.con_mod)
    skills = CharacterCreatorKata.calculate_skills(ability_scores, prof, all_proficient_skills)

    # Step 7: Name character
    print_step_header(7, "Name Your Character")
    puts
    name = get_input("Adventurer").to_s.strip
    name = "Adventurer" if name.empty?
    puts "  → #{name}"

    character = Character.new(
      name: name, level: level, species: species, char_class: char_class, background: background,
      ability_scores: ability_scores, ac: 10 + ability_scores.dex_mod,
      proficiency_bonus: prof, hit_points: hit_points, skills: skills
    )

    puts
    puts character.to_sheet

    character
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  include CharacterCreatorKata
  main
end
