# V10 Refactoring Plan

Prompt: "improve the code"

All changes preserve existing public interfaces so that all tests continue to pass.

---

## 1. bottles.rb — Extract helper methods for bottle text
- Extract `bottle_count(n)` and `action(n)` helpers to eliminate the 4-branch conditional
- Use string interpolation more consistently

## 2. character_creator.rb — Major cleanup
- Replace `my_modcalc` long if/elsif chain with simple math: `(stat - 10) / 2`
- Replace `proficiency` if/elsif with formula: `(level - 1) / 4 + 2`
- Replace `for` loops with idiomatic Ruby (`each`, `map`, `select`)
- Remove global variables (`$charstats`, `$prof`) — pass as parameters
- Eliminate massive duplication in `statpick` and `profpicker` by extracting a reusable `pick_from_list` method
- Use `attr_accessor` shorthand in `DnDchars` (single line)
- Rename `DnDchars` → `Character`, `my_modcalc` → `modifier`, etc.
- Remove unused `Ranger` class and dead code in `armorcalc`
- Replace `proficiency_by_class` case/when with a Hash lookup
- Use keyword args for `DnDchars#initialize`

## 3. english_number.rb — Ruby conventions
- Rename `numString` → `result`, `onesPlace` → `ones`, `tensPlace` → `tens` (snake_case)
- Remove excessive comments
- Remove unnecessary explicit `return` statements

## 4. gilded_rose.rb — Extract strategy per item type
- Replace deeply nested if/else with extracted methods per item type (`update_normal_item`, `update_aged_brie`, `update_backstage_pass`, `update_sulfuras`)
- Use `clamp` for quality bounds (0..50)
- Each update method clearly shows the rules for that item type

## 5. medicine_clash.rb — Fix undefined methods, simplify
- Remove references to undefined methods (`valid_prescriptions?`, `read_attribute`) in `Medicine#days_supply`
- Simplify `Medicine` — remove unused/overly complex methods

## 6. namer.rb — Clean up string building
- Use array + `join` instead of `<<` string concatenation
- Extract title sanitization into its own method
- Simplify the truncation logic

## 7. parrot.rb — Replace type code with polymorphism
- Create `EuropeanParrot`, `AfricanParrot`, `NorwegianBlueParrot` subclasses
- Use factory method `Parrot.create(type, ...)` to maintain the same test interface
- Remove semicolons and clean up style

## 8. tennis.rb — Simplify all three games
- **TennisGame1**: Use snake_case for variables, simplify the score lookup
- **TennisGame2**: Eliminate redundant if/if/if blocks, use lookup hash + clear logic paths
- **TennisGame3**: Rename cryptic variables (`@p1N` → `@player1_name`, etc.)

## 9. theatrical_players.rb — Extract methods
- Extract `amount_for(performance, play)` method
- Extract `volume_credits_for(performance, play)` method
- Extract `format_currency(amount)` method
- Main `statement` method becomes a clear orchestrator

## 10. trivia.rb — Reduce duplication
- `current_category`: Use modulo arithmetic instead of 12 explicit `return` statements
- Extract `advance_player` to eliminate repeated `@current_player` advancement logic
- Extract `move_player(roll)` to eliminate duplicated location update code
- Clean up `was_correctly_answered` — duplicated reward logic

## 11. yatzy.rb — Eliminate massive duplication
- Unify `ones`, `twos`, `threes`, `fours`, `fives`, `sixes` into a single `count_specific(dice, target)` helper
- Make all methods consistent — use a shared `tally(dice)` helper
- Simplify `score_pair`, `two_pair`, `four_of_a_kind`, `three_of_a_kind` using shared tally
- Fix `Array(0..5)` → `(0..5)`, remove unnecessary variable declarations
