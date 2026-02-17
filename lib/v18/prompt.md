# Event Sourcing / Command Pattern

Refactor all code to follow an Event Sourcing paradigm: model every state change as an immutable event, and derive current state by replaying the event log. Separate commands (intentions) from events (facts).

## Core Principles

1. **Events are facts** — Every state change is recorded as an immutable event object (e.g., `PointScored`, `ItemAged`, `DiceRolled`, `QuestionAnswered`). Events describe what happened, not what to do.

2. **State is derived, not stored** — Current state is computed by folding/reducing over the event log. There is no mutable state that gets updated in place — state is always a function of the event history.

3. **Commands produce events** — A command (user action / game action) is validated and then produces one or more events. Commands can fail; events cannot (they already happened).

4. **Event handlers / reducers** — Write pure reducer functions that take `(current_state, event) → new_state`. These are the heart of the system. Use `reduce`/`inject` to replay events into state.

5. **Separation of concerns** — Keep event generation, state computation, and presentation (formatting/output) as separate layers. The event log is the single source of truth.

6. **Immutable events** — Use `Data.define` for event types. Events should be frozen, immutable value objects with all relevant data captured at creation time.

## Guidelines

- Keep all code within the existing module namespaces
- Maintain the same public API so existing tests continue to pass
- Use Ruby 3.4+ features: `Data.define`, `it` block parameter, pattern matching
- Define event types as `Data.define` classes within each module
- The reducer/fold pattern should be clearly visible — `events.reduce(initial_state) { |state, event| apply(state, event) }`
- For Trivia and other stateful katas, the public methods become command handlers that append events and recompute state
- Where `puts` is used (Trivia), derive output from events rather than emitting during state transitions
- Not every kata needs heavy event sourcing — for simple/stateless katas (like EnglishNumber), a light touch is fine: just ensure the transformation is expressed as data flow rather than mutation
