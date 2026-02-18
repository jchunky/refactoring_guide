# v22 Refactoring Plan — Functional Core, Imperative Shell

## Theme

Apply the **Functional Core, Imperative Shell** pattern to separate pure logic
from I/O and side effects.

```
┌──────────────────────────────┐
│      Imperative Shell        │  ← thin: I/O, prompts, randomness
│  ┌────────────────────────┐  │
│  │    Functional Core     │  │  ← thick: all business logic, pure
│  └────────────────────────┘  │
└──────────────────────────────┘
```

Values flow **in** to the Core, decisions flow **out**.
The Shell takes those decisions and acts on them.

---

## 1. character_creator.rb

**Problem**: Business logic (hit point formulas, modifier calculations, data
lookups) deeply interleaved with I/O (puts, gets, global variable mutation).

**Core module** — pure functions and value objects:
- Constants as frozen data tables (`HIT_DICE`, `CLASS_SKILLS`, `BACKGROUND_DATA`)
- `modifier(stat)` → `(stat - 10) / 2` (replaces 15-branch if/elsif)
- `proficiency_bonus(level)` → `(level - 1) / 4 + 2` (replaces 5-branch if/elsif)
- `hit_points(char_class, level, con_mod)` → formula using `HIT_DICE` lookup
- `armor_class(dex_mod)`, `compute_stats(dice_groups)`, `build_character(...)`
- `Character` value object via `Data.define` (replaces mutable `DnDchars` class)

**Shell module** — thin I/O layer:
- `get_input`, `pick_from`, `roll_dice`, `assign_stats`, `pick_proficiencies`
- `run` — orchestrates prompts → Core → display

**Removed**: global variables, unused `Ranger` class, dead `armorcalc`,
`Proficiencies` module, massive duplication in `statpick`/`profpicker`

---

## 2. theatrical_players.rb

**Problem**: Single `statement` method mixes pricing rules, credit calculations,
and string formatting in one interleaved loop.

**Core module** — pure calculations:
- `amount_for(play_type, audience)` — pricing rules per type
- `credits_for(play_type, audience)` — volume credit rules per type
- `format_currency(cents)` — pure string formatting
- `generate_statement(invoice, plays)` — orchestrates Core functions, returns string

**Shell** — trivially thin delegate:
- `statement(invoice, plays)` → `Core.generate_statement(invoice, plays)`
- Already "functional" (no `puts`), so the shell is just a passthrough
- Demonstrates that FCIS is about *separating concerns*, not just removing `puts`

---

## 3. trivia.rb

**Problem**: Game class has `puts` in every method, mutable arrays shifted
destructively, duplicated advance-player logic, 12 explicit `return` statements
for `current_category`.

**Core module** — pure state machine:
- Game state as a hash: players, places, purses, penalty box, question counts
- `add_player(state, name)` → `[new_state, messages]`
- `roll(state, roll_value)` → `[new_state, messages]`
- `correct_answer(state)` → `[new_state, messages, still_playing]`
- `wrong_answer(state)` → `[new_state, messages, still_playing]`
- `category_for(place)` → `CATEGORIES[place % 4]` (replaces 12 return statements)
- Question indices tracked in state (replaces destructive `Array#shift`)

**Shell** — `UglyTrivia::Game` class:
- Holds `@state` (the only mutable thing in the system)
- Each method: call Core → update `@state` → `puts` each message
- Preserves exact same public API and output

**Key insight**: The Core is a pure state machine — given a state and an action,
it returns a new state and a list of things that happened. The Shell is just the
loop that feeds actions in and prints results out.
