module CharacterCreatorKata
  require "active_support/all"

  # ═══════════════════════════════════════════════════════════════
  # FUNCTIONAL CORE
  #
  # Pure functions and value objects. No I/O, no mutation, no side
  # effects. Given the same inputs, always returns the same outputs.
  # Trivially testable without mocks or stubs.
  # ═══════════════════════════════════════════════════════════════

  module Core
    HIT_DICE = {
      "Barbarian" => 12,
      "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
      "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
      "Sorcerer" => 6, "Wizard" => 6
    }.freeze

    CLASSES = HIT_DICE.keys.sort.freeze

    SPECIES = %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling].freeze

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

    # ── Pure Calculations ────────────────────────────────────────

    def self.modifier(stat) = (stat - 10) / 2

    def self.proficiency_bonus(level) = (level - 1) / 4 + 2

    def self.armor_class(dex_mod) = 10 + dex_mod

    def self.hit_points(char_class, level, con_mod)
      die = HIT_DICE.fetch(char_class)
      die + con_mod + level * (die / 2 + 1 + con_mod)
    end

    def self.compute_stats(dice_groups)
      dice_groups.map { |rolls| rolls.sort.drop(1).sum }
    end

    # ── Pure Data Lookups ────────────────────────────────────────

    def self.background_bonuses(background)
      BACKGROUND_DATA.fetch(background, { abilities: [], skills: [] })
    end

    def self.class_skill_options(char_class)
      CLASS_SKILLS.fetch(char_class, [])
    end

    def self.initial_skills
      SKILLS.each_with_object({}) { |s, h| h[s] = 0 }
    end

    # ── Value Object ─────────────────────────────────────────────

    Character = Data.define(
      :name, :level, :species, :char_class, :background,
      :str, :strmod, :dex, :dexmod, :con, :conmod,
      :int, :intmod, :wis, :wismod, :cha, :chamod,
      :ac, :prof, :hit_points, :skills
    )

    def self.build_character(name:, level:, species:, char_class:, background:, abilities:)
      str, dex, con, int, wis, cha = abilities
      strmod, dexmod, conmod, intmod, wismod, chamod = abilities.map { |a| modifier(a) }

      Character.new(
        name:, level:, species:, char_class:, background:,
        str:, strmod:, dex:, dexmod:, con:, conmod:,
        int:, intmod:, wis:, wismod:, cha:, chamod:,
        ac: armor_class(dexmod),
        prof: proficiency_bonus(level),
        hit_points: hit_points(char_class, level, conmod),
        skills: initial_skills
      )
    end
  end

  # ═══════════════════════════════════════════════════════════════
  # IMPERATIVE SHELL
  #
  # Thin orchestration layer. Handles all I/O (user prompts, dice
  # rolling, display). Delegates every decision and computation
  # to the Core. Contains no business logic of its own.
  # ═══════════════════════════════════════════════════════════════

  module Shell
    def self.get_input(default)
      puts default
      default
    end

    def self.pick_from(label, options)
      puts options
      puts "What #{label} is your character? "
      choice = ""
      until options.include?(choice)
        choice = get_input(options.first).to_s.split(/ |_|-/).map(&:capitalize).join(" ").chomp
        puts "please select an option from the list" unless options.include?(choice)
      end
      choice
    end

    def self.roll_dice
      6.times.map { 4.times.map { rand(1..6) } }
    end

    def self.assign_stats(available)
      loop do
        remaining = available.dup
        chosen = []

        Core::STAT_NAMES[0..4].each do |stat_name|
          puts "These are your #{chosen.empty? ? "" : "remaining "}stats: "
          puts remaining.compact
          puts "Which number would you like to be your #{stat_name} stat? "

          picked = nil
          until picked
            input = get_input(remaining.compact.first).to_i
            idx = remaining.index(input)
            if idx
              picked = input
              remaining[idx] = nil
              remaining.compact!
            else
              puts "Please select one of the available numbers"
            end
          end
          chosen << picked
        end

        chosen << remaining.compact.first

        puts "So your stats are Strength: #{chosen[0]}, Dexterity: #{chosen[1]}, Constitution: #{chosen[2]}, " \
             "Intelligence: #{chosen[3]}, Wisdom: #{chosen[4]}, and Charisma: #{chosen[5]}"

        puts "Are you satisfied with this? (y/n)"
        finish = ""
        until %w[y n].include?(finish)
          finish = get_input("y").chomp
          puts "Please select y to complete this process or n to start over" unless %w[y n].include?(finish)
        end

        return chosen if finish == "y"
      end
    end

    def self.pick_proficiencies(options, count: 3)
      available = options.dup
      ordinals = %w[first second third fourth fifth]
      selected = []

      count.times do |i|
        puts "These are your #{i.zero? ? "" : "remaining "}skills: "
        puts available
        puts "Which skill would you like to choose as your #{ordinals[i]} proficiency (case sensitive)"

        chosen = nil
        until chosen
          input = get_input(available.first).chomp
          if available.include?(input)
            chosen = input
            available.delete(input)
            selected << chosen
          else
            puts "please select one of the offered skills (case sensitive)"
          end
        end
      end
      selected
    end

    def self.display_character(character)
      puts "\n" + "=" * 40
      puts "Character Created!"
      puts "=" * 40
      character.to_h.each { |k, v| puts "  #{k}: #{v}" }
    end

    def self.run
      puts "Welcome to the D&D Character Creator!"
      puts "=" * 40

      char_class = pick_from("class", Core::CLASSES)
      species    = pick_from("species", Core::SPECIES)
      background = pick_from("background", Core::BACKGROUNDS)

      dice_rolls = roll_dice
      stats = Core.compute_stats(dice_rolls)
      puts "You rolled: #{stats.inspect}"

      abilities = assign_stats(stats)

      puts "\nWhat is your character's name?"
      name = get_input("Adventurer")

      character = Core.build_character(
        name:, level: 1, species:, char_class:, background:, abilities:
      )

      display_character(character)
      character
    end
  end

  # ═══════════════════════════════════════════════════════════════
  # MODULE-LEVEL DELEGATES
  #
  # Preserve the original module API so the code can be included
  # and called the same way. Each method delegates to Core or Shell.
  # ═══════════════════════════════════════════════════════════════

  def get_input(default) = Shell.get_input(default)

  def hitpointcalculator(char_class, level, con) = Core.hit_points(char_class, level, con)
  def my_modcalc(stat) = Core.modifier(stat)
  def proficiency(level) = Core.proficiency_bonus(level)
  def skillpopulator = Core.initial_skills
  def background_bonuses(background) = Core.background_bonuses(background)
  def proficiency_by_class(character_class) = Core.class_skill_options(character_class)

  def classpick = Shell.pick_from("class", Core::CLASSES)
  def speciespick = Shell.pick_from("species", Core::SPECIES)
  def backgroundpick = Shell.pick_from("background", Core::BACKGROUNDS)
  def statroll = Shell.roll_dice.then { |dice| Core.compute_stats(dice) }
  def statpick(stats) = Shell.assign_stats(stats)
  def profpicker = Shell.pick_proficiencies(Core::SKILLS)

  DnDchars = Core::Character
end

# Allow running this file directly for manual testing
if __FILE__ == $0
  CharacterCreatorKata::Shell.run
end
