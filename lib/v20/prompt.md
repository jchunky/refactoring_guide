# Pipeline / Data Transformation

Refactor all code to follow a pipeline / data transformation paradigm: data flows through a series of transformation steps, with no objects owning behavior — just data in, transformed data out.

## Core Principles

1. **Data in, data out** — Every function takes data (hashes, arrays, simple values) and returns transformed data. No objects with behavior — just pure transformation functions.

2. **Pipeline composition** — Build complex operations by chaining simple transformations: `data |> step1 |> step2 |> step3`. In Ruby, express this as method chains (`.then`, `.map`, `.reduce`) or explicit pipeline methods.

3. **Use `.then` for pipelines** — Ruby's `.then` (aka `.yield_self`) is the pipe operator. Build readable pipelines: `input.then { step1(it) }.then { step2(it) }.then { format(it) }`.

4. **No classes for behavior** — Avoid defining classes with methods that operate on `self`. Instead, use module functions that take data as arguments and return new data. Data structures should be plain hashes, arrays, or `Data.define` value objects.

5. **Transform, don't mutate** — Each step in the pipeline produces new data. Never modify input data in place. Each transformation is a pure function.

6. **Separate data from transformations** — Define data shapes (what data looks like) separately from transformation functions (what happens to data). The pipeline connects them.

## Guidelines

- Keep all code within the existing module namespaces
- Maintain the same public API so existing tests continue to pass
- Use Ruby 3.4+ features: `Data.define`, `it` block parameter, pattern matching, `.then`
- Express each kata's logic as a pipeline of named transformation steps
- Prefer module-level methods (e.g., `module BottlesKata; def self.verse(n)`) or use module functions composed together
- Where `puts` is used (Trivia), keep the output interface but build the output string through a pipeline of transformations
- Think of each kata as: **raw input → [transform] → [transform] → [transform] → final output**
- Name each transformation step clearly to document what it does
