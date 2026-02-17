# Logic / Declarative Programming

Refactor all code to follow a declarative programming paradigm: express *what* the answer is through rules, facts, and declarations rather than *how* to compute it through imperative steps.

## Core Principles

1. **Rules as data** — Encode business logic as declarative rule sets (hashes, arrays of conditions/actions, lookup tables) rather than procedural if/else chains or class hierarchies. The rules should read like a specification.

2. **Fact-based computation** — Define facts about the domain (e.g., score names, bottle grammar, item behaviors) as data structures. Computation becomes looking up and combining facts rather than executing procedures.

3. **Declarative scoring/behavior tables** — For katas like Yatzy, Tennis, Bottles, encode the scoring rules as a table of `{ condition → result }` pairs. A generic engine evaluates the table against the input.

4. **Pattern matching as rule evaluation** — Use `case/in` extensively as a rule engine. Each branch is a declarative rule: "when the data looks like X, the answer is Y."

5. **Eliminate control flow** — Minimize explicit loops, conditionals, and imperative sequencing. Replace with `map`, `select`, `find`, `reduce` over declarative data structures.

6. **Configuration over code** — Behavior differences (between item types, parrot types, play types) should be captured in configuration data (hashes/arrays), not in separate classes or methods. A single generic function interprets the configuration.

## Guidelines

- Keep all code within the existing module namespaces
- Maintain the same public API so existing tests continue to pass
- Use Ruby 3.4+ features: `Data.define`, `it` block parameter, pattern matching
- Favor hashes, arrays, and ranges as rule definitions
- A good test: can you read the rules and understand the business logic without tracing execution flow?
- Where `puts` is used (Trivia), keep the output interface intact
- For complex katas (Trivia, Gilded Rose), define behavior as a ruleset hash mapping conditions to actions, then write a small generic interpreter that applies matching rules
