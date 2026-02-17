# Protocol-based Polymorphism

Refactor all code to use protocol-based polymorphism: define explicit interfaces (protocols) and implement them independently for each type, without inheritance or shared base classes.

## Core Principles

1. **Protocols over inheritance** — Instead of `Comedy < Performance` or `BottleNumber0 < BottleNumber`, define a protocol (a set of required methods) and implement it separately for each type. No class needs to inherit from another.

2. **Explicit interface contracts** — Document what methods a protocol requires (e.g., a `Priceable` protocol needs `#price` and `#credits`). Use Ruby modules to define the protocol, and include/extend them in implementing classes.

3. **No shared base class behavior** — Each type that implements a protocol provides its own complete implementation. There is no default behavior inherited from a parent — each implementation is self-contained.

4. **Registry for type dispatch** — Instead of `Object.const_get` or class hierarchies, maintain an explicit registry (hash) that maps type identifiers to their implementations. Lookup is explicit and configurable.

5. **Composition over inheritance** — Where types share common behavior, extract it into composable modules (mixins) that each type explicitly includes, rather than inheriting from a common ancestor.

6. **Duck typing formalized** — Ruby's duck typing is informal protocol-based polymorphism. Make it formal: define what methods are expected, and ensure each type provides them. Consider raising clear errors when a protocol is not satisfied.

## Guidelines

- Keep all code within the existing module namespaces
- Maintain the same public API so existing tests continue to pass
- Use Ruby 3.4+ features: `Data.define`, `it` block parameter, pattern matching
- Define protocols as Ruby modules with method stubs that raise `NotImplementedError`
- Each implementing class includes the protocol module and overrides all required methods
- Use a registry hash (e.g., `TYPES = { comedy: Comedy, tragedy: Tragedy }`) for dispatch instead of dynamic class lookup
- Where `puts` is used (Trivia), keep the output interface intact
- The key insight: every type stands alone and satisfies a contract, rather than inheriting behavior from a parent
