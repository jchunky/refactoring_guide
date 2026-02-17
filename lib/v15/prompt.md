# Full Functional Programming

Refactor all code to embrace a fully functional programming paradigm. The goal is to eliminate mutable state entirely and express all logic as pure functions that transform data.

## Core Principles

1. **No mutable state** — Replace every `Struct.new` that gets mutated with immutable `Data.define` or frozen structures. Methods that currently mutate (`self.x = ...`) should instead return new instances with updated values.

2. **Pure functions** — Every method should be a pure function: given the same inputs, it always returns the same output with no side effects. Extract side effects (like `puts`) to the outermost boundary.

3. **Function composition** — Build complex behavior by composing small, single-purpose functions. Use lambdas/procs and method chaining where it improves clarity.

4. **Transformations over mutations** — Instead of modifying objects in place, return new transformed versions. For example, `player.win_point` should return a new Player with incremented points, not mutate the existing one.

5. **Reduce/fold for accumulation** — Where state accumulates over time (game scores, item aging), model it as a fold/reduce over a sequence of events or inputs.

6. **No class hierarchies for behavior dispatch** — Prefer pattern matching or lookup tables over inheritance. Use `case/in` with data to select behavior rather than polymorphic method dispatch through subclasses.

## Guidelines

- Keep all code within the existing module namespaces (e.g., `BottlesKata`, `TennisKata`, etc.)
- Maintain the same public API so existing tests continue to pass
- Use Ruby 3.4+ features: `Data.define`, `it` block parameter, pattern matching
- Where `puts` is used (Trivia), keep the output interface but isolate it at the boundary — pure functions compute what to output, and a thin wrapper performs the I/O
- Prefer `freeze` on data structures where practical
