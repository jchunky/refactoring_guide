# v16 Plan: Algebraic Data Types + Exhaustive Pattern Matching

## Approach
Model all domain variants as tagged data types using `Data.define` with type tags.
Eliminate class hierarchies. Use exhaustive `case/in` pattern matching everywhere.
Data carries values; standalone functions interpret them.

## Per-file plan

### bottles.rb
- Replace `BottleNumber` hierarchy with a single `Data.define(:n)` type
- All behavior (quantity, containers, action, successor) via module functions with `case/in` on `n`
- Exhaustive matching with explicit cases

### tennis.rb
- Player as `Data.define(:name, :points)` — pure data
- Score computation via exhaustive `case/in` on `[diff, max]` tuple (already close)
- Game holds mutable state wrapper (test API requires `won_point` mutation)

### parrot.rb
- Already `Data.define` with type tag — convert `case/when` to `case/in`
- Add explicit `else` raise for exhaustiveness

### gilded_rose.rb
- Item stays as `Struct` (test requires mutation)
- Update logic via exhaustive `case/in` on item name
- Each branch fully self-contained

### theatrical_players.rb
- Replace `Comedy`/`Tragedy` class hierarchy with single `Performance` Data.define
- Price and credits computed via exhaustive `case/in` on `play_type`
- Eliminate `Object.const_get`

### yatzy.rb
- Dice as frozen array in `Data.define` — pure data
- All scoring as module functions pattern matching on dice data

### trivia.rb
- Player as `Data.define` with named fields — pure data
- Game state transitions via pattern matching on actions
- Category selection via pattern matching on location

### medicine_clash.rb
- Prescription already `Data.define` — no change
- Medicine/Patient keep Struct (test requires `<<`)
- Minor cleanup

### namer.rb
- Already `Data.define` — no changes needed

### english_number.rb
- Already uses pattern matching — polish with exhaustive `case/in`
