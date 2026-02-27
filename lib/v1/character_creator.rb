# frozen_string_literal: true

module CharacterCreatorKata
  ABILITIES = %i[str dex con int wis cha].freeze
  SPECIES = %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling].freeze

  SKILLS = %i[
    acrobatics
    animal_handling
    arcana
    athletics
    deception
    history
    insight
    intimidation
    investigation
    medicine
    nature
    perception
    performance
    persuasion
    religion
    sleight_of_hand
    stealth
    survival
  ].freeze

  BACKGROUNDS = {
    "Acolyte" => { abilities: %i[int wis cha], skills: %i[insight religion] },
    "Criminal" => { abilities: %i[dex con int], skills: %i[sleight_of_hand stealth] },
    "Sage" => { abilities: %i[con int wis], skills: %i[arcana history] },
    "Soldier" => { abilities: %i[str dex con], skills: %i[athletics intimidation] },
  }.freeze

  CLASSES = {
    "Barbarian" => { hd: 12, skill_count: 2, skills: %i[animal_handling athletics intimidation nature perception survival] },
    "Bard" => { hd: 8, skill_count: 3, skills: %i[athletics acrobatics sleight_of_hand stealth arcana history investigation nature religion religion animal_handling insight medicine perception survival deception intimidation performance persuasion] },
    "Cleric" => { hd: 8, skill_count: 2, skills: %i[history insight medicine persuasion religion] },
    "Druid" => { hd: 8, skill_count: 2, skills: %i[arcana animal_handling insight medicine nature perception religion survival] },
    "Fighter" => { hd: 10, skill_count: 2, skills: %i[acrobatics animal_handling athletics history insight intimidation perception persuasion survival] },
    "Monk" => { hd: 8, skill_count: 2, skills: %i[acrobatics athletics history insight religion stealth] },
    "Paladin" => { hd: 10, skill_count: 2, skills: %i[athletics insight intimidation medicine persuasion religion] },
    "Ranger" => { hd: 10, skill_count: 3, skills: %i[animal_handling athletics insight investigation nature perception stealth survival] },
    "Rogue" => { hd: 8, skill_count: 4, skills: %i[acrobatics athletics deception insight intimidation investigation perception persuasion sleight_of_hand stealth] },
    "Sorcerer" => { hd: 6, skill_count: 2, skills: %i[arcana deception insight intimidation persuasion religion] },
    "Warlock" => { hd: 8, skill_count: 2, skills: %i[arcana deception history intimidation investigation nature religion] },
    "Wizard" => { hd: 6, skill_count: 2, skills: %i[arcana history insight investigation medicine nature religion] },
  }.freeze

  class Input
    class << self
      def pick_stats(stats)
        result =
          ABILITIES[0..-2].map.with_index { |stat_name, index|
            print "\nRemaining stats: "
            puts stats.join(", ")
            stat = pick_stat(stats, "Pick #{stat_name.upcase}: ")
            stats.delete_at(stats.index(stat))
            stat
          } + stats

        puts "\nCHA (auto): #{stats.last}"

        result
      end

      def pick_stat(stats, prompt)
        print prompt

        loop do
          response = get_input(stats.first)
          match = stats.find { it == response.to_i }
          return match if match

          puts "Please select one of the available numbers"
        end
      end

      def pick_options(options, count, base_prompt)
        options = options.dup
        count.times.map do |i|
          prompt = "#{base_prompt} (#{i + 1}/#{count}): "
          option = pick_option(options, prompt)
          options.delete_at(options.index(option))
          option
        end
      end

      def pick_option(options, prompt)
        match = nil
        puts
        options.each.with_index(1) do |option, i|
          puts "#{i}. #{option}"
        end
        print prompt
        loop do
          response = get_input("1")
          match = options[response.to_i - 1] if response.to_i >= 1
          return match if match

          match = options.find { it.downcase == response.downcase }
          return match if match

          match = options.find { it.downcase.include?(response.downcase) }
          return match if match

          puts "Please select an option from the list"
        end
      ensure
        puts "Selected: #{match}"
      end

      def get_input(default)
        puts default
        default
      end

      def format_skill(skill_id) = skill_id.to_s.split("_").map(&:capitalize).join(" ")
      def to_skill_id(skill) = skill.downcase.gsub(" ", "_")

      def stat_roll = [15, 14, 13, 12, 10, 8]
    end
  end

  class CreateCharacter
    def run
      puts "Welcome to the D&D Character Creator!"
      puts "=" * 40

      character_class = pick_class
      species = pick_species
      background = pick_background
      level = pick_level
      name = pick_name
      stats = pick_stats(background)
      skills = pick_skills(character_class, background)

      Character.new(
        name:,
        level:,
        species:,
        character_class:,
        background:,
        stats:,
        skills:,
      )
    end

    private

    def pick_class
      Input.pick_option(CLASSES.keys, "Pick class: ")
    end

    def pick_species
      Input.pick_option(SPECIES, "Pick species: ")
    end

    def pick_background
      result = Input.pick_option(BACKGROUNDS.keys, "Pick background: ")
      background_skills = BACKGROUNDS[result][:skills]
      formatted_skills = background_skills.map { Input.format_skill(it) }.join(", ")
      puts "Background Skills: #{formatted_skills}"
      result
    end

    def pick_level
      print "\nPick level (1-20): "
      Input.get_input("1").to_i.clamp(1..20)
    end

    def pick_name
      print "\nPick name: "
      Input.get_input("Adventurer")
    end

    def roll_stats
      stats = Input.stat_roll
      puts "\nYou rolled: #{stats.join(", ")}"
      stats
    end

    def pick_stats(background)
      background_abilities = BACKGROUNDS[background][:abilities]
      picked_stats = Input.pick_stats(roll_stats)
      ABILITIES.zip(picked_stats).map do |ability, picked_stat|
        (background_abilities.include?(ability) ? 1 : 0) + picked_stat
      end
    end

    def pick_skills(character_class, background)
      class_skills = CLASSES[character_class][:skills]
      skill_count = CLASSES[character_class][:skill_count]
      background_skills = BACKGROUNDS[background][:skills]
      available_skills = (class_skills - background_skills).map { Input.format_skill(it) }
      picked_skills = Input.pick_options(available_skills, skill_count, "Pick skill").map { Input.to_skill_id(it) }
      background_skills + picked_skills
    end
  end

  class Character < Struct.new(
    :name,
    :level,
    :species,
    :character_class,
    :background,
    :stats,
    :skills,
  )
    def self.create = CreateCharacter.new.run

    def hp = hd + con_mod + ((level - 1) * ((hd / 2) + 1 + con_mod))
    def hd = CLASSES[character_class][:hd]
    def ac = 10 + dex_mod
    def prof = ((level - 1) / 4) + 2

    ABILITIES.each.with_index do |stat, i|
      define_method(stat) { stats[i] }
      define_method("#{stat}_mod") { mod_of(stats[i]) }
    end

    def print
      puts "\n#{"=" * 40}"
      puts "Character Created!"
      puts "=" * 40
      puts format("%20s: %s", "Name", name)
      puts format("%20s: %s", "Level", level)
      puts format("%20s: %s", "Species", species)
      puts format("%20s: %s", "Class", character_class)
      puts format("%20s: %s", "Background", background)
      puts
      puts format("%20s: %s", "HP", hp)
      puts format("%20s: %s", "AC", ac)
      puts format("%20s: %+i", "Proficiency Bonus", prof)
      puts
      puts format("%20s: %s", "Skills", formatted_skills)
      puts
      ABILITIES.each.with_index do |stat, i|
        puts format("%20s: %2i (%+i)", stat.to_s.upcase, send(stat), send("#{stat}_mod"))
      end
    end

    private

    def formatted_skills
      skills.map { it.to_s.split("_").map(&:capitalize).join(" ") }.sort.join(", ")
    end

    def mod_of(stat) = (stat - 10) / 2
  end
end

if __FILE__ == $PROGRAM_NAME
  include CharacterCreatorKata

  Character.create.print
end
