module CharacterCreatorKata
  module World
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
      "Barbarian" => { hit_die: 12, skill_count: 2, skills: %i[animal_handling athletics intimidation nature perception survival] },
      "Bard"      => { hit_die: 8,  skill_count: 3, skills: ALL_SKILLS.dup },
      "Cleric"    => { hit_die: 8,  skill_count: 2, skills: %i[history insight medicine persuasion religion] },
      "Druid"     => { hit_die: 8,  skill_count: 2, skills: %i[arcana animal_handling insight medicine nature perception religion survival] },
      "Fighter"   => { hit_die: 10, skill_count: 2, skills: %i[acrobatics animal_handling athletics history insight intimidation perception persuasion survival] },
      "Monk"      => { hit_die: 8,  skill_count: 2, skills: %i[acrobatics athletics history insight religion stealth] },
      "Paladin"   => { hit_die: 10, skill_count: 2, skills: %i[athletics insight intimidation medicine persuasion religion] },
      "Ranger"    => { hit_die: 10, skill_count: 3, skills: %i[animal_handling athletics insight investigation nature perception stealth survival] },
      "Rogue"     => { hit_die: 8,  skill_count: 4, skills: %i[acrobatics athletics deception insight intimidation investigation perception persuasion sleight_of_hand stealth] },
      "Sorcerer"  => { hit_die: 6,  skill_count: 2, skills: %i[arcana deception insight intimidation persuasion religion] },
      "Warlock"   => { hit_die: 8,  skill_count: 2, skills: %i[arcana deception history intimidation investigation nature religion] },
      "Wizard"    => { hit_die: 6,  skill_count: 2, skills: %i[arcana history insight investigation medicine nature religion] }
    }.freeze

    SPECIES = %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling].freeze

    BACKGROUNDS = {
      "Acolyte"  => { ability_bonuses: %i[int wis cha], skill_proficiencies: %i[insight religion] },
      "Criminal" => { ability_bonuses: %i[dex con int], skill_proficiencies: %i[sleight_of_hand stealth] },
      "Sage"     => { ability_bonuses: %i[con int wis], skill_proficiencies: %i[arcana history] },
      "Soldier"  => { ability_bonuses: %i[str dex con], skill_proficiencies: %i[athletics intimidation] }
    }.freeze

    module_function

    def ability_modifier(score)
      (score - 10) / 2
    end

    def proficiency_bonus(level)
      (level - 1) / 4 + 2
    end

    def calculate_hit_points(char_class, level, con_mod)
      die = CLASSES.dig(char_class, :hit_die)
      die + con_mod + (level * (die / 2 + 1 + con_mod))
    end

    def background_bonuses(background)
      BACKGROUNDS.fetch(background, { ability_bonuses: [], skill_proficiencies: [] })
    end

    def proficiency_by_class(character_class)
      CLASSES.dig(character_class, :skills) || []
    end

    def initialize_skills
      ALL_SKILLS.each_with_object({}) { |skill, hash| hash[skill] = 0 }
    end

    def stat_roll
      STANDARD_ARRAY.dup
    end

    def class_skill_count(char_class)
      CLASSES.dig(char_class, :skill_count) || 2
    end

    def calculate_skills(ability_scores, proficiency_bonus, proficient_skills)
      ALL_SKILLS.each_with_object({}) do |skill, hash|
        ability_key = SKILL_ABILITIES[skill]
        base_mod = ability_scores.mod_for(ability_key)
        bonus = proficient_skills.include?(skill) ? proficiency_bonus : 0
        hash[skill] = base_mod + bonus
      end
    end
  end

  module Display
    module_function

    def display_name(sym)
      sym.to_s.split("_").map(&:capitalize).join(" ")
    end
  end

  module Models
    AbilityScores = Data.define(:str, :dex, :con, :int, :wis, :cha) do
      World::ABILITY_NAMES.each do |name|
        define_method(:"#{name}_mod") { World.ability_modifier(send(name)) }
      end

      def mod_for(ability_key)
        World.ability_modifier(send(ability_key))
      end

      def with_bonuses(bonuses = {})
        args = World::ABILITY_NAMES.each_with_object({}) do |name, h|
          h[name] = send(name) + (bonuses[name] || 0)
        end
        self.class.new(**args)
      end

      def to_h
        World::ABILITY_NAMES.each_with_object({}) do |name, h|
          h[name] = send(name)
          h[:"#{name}_mod"] = send(:"#{name}_mod")
        end
      end
    end

    Character = Data.define(
      :name, :level, :species, :char_class, :background,
      :ability_scores, :ac, :proficiency_bonus, :hit_points, :skills
    ) do
      def self.create
        character = Services::CreateCharacter.new.build
        puts "\n#{character}"
        character
      end

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
        lines << "AC: #{ac}  HP: #{hit_points}  Prof Bonus: +#{proficiency_bonus}"
        lines << "Skills:"
        skills.sort_by { |name, _| name }.each do |skill, val|
          lines << "  %-20s %+d" % [Display.display_name(skill), val]
        end
        lines.join("\n")
      end
    end
  end

  module Input
    module_function

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
      World::ABILITY_NAMES[0...-1].each_with_index do |name, i|
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
      bonuses = World.background_bonuses(background)
      candidates = bonuses[:ability_bonuses]
      bg_skills = bonuses[:skill_proficiencies]

      return [ability_scores, bg_skills] if candidates.empty?

      dn = method(:ability_abbrev)
      plus2 = pick_from_list(candidates, "#{background}: Which ability gets +2?", display: dn)
      plus1 = pick_from_list(candidates - [plus2], "#{background}: Which ability gets +1?", display: dn)

      [ability_scores.with_bonuses(plus2 => 2, plus1 => 1), bg_skills]
    end

    def pick_class_skills(char_class, background_skills)
      available = World.proficiency_by_class(char_class) - background_skills
      count = World.class_skill_count(char_class)
      chosen = []

      dn = method(:display_name)
      bg_names = background_skills.map { |s| Display.display_name(s) }.join(", ")
      puts "\n  Background skills: #{bg_names}" unless background_skills.empty?

      count.times do |i|
        chosen << pick_from_list(available - chosen, "#{char_class} skill #{i + 1}/#{count}:", display: dn)
      end
      chosen
    end

    def display_name(sym)
      Display.display_name(sym)
    end
  end

  module Services
    class CreateCharacter
      def build
        puts "D&D Character Creator"
        puts "=" * 30

        char_class = Input.pick_from_list(World::CLASSES.keys, "Choose your class:")
        species    = Input.pick_from_list(World::SPECIES, "Choose your species:")
        background = Input.pick_from_list(World::BACKGROUNDS.keys, "Choose your background:")

        finalstats = Input.assign_stats(World.stat_roll)

        level = 1
        str, dex, con, int, wis, cha = finalstats
        base_scores = Models::AbilityScores.new(str: str, dex: dex, con: con, int: int, wis: wis, cha: cha)

        ability_scores, background_skills = Input.apply_background_bonuses(background, base_scores)
        class_skills = Input.pick_class_skills(char_class, background_skills)
        all_proficient_skills = (background_skills + class_skills).uniq

        prof = World.proficiency_bonus(level)
        hit_points = World.calculate_hit_points(char_class, level, ability_scores.con_mod)
        skills = World.calculate_skills(ability_scores, prof, all_proficient_skills)

        puts "\nWhat is your character's name?"
        name = Input.get_input("Adventurer").to_s.strip
        name = "Adventurer" if name.empty?

        Models::Character.new(
          name: name, level: level, species: species, char_class: char_class, background: background,
          ability_scores: ability_scores, ac: 10 + ability_scores.dex_mod,
          proficiency_bonus: prof, hit_points: hit_points, skills: skills
        )
      end
    end
  end
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  CharacterCreatorKata::Models::Character.create
end
