# Algebraic Data Types + Exhaustive Pattern Matching

Refactor all code to model domain concepts as algebraic data types (sum types / tagged unions) and use exhaustive pattern matching to handle every variant. Eliminate class hierarchies in favor of data + matching.

## Core Principles

1. **Sum types over inheritance** — Replace class hierarchies (e.g., `BottleNumber0 < BottleNumber`, `Comedy < Performance`) with a single data type that carries a type tag. Use `Data.define` with a `:type` or `:kind` field to distinguish variants.

2. **Exhaustive pattern matching** — Use `case/in` to match on every variant of a sum type. Every match block should explicitly handle all possible cases — add an `else` clause that raises to ensure exhaustiveness at runtime.

3. **Eliminate `Object.const_get` and dynamic dispatch** — Replace runtime class lookup with explicit pattern matching on data. The type tag in the data determines behavior, not the class name.

4. **Data carries values, functions interpret them** — Types should be pure data containers (`Data.define`). All behavior lives in standalone methods or module functions that pattern-match on the data.

5. **Product types for compound data** — Use `Data.define` for records/structs that hold multiple fields. Combine sum types (tagged variants) with product types (multi-field records) to model complex domains.

6. **Deconstructing in patterns** — Leverage Ruby's `deconstruct_keys` and `deconstruct` to destructure data directly in pattern matching, pulling out the fields you need.

## Guidelines

- Keep all code within the existing module namespaces
- Maintain the same public API so existing tests continue to pass
- Use Ruby 3.4+ features: `Data.define`, `case/in`, `in` patterns with guards, `it` block parameter
- Where `puts` is used (Trivia), keep the output interface intact
- Prefer flat module functions that take data as arguments over methods defined on data classes
- Think of the code as: define your types, then write functions that pattern-match over them
