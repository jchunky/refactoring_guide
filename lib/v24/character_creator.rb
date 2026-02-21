# frozen_string_literal: true

require "delegate"

module CharacterCreatorKata
  module World
    ABILITIES = %i[
      str
      dex
      con
      int
      wis
      cha
    ].freeze

    module Ability
      def self.format(id) = id.to_s.upcase
    end

    SKILLS = {
      acrobatics: { ability: :dex },
      animal_handling: { ability: :wis },
      arcana: { ability: :int },
      athletics: { ability: :str },
      deception: { ability: :cha },
      history: { ability: :int },
      insight: { ability: :wis },
      intimidation: { ability: :cha },
      investigation: { ability: :int },
      medicine: { ability: :wis },
      nature: { ability: :int },
      perception: { ability: :wis },
      performance: { ability: :cha },
      persuasion: { ability: :cha },
      religion: { ability: :int },
      sleight_of_hand: { ability: :dex },
      stealth: { ability: :dex },
      survival: { ability: :wis },
    }.freeze

    module Skill
      def self.all = SKILLS.keys
      def self.ability(name) = SKILLS[name][:ability]
      def self.format(id) = to_name(id)
      def self.to_name(id) = id.to_s.gsub("_", " ").split.map(&:capitalize).join(" ")
      def self.to_id(name) = name.downcase.split.join("_").to_sym
    end

    BACKGROUNDS = {
      "Acolyte" => { abilities: %i[int wis cha], skills: %i[insight religion] },
      "Criminal" => { abilities: %i[dex con int], skills: %i[sleight_of_hand stealth] },
      "Sage" => { abilities: %i[con int wis], skills: %i[arcana history] },
      "Soldier" => { abilities: %i[str dex con], skills: %i[athletics intimidation] },
    }.freeze

    module Background
      def self.all = BACKGROUNDS.keys
      def self.abilities(name) = BACKGROUNDS[name][:abilities]
      def self.skills(name) = BACKGROUNDS[name][:skills]
    end

    CHARACTER_CLASSES = {
      "Barbarian" => { hd: 12, abilities: %i[str con], skill_count: 2, skills: %i[animal_handling athletics intimidation nature perception survival] },
      "Bard" => { hd: 8, abilities: %i[dex cha], skill_count: 3, skills: Skill.all },
      "Cleric" => { hd: 8, abilities: %i[wis cha], skill_count: 2, skills: %i[history insight medicine persuasion religion] },
      "Druid" => { hd: 8, abilities: %i[int wis], skill_count: 2, skills: %i[arcana animal_handling insight medicine nature perception religion survival] },
      "Fighter" => { hd: 10, abilities: %i[str dex], skill_count: 2, skills: %i[acrobatics animal_handling athletics history insight intimidation perception persuasion survival] },
      "Monk" => { hd: 8, abilities: %i[str dex], skill_count: 2, skills: %i[acrobatics athletics history insight religion stealth] },
      "Paladin" => { hd: 10, abilities: %i[wis cha], skill_count: 2, skills: %i[athletics insight intimidation medicine persuasion religion] },
      "Ranger" => { hd: 10, abilities: %i[str dex], skill_count: 3, skills: %i[animal_handling athletics insight investigation nature perception stealth survival] },
      "Rogue" => { hd: 8, abilities: %i[dex int], skill_count: 4, skills: %i[acrobatics athletics deception insight intimidation investigation perception persuasion sleight_of_hand stealth] },
      "Sorcerer" => { hd: 6, abilities: %i[con cha], skill_count: 2, skills: %i[arcana deception insight intimidation persuasion religion] },
      "Warlock" => { hd: 8, abilities: %i[wis cha], skill_count: 2, skills: %i[arcana deception history intimidation investigation nature religion] },
      "Wizard" => { hd: 6, abilities: %i[int wis], skill_count: 2, skills: %i[arcana history insight investigation medicine nature religion] },
    }.freeze

    module CharacterClass
      def self.all = CHARACTER_CLASSES.keys
      def self.hd(name) = CHARACTER_CLASSES[name][:hd]
      def self.abilities(name) = CHARACTER_CLASSES[name][:abilities]
      def self.skill_count(name) = CHARACTER_CLASSES[name][:skill_count]
      def self.skills(name) = CHARACTER_CLASSES[name][:skills]
    end

    SPECIES = {
      "Dragonborn" => { speed: 30 },
      "Dwarf" => { speed: 30 },
      "Elf" => { speed: 30 },
      "Gnome" => { speed: 30 },
      "Goliath" => { speed: 35 },
      "Halfling" => { speed: 30 },
      "Human" => { speed: 30 },
      "Orc" => { speed: 30 },
      "Tiefling" => { speed: 30 },
    }.freeze

    module Species
      def self.all = SPECIES.keys
      def self.speed(name) = SPECIES[name][:speed]
    end
  end

  class Character < Data.define(:name, :level, :species, :character_class, :background, :proficient_skills, :stats)
    include World

    def self.create = CreateCharacter.new.run

    def print = DisplayCharacter.new(self).run

    def ac = 10 + dex_mod
    def hp = hd + con_mod + ((level - 1) * ((hd / 2) + 1 + con_mod))
    def proficiency_bonus = ((level - 1) / 4) + 2
    def speed = Species.speed(species)
    def initiative = dex_mod
    def passive_perception = 10 + perception
    def passive_investigation = 10 + investigation
    def passive_insight = 10 + insight

    ABILITIES.each_with_index do |ability, i|
      define_method(ability) { stats[i] }
      define_method("#{ability}_mod") { mod_of(stats[i]) }
    end

    Skill.all.map do |skill|
      define_method(skill) do
        ability = Skill.ability(skill)
        score = send(ability)
        mod = mod_of(score)
        prof = proficient_skills.include?(skill)
        mod += proficiency_bonus if prof
        mod
      end
    end

    def ability_scores
      ABILITIES.map do |ability|
        score = send(ability)
        mod = mod_of(score)
        [ability, score, mod]
      end
    end

    def savings_throws
      ABILITIES.map do |ability|
        score = send(ability)
        mod = mod_of(score)
        prof = class_abilities.include?(ability)
        mod += proficiency_bonus if prof
        [ability, mod, prof]
      end
    end

    def skills
      Skill.all.map do |skill|
        ability = Skill.ability(skill)
        mod = send(skill)
        prof = proficient_skills.include?(skill)
        [skill, ability, mod, prof]
      end
    end

    private

    def hd = CharacterClass.hd(character_class)
    def mod_of(stat) = (stat / 2) - 5
    def class_abilities = CharacterClass.abilities(character_class)
  end

  class DisplayCharacter < SimpleDelegator
    include World

    def run
      print_title "Character"
      puts format("%23s: %s", "Name", name)
      puts format("%23s: %s", "Level", level)
      puts format("%23s: %s", "Species", species)
      puts format("%23s: %s", "Class", character_class)
      puts format("%23s: %s", "Background", background)
      puts format("%23s: %s", "Proficiency Bonus", mod(proficiency_bonus))
      puts format("%23s: %s ft", "Speed", speed)
      puts
      puts format("%23s: %s", "AC", ac)
      puts format("%23s: %s", "HP", hp)
      puts format("%23s: %s", "Initiative", mod(initiative))
      puts
      puts format("%23s: %d", "Passive Perception", passive_perception)
      puts format("%23s: %d", "Passive Investigation", passive_investigation)
      puts format("%23s: %d", "Passive Insight", passive_insight)

      print_title "Abilities"
      ability_scores.each do |ability, score, mod|
        puts format("%23s: %2d (%s)", Ability.format(ability), score, mod(mod))
      end

      print_title "Saving Throws"
      savings_throws.each do |ability, mod, prof|
        puts format("%23s: %s %s", Ability.format(ability), mod(mod), prof(prof))
      end

      print_title "Skills"
      skills.each do |skill, ability, mod, prof|
        puts format("%17s (%s): %+i %s", Skill.format(skill), Ability.format(ability), mod(mod), prof(prof))
      end
    end

    private

    def print_title(title)
      puts
      puts ["-" * 4, title, "-" * 4].join(" ").center(48)
    end

    def mod(value)
      format("%+i", value)
    end

    def prof(value)
      value ? "<prof>" : ""
    end
  end

  module Input
    class << self
      include World

      def pick_skills(skills, skill_count)
        skills = skills.dup
        skill_count.times.map do |i|
          prompt = format("Pick skill (%i of %i): ", i + 1, skill_count)
          skill_names = skills.map { |skill| Skill.to_name(skill) }
          skill = Skill.to_id(pick_option(skill_names, prompt))
          skills.delete(skill)
          skill
        end
      end

      def pick_stats(input_stats)
        with_confirmation do
          final_stats = []
          stats = input_stats.dup

          ABILITIES[0..-2].each.with_index do |ability, i|
            stat = pick_stat(stats, ability)
            final_stats << stat
            stats.delete_at(stats.index(stat))
          end

          final_stats += stats

          puts
          puts "Your stats:"
          ABILITIES.zip(final_stats).each do |ability, stat|
            puts format("%s: %2d", Ability.format(ability), stat)
          end

          final_stats
        end
      end

      def pick_option(options, prompt)
        pick_option_inner(options, prompt)
          .tap { puts "Selected: #{it}" }
      end

      def get_input(default)
        puts default
        default.to_s
        # gets.chomp
      end

      def stat_roll
        [15, 14, 13, 12, 10, 8]
      end

      private

      def pick_stat(stats, ability)
        puts
        puts format("Remaining stats: %s", stats.join(", "))
        print "Pick stat for #{Ability.format(ability)}: "

        loop do
          stat = get_input(stats.first)
          match = stats.find { it.to_s == stat }
          return match if match

          puts "Please select one of the available numbers"
        end
      end

      def pick_option_inner(options, prompt)
        puts
        options.each.with_index(1) do |option, index|
          puts format("%i. %s", index, option)
        end
        print prompt
        loop do
          input = get_input("1")
          match = input.to_i - 1
          return options[match] if (0...options.size).cover?(match)

          match = options.find { it.to_s.downcase == input.downcase }
          return match if match

          match = options.find { it.to_s.downcase.include?(input).downcase }
          return match if match

          puts "Please select an option from the list"
        end
      end

      def with_confirmation
        loop do
          result = yield
          return result if confirmed?
        end
      end

      def confirmed?
        print "Are you satisfied with this (y/n)? "
        loop do
          input = get_input("y")
          return true if input == "y"
          return false if input == "n"

          puts "Please select 'y' to complete this process or 'n' to start over"
        end
      end
    end
  end

  class CreateCharacter
    include World

    def run
      puts
      puts "=" * 40
      puts "Welcome to the D&D Character Creator!"
      puts "=" * 40

      character_class = pick_character_class
      species = pick_species
      background = pick_background
      proficient_skills = pick_skills(character_class, background)
      raw_stats = pick_stats
      level = pick_level
      name = pick_name
      stats = aggregated_stats(raw_stats, background)

      Character.new(
        name:,
        level:,
        species:,
        character_class:,
        background:,
        proficient_skills:,
        stats:,
      )
    end

    private

    def pick_stats
      stats = Input.stat_roll
      puts
      puts "You rolled: #{stats.join(", ")}"
      Input.pick_stats(stats)
    end

    def pick_name
      puts
      print "Pick name: "
      Input.get_input("Adventurer")
    end

    def pick_background
      Input.pick_option(Background.all, "Pick background: ")
    end

    def pick_character_class
      Input.pick_option(CharacterClass.all, "Pick class: ")
    end

    def pick_species
      Input.pick_option(Species.all, "Pick species: ")
    end

    def pick_skills(character_class, background)
      class_skills = CharacterClass.skills(character_class)
      background_skills = Background.skills(background)
      skills = class_skills - background_skills
      skill_count = CharacterClass.skill_count(character_class)
      picked_skills = Input.pick_skills(skills, skill_count)
      picked_skills + background_skills
    end

    def pick_level
      puts
      print "Pick level (1-20): "
      Input.get_input("1").to_i.clamp(1, 20)
    end

    def aggregated_stats(raw_stats, background)
      background_abilities = Background.abilities(background)
      ABILITIES.zip(raw_stats).map do |ability, stat|
        stat + (background_abilities.include?(ability) ? 1 : 0)
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  CharacterCreatorKata::Character.create.print
end
