## Refactoring Plan for v23

Goal: Improve clarity, reduce duplication, and make logic more idiomatic Ruby
while preserving behavior for all katas in `lib/v23/*.rb`.

### General approach
- Keep existing public APIs and module names intact.
- Use small helper methods/lookup tables for repetitive logic.
- Favor early returns and clear conditional structure.
- Normalize naming and remove unnecessary mutation.

### File-by-file plan

#### bottles.rb
- Replace repeated string building with helper methods (e.g., `bottle_phrase`,
  `action_phrase`), reducing branching in `verse`.
- Use a single template with conditional substitutions for 0/1/2 cases.

#### character_creator.rb
- Extract constants for class/background lists and skill lists.
- Replace long `if/elsif` ladders with lookup tables (`class => hit_die`).
- Simplify `my_modcalc` with an array/lookup or formula and guard rails.
- Reduce repeated selection loops by extracting a reusable prompt helper.
- Keep global usage (`$charstats`, core extensions) intact for tests.

#### english_number.rb
- Extract lookup tables to constants.
- Simplify variable naming and reduce comments/returns while keeping recursion.

#### gilded_rose.rb
- Break `update_quality` into smaller private methods (e.g.,
  `update_item_quality`, `update_sell_in`, `handle_expired`).
- Use predicates for item types to reduce nested conditionals.

#### medicine_clash.rb
- Normalize whitespace and naming.
- Simplify set/array operations and reduce redundant sorting.
- Extract repeated range calculations into small helpers.

#### namer.rb
- Clarify filename construction with small helper methods.
- Avoid repeated string mutation where possible.

#### parrot.rb
- Normalize Ruby style (remove semicolons, use snake_case).
- Replace `throw` with `raise` and keep a default branch for safety.

#### tennis.rb
- Introduce constants for score labels.
- Refactor each game class to reduce branching and duplication while keeping
  output identical.

#### theatrical_players.rb
- Extract format helper and amount calculation per play type.
- Simplify volume credit calculations.

#### trivia.rb
- Extract category mapping and move repeated roll logic into helpers.
- Clarify penalty box logic with guard methods.

#### yatzy.rb
- Introduce tally helper and reuse across scoring methods.
- Replace repeated loops with enumerable operations.

### Validation
- Run `source ~/.zshrc && bin/test v23` after refactor.
