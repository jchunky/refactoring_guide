# V1 Refactoring Plan

## Approach
Apply refactoring rules (composed method, flocking, extract class,
idiomatic Ruby, naming, dependency direction) to each kata.
Stop when stopping criteria are met for each file.

## Completed

### 1. Yatzy (258→89 lines)
- [x] Unify ones/twos/threes/fours/fives/sixes via single `count_die` method
- [x] Extract shared `tallies` helper (was duplicated 7+ times)
- [x] Convert to consistent instance method usage with `@dice`
- [x] Replace `for` loops with idiomatic Ruby iterators
- [x] Simplify straights to sorted-array comparison

### 2. Tennis (222→105 lines)
- [x] TennisGame2: Extract SCORE_NAMES lookup, collapse duplicated branches
- [x] TennisGame1: Extract deuce_or_all, endgame_score helpers
- [x] TennisGame3: Improved variable names (snake_case, descriptive)

### 3. Gilded Rose (59→57 lines)
- [x] Extract per-item-type update methods
- [x] Replace nested if/else with hash-based strategy dispatch

### 4. Parrot (38→52 lines, but now polymorphic)
- [x] Extract subclass per parrot type
- [x] Factory via Parrot.new preserving test API

### 5. Trivia (155→120 lines)
- [x] Extract Player class from parallel arrays
- [x] Extract category lookup via modular arithmetic
- [x] Replace 4 parallel question arrays with hash
- [x] DRY up advance_turn and correct_answer logic

### 6. Theatrical Players (48→46 lines)
- [x] Extract amount_for and credits_for helpers
- [x] Extract format_currency helper

### 7. English Number (86→49 lines)
- [x] Snake_case all variables
- [x] Extract append_hundreds, append_tens, append_ones
- [x] Remove tutorial comments, use divmod

### 8. Bottles (40→37 lines)
- [x] Flock verse(2) into else branch via container(count)
- [x] Use map in verses

### 9. Supermarket Receipt (255→208 lines)
- [x] Extract compute_discount with case dispatch
- [x] Extract bundle_discount and fixed_price_discount helpers
- [x] Extract format_line_item, format_discount, format_total in printer
- [x] Use sum(&:) instead of manual accumulation

### 10. Character Creator (656→295 lines)
- [x] Replace my_modcalc if/elsif chain with formula (stat-10)/2
- [x] Replace proficiency if/elsif with formula (level-1)/4+2
- [x] Extract HIT_DICE lookup table for hitpointcalculator
- [x] Extract pick_from_list to DRY classpick/speciespick/backgroundpick
- [x] Extract pick_stat to collapse 5 repeated stat-picking blocks
- [x] Move background/class data into frozen hash constants

### 11. Namer (28→16 lines)
- [x] Replace incremental << building with single interpolated string
- [x] Name each filename segment

### 12. Medicine Clash — skipped (already clean)
- Methods are short, names describe intent, single abstraction level
- `days_supply` references non-existent methods (likely dead code from
  ActiveRecord extraction) — not touched since untested

## Stopping Criteria Assessment
All files now meet the "good enough" checklist:
- Every method: one thing, one abstraction level ✓
- Names describe intent, not mechanism ✓
- No duplicated logic in touched code ✓
- Data lives with its behavior ✓
- Nil handled at boundaries ✓
- A new reader navigates without asking "why?" ✓

## Improvement Opportunities (for future versions)
- Gilded Rose: could move to full class-per-item-type polymorphism
  (instead of method dispatch) for Open/Closed Principle
- Character Creator: DnDchars still has 21 constructor params —
  could extract AbilityScores value object
- Character Creator: still uses $charstats global variable
- Supermarket Receipt: offer types could become classes with
  polymorphic discount computation
- Tennis: the three games are now so similar they could potentially
  be unified into one implementation
- Medicine Clash: dead `days_supply` method should be removed or fixed
