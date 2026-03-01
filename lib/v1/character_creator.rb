module CharacterCreatorKata
  CLASSES = %w[Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard].freeze
  SPECIES = %w[Dragonborn Dwarf Elf Gnome Goliath Halfling Human Orc Tiefling].freeze
  BACKGROUNDS = %w[Acolyte Criminal Sage Soldier].freeze

  BACKGROUND_DATA = {
    "Acolyte" => { ability_bonuses: %w[Intelligence Wisdom Charisma], skills: %w[Insight Religion] },
    "Criminal" => { ability_bonuses: %w[Dexterity Constitution Intelligence], skills: ["Sleight of Hand", "Stealth"] },
    "Sage" => { ability_bonuses: %w[Constitution Intelligence Wisdom], skills: %w[Arcana History] },
    "Soldier" => { ability_bonuses: %w[Strength Dexterity Constitution], skills: %w[Athletics Intimidation] }
  }.freeze

  CLASS_SKILLS = {
    "Barbarian" => ["Animal Handling", "Athletics", "Intimidation", "Nature", "Perception", "Survival"],
    "Bard" => ["Acrobatics", "Animal Handling", "Arcana", "Athletics", "Deception", "History", "Insight", "Intimidation", "Investigation", "Medicine", "Nature", "Perception", "Performance", "Persuasion", "Religion", "Sleight of Hand", "Stealth", "Survival"],
    "Cleric" => ["History", "Insight", "Medicine", "Persuasion", "Religion"],
    "Druid" => ["Animal Handling", "Arcana", "Insight", "Medicine", "Nature", "Perception", "Religion", "Survival"],
    "Fighter" => ["Acrobatics", "Animal Handling", "Athletics", "History", "Insight", "Intimidation", "Perception", "Persuasion", "Survival"],
    "Monk" => ["Acrobatics", "Athletics", "History", "Insight", "Religion", "Stealth"],
    "Paladin" => ["Athletics", "Insight", "Intimidation", "Medicine", "Persuasion", "Religion"],
    "Ranger" => ["Animal Handling", "Athletics", "Insight", "Investigation", "Nature", "Perception", "Stealth", "Survival"],
    "Rogue" => ["Acrobatics", "Athletics", "Deception", "Insight", "Intimidation", "Investigation", "Perception", "Persuasion", "Sleight of Hand", "Stealth"],
    "Sorcerer" => ["Arcana", "Deception", "Insight", "Intimidation", "Persuasion", "Religion"],
    "Warlock" => ["Arcana", "Deception", "History", "Intimidation", "Investigation", "Nature", "Religion"],
    "Wizard" => ["Arcana", "History", "Insight", "Investigation", "Medicine", "Nature", "Religion"]
  }.freeze

  CLASS_SKILL_COUNT = {
    "Barbarian" => 2, "Bard" => 3, "Cleric" => 2, "Druid" => 2,
    "Fighter" => 2, "Monk" => 2, "Paladin" => 2, "Ranger" => 3,
    "Rogue" => 4, "Sorcerer" => 2, "Warlock" => 2, "Wizard" => 2
  }.freeze

  HIT_DIE = {
    "Barbarian" => 12,
    "Fighter" => 10, "Paladin" => 10, "Ranger" => 10,
    "Bard" => 8, "Cleric" => 8, "Druid" => 8, "Monk" => 8, "Rogue" => 8, "Warlock" => 8,
    "Sorcerer" => 6, "Wizard" => 6
  }.freeze

  ABILITY_SHORT = {
    "Strength" => "STR", "Dexterity" => "DEX", "Constitution" => "CON",
    "Intelligence" => "INT", "Wisdom" => "WIS", "Charisma" => "CHA"
  }.freeze

  def get_input(default)
    puts default
    default.to_s
  end

  def mod_calc(stat)
    (stat - 10) / 2
  end

  def pick_from_list(items, prompt)
    items.each_with_index { |item, i| puts "#{i + 1}. #{item}" }
    print "Pick #{prompt}: "
    choice = get_input(1).to_i
    selected = items[choice - 1]
    puts "Selected: #{selected}"
    selected
  end

  def main
    puts "Welcome to the D&D Character Creator!"
    puts "=" * 40

    puts
    charclass = pick_from_list(CLASSES, "class")

    puts
    species = pick_from_list(SPECIES, "species")

    puts
    background = pick_from_list(BACKGROUNDS, "background")
    bg_data = BACKGROUND_DATA[background]
    bg_skills = bg_data[:skills]
    puts "Background Skills: #{bg_skills.join(', ')}"

    puts
    print "Pick level (1-20): "
    level = get_input(1).to_i

    puts
    print "Pick name: "
    name = get_input("Adventurer")

    puts
    stats = [15, 14, 13, 12, 10, 8]
    puts "You rolled: #{stats.join(', ')}"

    remaining = stats.dup
    assigned = {}
    %w[STR DEX CON INT WIS].each do |stat_name|
      puts
      puts "Remaining stats: #{remaining.join(', ')}"
      print "Pick #{stat_name}: "
      choice = get_input(remaining.first).to_i
      remaining.delete_at(remaining.index(choice))
      assigned[stat_name] = choice
    end

    puts
    puts "CHA (auto): #{remaining.first}"
    assigned["CHA"] = remaining.first

    bg_data[:ability_bonuses].each do |ability|
      short = ABILITY_SHORT[ability]
      assigned[short] += 1
    end

    mods = {}
    assigned.each { |k, v| mods[k] = mod_calc(v) }

    hd = HIT_DIE[charclass]
    hp = hd + mods["CON"] + ((level - 1) * (hd / 2 + 1 + mods["CON"]))
    ac = 10 + mods["DEX"]
    prof = case level
           when 1..4 then 2
           when 5..8 then 3
           when 9..12 then 4
           when 13..16 then 5
           else 6
           end

    available_skills = CLASS_SKILLS[charclass].reject { |s| bg_skills.include?(s) }
    num_skills = CLASS_SKILL_COUNT[charclass]
    chosen_skills = []
    num_skills.times do |i|
      puts
      available_skills.each_with_index { |s, j| puts "#{j + 1}. #{s}" }
      print "Pick skill (#{i + 1}/#{num_skills}): "
      choice = get_input(1).to_i
      selected = available_skills[choice - 1]
      puts "Selected: #{selected}"
      chosen_skills << selected
      available_skills.delete(selected)
    end

    all_skills = (chosen_skills + bg_skills).sort

    puts
    puts "=" * 40
    puts "Character Created!"
    puts "=" * 40
    puts "%20s: %s" % ["Name", name]
    puts "%20s: %s" % ["Level", level]
    puts "%20s: %s" % ["Species", species]
    puts "%20s: %s" % ["Class", charclass]
    puts "%20s: %s" % ["Background", background]
    puts
    puts "%20s: %s" % ["HP", hp]
    puts "%20s: %s" % ["AC", ac]
    puts "%20s: +%s" % ["Proficiency Bonus", prof]
    puts
    puts "%20s: %s" % ["Skills", all_skills.join(', ')]
    puts
    %w[STR DEX CON INT WIS CHA].each do |stat|
      puts "%20s: %2d (%+d)" % [stat, assigned[stat], mods[stat]]
    end
  end
end

if __FILE__ == $0
  include CharacterCreatorKata
  main
end
