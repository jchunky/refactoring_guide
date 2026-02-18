# Refactoring Guide

A collection of refactoring kata exercises for experimenting with different
AI-assisted refactoring prompts. Each version uses a unique prompt to transform
the same original code, allowing comparison of different refactoring approaches.

---

## Quick Start

Run tests for a specific version:

```bash
bin/test v0              # test original (v0) code
bin/test v3              # test v3 version
```

Run rubocop on all Ruby files for a specific version:

```bash
bin/lint v0              # lint only
bin/lint -a v3           # safe autocorrect
bin/lint -A v3           # all autocorrect (including unsafe)
```

> **AI agents:** Before executing _any_ shell command (not just tests),
> first run `source ~/.zshrc` to load the proper Ruby environment.
> Alternatively, prefix commands: `source ~/.zshrc && bundle exec rake test`

---

## Project Structure

```
lib/
  v0/                    # Original code (never modified)
    bottles.rb
    gilded_rose.rb
    ...
  v1/                    # Version 1 refactored code
    prompt.md            # Refactoring instructions for this version
    bottles.rb
    gilded_rose.rb
    ...
  v2/                    # Version 2 refactored code
    prompt.md
    bottles.rb
    ...
test/                    # Minitest files (shared across all versions)
bin/
  lint                   # Rubocop runner — requires version argument
  seed_version           # Seed a new version — requires source and target
  test                   # Test runner — requires version argument
```

---

## Creating New Prompt Versions

This project uses a versioning system to experiment with different AI
refactoring prompts. Each version (`v1`, `v2`, `v3`, etc.) represents an
independent refactoring experiment using a specific prompt.

### Step 1: Seed the Version (AI)

Direct the AI to create the new version directory:

```
bin/seed_version v0 v9         # v0 → v9 (from original code)
bin/seed_version v8 v9         # v8 → v9 (from another version)
```

Both arguments are required: the first is the source version and the second
is the target. This creates `lib/v9/` with copies of all source `.rb` files
plus empty `prompt.md` and `plan.md` files.

### Step 2: Write the Prompt (Human)

Edit `lib/v9/prompt.md` with your refactoring instructions. Each prompt can
focus on different:

- Ruby version features (e.g., Ruby 3.4+ idioms)
- Design patterns (e.g., polymorphism vs. data-driven)
- Code style preferences
- Specific techniques to apply or avoid

### Step 3: Apply the Prompt (AI)

Once the prompt file is ready, send this command to the AI:

```
apply the prompt in lib/v9/prompt.md to improve the code in lib/v9/.
you cannot look at other versions of prompts or code.
```

The AI will then:

1. **Source shell configuration** - Run `source ~/.zshrc` before executing
   any commands to ensure the correct Ruby version and tools are available

2. **Read ONLY the specified prompt** - The AI must NOT read other prompt
   versions or other code versions to ensure an independent experiment

3. **Document the refactoring plan** - Before making any code changes,
   write a detailed plan to a markdown file (e.g., `lib/v9/plan.md`)
   describing the intended refactoring approach for each file

4. **Refactor all version files** - Apply the prompt's guidelines to
   transform each file in `lib/v9/`

5. **Run tests** - Verify all tests pass with `bin/test v9`

6. **Commit and push** - Commit the prompt, plan, and refactored code together

---

## Module Namespacing

Each kata is wrapped in its own module to prevent collisions:

| Kata | Module |
|------|--------|
| bottles.rb | `BottlesKata` |
| character_creator.rb | `CharacterCreatorKata` |
| english_number.rb | `EnglishNumberKata` |
| gilded_rose.rb | `GildedRoseKata` |
| medicine_clash.rb | `MedicineClashKata` |
| namer.rb | `NamerKata` |
| parrot.rb | `ParrotKata` |
| tennis.rb | `TennisKata` |
| theatrical_players.rb | `TheatricalPlayersKata` |
| trivia.rb | `TriviaKata` |
| yatzy.rb | `YatzyKata` |

Tests use `include XxxKata` to bring classes into scope. This allows each kata
to define classes with the same names (e.g., `Player`) without conflicts.

**Note:** Core class extensions (e.g., `Integer#days` in medicine_clash.rb)
remain global as they're required by test files

---

## Why Isolate Versions?

Keeping each version isolated ensures:

- **Independent experiments**: Each prompt is applied to the same starting
  code, making comparisons meaningful
- **No cross-contamination**: The AI doesn't copy patterns from other
  versions, which would bias the experiment
- **Reproducibility**: Anyone can re-run the experiment by applying the
  same prompt to fresh seeded files
- **Honest comparison**: Differences between versions reflect the prompt's
  guidance, not accumulated improvements
