# V1 Code Simplification Plan

## Summary
Review and simplify all 12 Ruby files in `lib/v1/` for clarity, consistency, and maintainability while preserving all functionality. All 55 tests must continue to pass.

## Files and Key Opportunities

### 1. bottles.rb
- [x] Clean: minor simplification of `verses` method using `map`

### 2. english_number.rb
- [x] Remove excessive comments, use snake_case, simplify string building

### 3. gilded_rose.rb
- [x] Note: This is intentionally messy (Gilded Rose kata). Leave as-is since the point is to refactor it as an exercise.

### 4. medicine_clash.rb
- [x] Move `require 'date'` to top, remove `valid_prescriptions?` dead code path

### 5. namer.rb
- [x] Simplify string building with interpolation, remove explicit `return`

### 6. parrot.rb
- [x] Remove trailing semicolons, clean up formatting

### 7. supermarket_receipt.rb
- [x] Simplify `total_price` with `sum`, simplify `whitespace` method, simplify `add_item_quantity`

### 8. tennis.rb
- [x] TennisGame1: simplify score name lookup; TennisGame2: massive duplication - simplify with shared score name helper

### 9. theatrical_players.rb
- [x] Replace lambda with method, remove unnecessary comments

### 10. trivia.rb
- [x] Simplify `current_category` with modulo, reduce duplication in `was_correctly_answered`, simplify `ask_question`

### 11. yatzy.rb
- [x] Major duplication: extract `tally` helper, simplify ones/twos/threes/fours/fives/sixes with shared `count_value` method

### 12. character_creator.rb
- [x] Simplify `my_modcalc` with formula, reduce duplication in `statpick` and `profpicker`

## Decisions
- Gilded Rose is left as-is since it's intentionally messy code for refactoring practice
- Focus on idiomatic Ruby: snake_case, `map`/`sum`/`select`, removing explicit returns, etc.
- Address duplicated conditional logic by extracting shared methods rather than simplifying each duplicate
