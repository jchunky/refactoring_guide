# Refactoring Guide

A collection of refactoring kata exercises for experimenting with different
AI-assisted refactoring prompts. Each version uses a unique prompt to transform
the same original code, allowing comparison of different refactoring approaches.

---

## Quick Start

Run tests for a specific version:

```bash
VERSION=v3 bin/test
```

Run tests for the original code:

```bash
bin/test
# or
VERSION=original bin/test
```

---

## Project Structure

```
lib/
  original/              # Original code (never modified)
    prompt.md            # Empty placeholder (copied when seeding)
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
  seed_version           # Script to create new version directory
  test                   # Test runner supporting VERSION env var
```

---

## Creating New Prompt Versions

This project uses a versioning system to experiment with different AI
refactoring prompts. Each version (`v1`, `v2`, `v3`, etc.) represents an
independent refactoring experiment using a specific prompt.

### Step 1: Seed the Version (AI)

Direct the AI to create the new version directory:

```
run bin/seed_version v9
```

This creates `lib/v9/` with copies of all original files plus an empty
`prompt.md`.

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

1. **Read ONLY the specified prompt** - The AI must NOT read other prompt
   versions or other code versions to ensure an independent experiment

2. **Refactor all version files** - Apply the prompt's guidelines to
   transform each file in `lib/v9/`

3. **Run tests** - Verify all tests pass with `VERSION=v9 bin/test`

4. **Commit and push** - Commit both the prompt and refactored code together

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
