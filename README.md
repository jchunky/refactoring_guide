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
prompts/
  prompt_v1.md           # Refactoring instructions for version 1
  prompt_v2.md           # Refactoring instructions for version 2
  prompt_v3.md           # Refactoring instructions for version 3
lib/
  bottles_original.rb    # Original code (never modified)
  bottles_v1.rb          # Refactored using prompt_v1
  bottles_v2.rb          # Refactored using prompt_v2
  bottles_v3.rb          # Refactored using prompt_v3
  ...
test/                    # Test files (shared across all versions)
spec/                    # RSpec files (shared across all versions)
bin/
  seed_version           # Script to create new version files
  test                   # Test runner supporting VERSION env var
```

---

## Creating New Prompt Versions

This project uses a versioning system to experiment with different AI
refactoring prompts. Each version (`v1`, `v2`, `v3`, etc.) represents an
independent refactoring experiment using a specific prompt.

### Human Step: Create the Prompt

Create a new prompt file `prompts/prompt_vN.md` with your refactoring
instructions. Each prompt can focus on different:

- Ruby version features (e.g., Ruby 3.4+ idioms)
- Design patterns (e.g., polymorphism vs. data-driven)
- Code style preferences
- Specific techniques to apply or avoid

### AI Steps: Apply the Prompt

Once the prompt file exists, send this command to the AI:

```
use the seed_version script to create vN files, and apply prompt_vN to
improve the code. you cannot look at other versions of prompts or code.
```

The AI will then:

1. **Seed the version files** - Run `bin/seed_version vN` to create fresh
   copies of all original files as `lib/*_vN.rb`

2. **Read ONLY the specified prompt** - The AI must NOT read other prompt
   versions (`prompt_v1.md`, `prompt_v2.md`, etc.) or other code versions
   (`*_v1.rb`, `*_v2.rb`, etc.) to ensure an independent experiment

3. **Refactor all version files** - Apply the prompt's guidelines to
   transform each `*_vN.rb` file

4. **Run tests** - Verify all tests pass with `VERSION=vN bin/test`

5. **Commit and push** - Commit both the prompt and refactored code together

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
