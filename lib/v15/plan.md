# v15 Plan: Full Functional Programming

## Approach
Eliminate mutable state where possible. Replace class hierarchies with pattern matching.
Use pure functions and data transformations. Keep thin mutable shells only where test API demands mutation.

## Per-file plan

### bottles.rb
- Replace `BottleNumber` class hierarchy (`BottleNumber0`, `BottleNumber1`) with a single `Data.define` and pattern matching in module functions
- Eliminate `Object.const_get` dynamic dispatch
- `Bottles` remains a simple class with pure methods (already functional)

### tennis.rb
- `Player` becomes immutable `Data.define` — `win_point` returns a new Player
- `TennisGame` keeps a mutable shell (test calls `won_point` then `score`) but internally replaces state with new immutable values
- `score` is a pure function of the two player states
- Replace `Struct.new` with mutable wrapper holding immutable data

### parrot.rb
- Already immutable `Data.define` — replace `case/when` with `case/in` pattern matching
- Already fully functional, minor polish only

### gilded_rose.rb
- Items must remain mutable Structs (test mutates items in place via `update_quality`)
- Extract update logic into pure function: `compute_update(name, sell_in, quality) → [new_sell_in, new_quality]`
- `Item#update` calls the pure function and applies results
- Replace `case/when` with `case/in` pattern matching

### theatrical_players.rb
- Replace `Comedy < Performance` / `Tragedy < Performance` hierarchy with pattern matching on play_type
- Eliminate `Object.const_get` dynamic dispatch
- Use module functions for price/credits calculations keyed by type
- `Statement` remains a `Data.define` (already functional)

### yatzy.rb
- Replace `method_missing` with explicit class methods or module functions
- Replace `Struct.new` with `Data.define` (no mutation occurs)
- All scoring functions are already pure — just clean up the dispatch

### trivia.rb
- Keep mutable Game shell (test requires `add`, `roll`, `was_correctly_answered`, `wrong_answer` with `puts`)
- Extract pure state-transition functions: `(state, action) → (new_state, output_lines)`
- Game shell applies transitions and prints output
- Player/QuestionBank become immutable data, replaced on each transition

### medicine_clash.rb
- Must keep `Patient.medicines << medicine` and `medicine.prescriptions << prescription` (test API)
- `Prescription` is already `Data.define` (immutable) ✓
- `clash` method logic is already functional — minor polish
- Keep Medicine/Patient as Structs for `<<` compatibility

### namer.rb
- Already fully functional with `Data.define` — no changes needed

### english_number.rb
- Already fully functional pure functions — no changes needed
