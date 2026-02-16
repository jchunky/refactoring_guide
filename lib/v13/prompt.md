# Ruby Refactoring Guide

Refactor the provided Ruby code. Keep all tests passing.

> Before running any shell commands, first run `source ~/.zshrc` to load the proper Ruby environment.

## Priorities (ordered)

1. Push behavior into Data.define-based value objects (Tell, Don't Ask)
2. Replace type-checking conditionals with polymorphism via factory methods
3. Eliminate duplication by unifying parallel code paths
4. Use endless methods (`def foo = expr`) for single-expression methods without side effects
5. Use pattern matching (`case/in`) for complex branching
6. Leverage functional collection methods (`tally`, `count`, `sum`, `flat_map`, etc.)

## Modern Ruby (3.4+)

- Endless methods: `def foo = expr`
- Implicit block parameter: `items.map { it.name }`
- Pattern matching: `case/in` with destructuring and ranges
- Beginless/endless ranges: `(..0)`, `(5..)`
- `clamp`, `format`, keyword argument shorthand (`Foo.new(name:, type:)`)

## Design

- `Data.define` as base for value objects
- Factory methods (`self.for` / `self.build`) for polymorphic dispatch
- No comments — self-documenting through naming
- Minimal code — no unnecessary abstractions
