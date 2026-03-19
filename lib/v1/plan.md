# V1 Refactoring Plan

## Approach
Apply refactoring rules (composed method, flocking, extract class,
idiomatic Ruby, naming, dependency direction) to each kata.
Stop when stopping criteria are met for each file.

## Priority Order (by severity of smells)

### 1. Yatzy - MASSIVE repetition
- [ ] Unify ones/twos/threes/fours/fives/sixes via single `count_die` method
- [ ] Extract shared `tallies` helper (duplicated 7+ times)
- [ ] Convert all methods to instance methods with consistent `@dice` usage
- [ ] Replace `for` loops with idiomatic Ruby iterators
- [ ] Fix constructor (remove _d5 naming, use splat)

### 2. Tennis - TennisGame2 extreme duplication
- [ ] TennisGame2: Extract score_name lookup, collapse duplicated branches
- [ ] TennisGame1: Clean up score method (extract helpers)
- [ ] TennisGame3: Improve variable names

### 3. Gilded Rose - deeply nested conditionals
- [ ] Extract item update strategies per item type
- [ ] Replace nested if/else with polymorphic dispatch

### 4. Parrot - case dispatch → polymorphism
- [ ] Extract subclass per parrot type
- [ ] Factory method for construction

### 5. Trivia - parallel arrays, duplication
- [ ] Extract Player class from parallel arrays
- [ ] Extract category lookup via modular arithmetic
- [ ] Extract question_deck hash to replace 4 parallel arrays
- [ ] DRY up advance_player and correct_answer logic

### 6. Theatrical Players - mixed abstraction levels
- [ ] Extract amount_for and credits_for helpers
- [ ] Extract format_currency helper

### 7. English Number - verbose, camelCase, comments
- [ ] Snake_case all variables
- [ ] Extract hundreds/tens/ones phases into methods
- [ ] Remove tutorial comments

### 8. Bottles - flocking opportunity
- [ ] Flock verse(2) and verse(else) — differ only in "one"/"it"
- [ ] Use `map` in `verses`

### 9. Supermarket Receipt - handle_offers complexity
- [ ] Extract per-offer-type discount calculators

### 10. Character Creator - massive repetition, globals
- [ ] Extract `assign_stat` to DRY statpick
- [ ] Replace `$charstats` global with return value
- [ ] Replace `my_modcalc` if/elsif chain with formula
- [ ] Replace `proficiency` if/elsif with formula

### 11. Namer - minor
- [ ] Clean up string building

### 12. Medicine Clash - already clean
- [ ] Skip unless issues found

## Improvement Opportunities (discovered during work)
(to be filled in as refactoring proceeds)
