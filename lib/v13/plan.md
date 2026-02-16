# v13 Refactoring Plan

## Applied Techniques

### 1. Data.define Value Objects & Polymorphic Factory Methods
- **bottles.rb**: `BottleNumber` hierarchy with `Data.define(:number)`, factory `self.for`, subclasses `Zero` and `One` encapsulating verse behavior
- **gilded_rose.rb**: `Updater` hierarchy with `Data.define(:item)`, factory `self.for` dispatching to `AgedBrie`, `BackstagePass`, `Sulfuras`, `Normal`
- **theatrical_players.rb**: `Play` hierarchy with `Data.define(:name, :type)`, factory `self.for` dispatching to `Tragedy` and `Comedy` with polymorphic `amount`/`credits`
- **parrot.rb**: Polymorphic class hierarchy with factory `self.new` dispatching to `European`, `African`, `NorwegianBlue`
- **medicine_clash.rb**: `Prescription` as `Data.define(:dispense_date, :days_supply)` value object

### 2. Polymorphism Replacing Type-Checking Conditionals
- **bottles.rb**: Eliminated if/elsif chain with `BottleNumber::Zero`, `One` subclasses
- **gilded_rose.rb**: Eliminated deeply nested if/else with `Updater` subclass hierarchy
- **parrot.rb**: Replaced `case @type` with subclass dispatch via factory
- **theatrical_players.rb**: Replaced `case play['type']` with `Play::Tragedy`/`Play::Comedy`

### 3. Duplication Elimination
- **tennis.rb**: Extracted shared `TennisScoring` module used by all 3 game classes
- **yatzy.rb**: Unified ones/twos/threes/fours/fives/sixes via `count_value` helper; unified three/four_of_a_kind via `n_of_a_kind`
- **character_creator.rb**: Consolidated repeated pick/stat-assignment loops, data-driven constants
- **trivia.rb**: Unified category question generation, extracted `move_player`/`advance_player`/`current_player_name`

### 4. Endless Methods
- Used throughout for single-expression methods: `def song = verses(99, 0)`, `def speed = BASE_SPEED`, etc.

### 5. Pattern Matching
- **tennis.rb**: `case [p1, p2] in` with pin operators (`^s`), guards, and ranges
- **english_number.rb**: `case [tens, ones] in` with destructuring and endless ranges
- **bottles.rb**: `case number in 0/1/else` for factory dispatch
- **character_creator.rb**: `case level in (..4)/(..8)/etc.` with beginless ranges

### 6. Functional Collection Methods
- **yatzy.rb**: `tally`, `count`, `sum`, `sort`, `select`, `detect`
- **trivia.rb**: `each_with_object`, `map` with implicit `it`
- **medicine_clash.rb**: `flat_map`, `select`, `max_by`, `min_by`, `inject(:&)`
- **bottles.rb**: `downto(...).map { verse(it) }.join`

### 7. Modern Ruby Features
- Implicit block parameter `it` where appropriate
- Beginless/endless ranges: `(..4)`, `(4..)`, `(1..)`
- `clamp` for quality bounds in gilded_rose
- Keyword argument shorthand: `new(item:)`, `new(number:)`
