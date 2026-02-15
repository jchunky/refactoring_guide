# Refactoring Guide Project Plan

## High-Level Goal

Create a collection of code katas with "before" and "after" versions to help develop a 
generic prompt for improving production code. The "before" versions preserve all original 
code smells, while "after" versions will demonstrate refactored, improved code.

This project will be used to analyze differences between before/after implementations to 
create an effective code improvement prompt.

---

## Project Structure

```
refactoring_guide/
├── PLAN.md                    # This document
├── Gemfile                    # Consolidated dependencies
├── Rakefile                   # Test tasks
├── bin/
│   └── test                   # Test runner script
├── before/
│   ├── lib/                   # Original source code (with code smells)
│   │   ├── bottles.rb
│   │   ├── character_creator.rb
│   │   ├── english_number.rb
│   │   ├── gilded_rose.rb
│   │   ├── medicine_clash.rb
│   │   ├── namer.rb
│   │   ├── parrot.rb
│   │   ├── tennis.rb
│   │   ├── theatrical_plays/
│   │   │   └── statement.rb
│   │   ├── trivia.rb
│   │   └── yatzy.rb
│   ├── test/                  # Minitest tests
│   │   ├── bottles_test.rb
│   │   ├── english_number_test.rb
│   │   ├── gilded_rose_test.rb
│   │   ├── statement_test.rb
│   │   ├── tennis_test.rb
│   │   ├── trivia_test.rb
│   │   ├── yatzy_test.rb
│   │   └── data/              # Test data files
│   └── spec/                  # RSpec tests
│       ├── medicine_clash_spec.rb
│       ├── namer_spec.rb
│       └── parrot_spec.rb
└── after/                     # Refactored code (future phases)
    ├── lib/
    ├── test/
    └── spec/
```

---

## Important Notes for LLM Usage

**CRITICAL: Before running any shell commands, the LLM must source ~/.zshrc:**

```bash
source ~/.zshrc && <command>
```

This ensures the correct Ruby version and bundler are available.

---

## Phase 1: Consolidation (Current Phase)

### Goals
- Consolidate all katas into single project structure
- Merge medicine_clash multiple files into single file
- Create unified Gemfile
- Ensure all tests pass in single test run
- **No code improvements** - preserve all existing code smells

### Steps
1. [x] Create PLAN.md documentation
2. [x] Consolidate medicine_clash source files into single file
3. [x] Consolidate medicine_clash spec files into single file
4. [x] Create directory structure (before/lib, before/test, before/spec)
5. [x] Create root-level consolidated Gemfile
6. [x] Copy source files to before/lib
7. [x] Copy test files to before/test and before/spec
8. [x] Update require paths in test files
9. [x] Create bin/test script
10. [x] Create Rakefile with test tasks
11. [x] Run bundle install
12. [x] Verify all tests pass

### Test Results (Phase 1 Complete)
- Minitest: 20 tests, 604 assertions, 0 failures (+ 11 tests with 7 skips from bottles)
- RSpec: 33 examples, 0 failures, 1 pending

---

## Phase 2: Create "After" Versions (Future)

- Copy before/ to after/
- Apply refactoring improvements
- Tests in after/ may be substantially modified
- Ensure both before and after tests pass independently

---

## Phase 3: Analyze and Create Prompt (Future)

- Compare before/after implementations
- Identify patterns in improvements
- Create generic prompt for code improvement

---

## Test Commands

```bash
# Run all tests
bin/test

# Run only before tests
bundle exec rake test:before

# Run only after tests (when available)
bundle exec rake test:after

# Run specific test frameworks
bundle exec rake test:before:minitest
bundle exec rake test:before:rspec
```

---

## Included Katas

| Kata | Test Framework | Description |
|------|---------------|-------------|
| 99_bottles | Minitest | Song lyrics generator |
| character_creator | N/A | Character creation (main.rb only) |
| english_number | Minitest | Number to English converter |
| exos/xyz (namer) | RSpec | Name generator |
| gilded_rose | Minitest | Inventory management |
| medicine_clash | RSpec | Medicine interaction checker |
| parrot | RSpec | Parrot types |
| tennis | Minitest | Tennis scoring |
| theatrical_players | Minitest | Play billing statement |
| trivia | Minitest | Trivia game |
| yatzy | Minitest | Yatzy dice game |

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
