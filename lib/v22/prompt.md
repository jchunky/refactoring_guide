# Functional Core, Imperative Shell

Refactor `character_creator.rb` using the **Functional Core, Imperative Shell** pattern.

> Before running any shell commands, first run `source ~/.zshrc` to load the proper Ruby environment.

## The Pattern

Separate the code into two distinct layers:

- **Functional Core**: Pure functions and value objects. No I/O, no mutation, no side effects. Given the same inputs, always returns the same outputs. Trivially testable without mocks or stubs.
- **Imperative Shell**: Thin orchestration layer. Handles all I/O (user prompts, dice rolling, display). Delegates every decision and computation to the Core. Contains no business logic.

## Rules

1. The Core must have **zero** `puts`, `gets`, `print`, `rand`, or global variable access
2. The Shell must have **zero** business logic — no formulas, no data lookups, no calculations
3. Values flow **in** to the Core; decisions flow **out**
4. The Shell takes those decisions and acts on them (display, persist, etc.)

## Also Apply

- Replace long if/elsif chains with formulas or hash lookups
- Use `Data.define` for value objects
- Use endless methods for single-expression functions
- Remove dead code, global variables, and unused classes
- Idiomatic Ruby: `each`, `map`, snake_case, keyword arguments
