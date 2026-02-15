# Refactoring Guide Project Plan

## High-Level Goal

Create a collection of code katas with multiple implementation versions to help develop a 
generic prompt for improving production code. The "original" versions preserve all code 
smells, while refactored versions (v1, v2, etc.) demonstrate different improvement approaches.

This project allows comparing multiple refactoring approaches by sharing a single test suite
across all versions.

---

## Project Structure

```
refactoring_guide/
├── PLAN.md                        # This document
├── Gemfile                        # Consolidated dependencies
├── Rakefile                       # Test tasks with VERSION support
├── bin/
│   └── test                       # Test runner script
├── lib/                           # All implementation files (flat, suffix-based)
│   ├── version_loader.rb          # Helper to load versioned implementations
│   ├── bottles_original.rb
│   ├── bottles_v1.rb              # (future refactored version)
│   ├── character_creator_original.rb
│   ├── english_number_original.rb
│   ├── gilded_rose_original.rb
│   ├── medicine_clash_original.rb
│   ├── namer_original.rb
│   ├── parrot_original.rb
│   ├── tennis_original.rb
│   ├── theatrical_players_original.rb
│   ├── trivia_original.rb
│   └── yatzy_original.rb
├── test/                          # Shared Minitest tests
│   ├── bottles_test.rb
│   ├── english_number_test.rb
│   ├── gilded_rose_test.rb
│   ├── tennis_test.rb
│   ├── theatrical_players_test.rb
│   ├── trivia_test.rb
│   ├── yatzy_test.rb
│   └── data/                      # Test data files
└── spec/                          # Shared RSpec tests
    ├── medicine_clash_spec.rb
    ├── namer_spec.rb
    └── parrot_spec.rb
```

---

## Versioning System

### Naming Convention
- `{kata}_original.rb` - Original unrefactored code with all code smells
- `{kata}_v1.rb` - First refactoring attempt
- `{kata}_v2.rb` - Second refactoring attempt (different prompt/approach)
- etc.

### Running Tests

```bash
# Test original (unrefactored) code (default)
VERSION=original rake test
bin/test original
bin/test                           # defaults to 'original'

# Test a specific refactored version
VERSION=v1 rake test
bin/test v1

# List available versions
rake versions
```

### How It Works

The `lib/version_loader.rb` module provides:
- `VersionLoader.require_kata('bottles')` - loads `bottles_{VERSION}.rb`
- Reads `VERSION` environment variable (defaults to 'original')

Tests use the version loader to dynamically require the appropriate implementation:
```ruby
require_relative '../lib/version_loader'
VersionLoader.require_kata('bottles')  # Loads bottles_original.rb or bottles_v1.rb, etc.
```

---

## Important Notes for LLM Usage

**CRITICAL: Before running any shell commands, the LLM must source ~/.zshrc:**

```bash
source ~/.zshrc && <command>
```

This ensures the correct Ruby version and bundler are available.

---

## Current Status

### Phase 1: Initial Setup ✅ Complete
- Created project structure with flat lib/ directory
- All original (unrefactored) implementations in lib/*_original.rb
- Shared test suite in test/ and spec/
- Version loader system implemented
- All tests pass for 'original' version

### Test Results (Original Version)
- Minitest: 20 tests, 604 assertions, 0 failures
- RSpec: 33 examples, 0 failures, 1 pending

---

## Future Phases

### Phase 2: Create Refactored Versions
- Create `{kata}_v1.rb` files with improved code
- Apply different prompts/approaches to create v1, v2, etc.
- Each version must pass all existing tests

### Phase 3: Analyze and Compare
- Compare implementations across versions
- Identify patterns in improvements
- Create effective refactoring prompt

---

## Included Katas

| Kata | Test Framework | Description |
|------|---------------|-------------|
| bottles | Minitest | Song lyrics generator |
| character_creator | N/A | Character creation (no tests) |
| english_number | Minitest | Number to English converter |
| gilded_rose | Minitest/Test::Unit | Inventory management |
| medicine_clash | RSpec | Medicine interaction checker |
| namer | RSpec | Name generator |
| parrot | RSpec | Parrot types |
| tennis | Minitest/Test::Unit | Tennis scoring |
| theatrical_players | Minitest | Play billing statement |
| trivia | Minitest/Test::Unit | Trivia game |
| yatzy | Minitest/Test::Unit | Yatzy dice game |

---

## Dependencies (Consolidated Gemfile)

- rake
- activesupport
- minitest-reporters
- nokogiri
- openssl
- ostruct
- rspec
- rubocop
- rubocop-performance
- test-unit
- zeitwerk
