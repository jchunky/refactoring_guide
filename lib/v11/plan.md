# v11 Refactoring Plan

## Prompt Focus
Code smell priorities: Feature Envy → Long Parameter Lists → Primitive Obsession → Data Clumps

## Changes by File

### yatzy.rb — Long Parameter Lists / Data Clumps
- **Problem**: Nearly every class method took `(d1, d2, d3, d4, d5)` — five individual dice params. Mixed class/instance API was inconsistent.
- **Fix**: Unified all scoring logic as instance methods operating on `@dice`. Class methods become thin delegators (`new(...).method`) to preserve test interface. Memoized `tally` for efficiency. The five individual dice parameters (a data clump) now always travel together as `@dice`.

### tennis.rb — Primitive Obsession / Data Clumps
- **Problem**: Player name + points stored as separate primitives (`@p1_points`, `@player1_name`). Data always traveled in pairs.
- **Fix**: Extracted `Player` class with `name`, `points`, and `score_name`. All three game classes now use Player objects. Added `player_for(name)` helper to route point updates. Eliminated duplicate primitive lookups.

### theatrical_players.rb — Feature Envy / Primitive Obsession
- **Problem**: `amount_for` and `volume_credits_for` reached deep into performance/play hash data. Raw hashes used everywhere.
- **Fix**: Created `Play` class (wraps name/type, adds `comedy?`/`tragedy?`). Created `Performance` class (wraps audience + play, owns `amount` and `volume_credits` calculations). `statement` now builds Performance objects and asks them for their data instead of reaching into hashes.

### parrot.rb — Long Parameter Lists
- **Problem**: `Parrot.new(type, number_of_coconuts, voltage, nailed)` passed all 4 params to every subclass, but each only used a subset.
- **Fix**: Each subclass constructor now accepts only its relevant params. `EuropeanParrot` takes none, `AfricanParrot` takes `number_of_coconuts`, `NorwegianBlueParrot` takes `voltage` and `nailed`. Factory method in `Parrot.new` routes params appropriately.

### trivia.rb — Primitive Obsession / Data Clumps
- **Problem**: Parallel arrays (`@places`, `@purses`, `@in_penalty_box`) indexed by player number. Player data always traveled together.
- **Fix**: Extracted `Player` class with `name`, `place`, `purse`, `in_penalty_box` attributes plus behavior (`advance`, `earn_coin`, `won?`). Replaced parallel arrays with `@players` array of Player objects.

### character_creator.rb — Long Parameter Lists / Data Clumps / Primitive Obsession
- **Problem**: `DnDchars.new` took 20+ positional arguments. Six ability scores + modifiers were a massive data clump. Raw integers used for stats.
- **Fix**: Created `Stat` class (value + derived modifier). Created `AbilityScores` class grouping all 6 stats. `DnDchars` now uses keyword arguments and accepts an `AbilityScores` object instead of 12 separate stat/modifier params. Convenience delegator methods preserved for backward compatibility.

### namer.rb — Feature Envy (minor)
- **Problem**: `xyz_filename` accessed 6+ properties from `target` object to build a filename string.
- **Fix**: Extracted `FilenameBuilder` class that takes `target` in constructor and provides named methods for each filename segment. Reduces feature envy by giving the builder responsibility for formatting decisions.

### No changes needed
- **bottles.rb** — Well-structured, no significant smells
- **english_number.rb** — Simple algorithm, no OO smells
- **gilded_rose.rb** — Already well-refactored with strategy pattern
- **medicine_clash.rb** — Already has good OO design with proper classes
