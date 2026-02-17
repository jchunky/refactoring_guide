# Actor Model / Message Passing

Refactor all code to follow the Actor Model paradigm: each entity owns its own state, communicates with other entities exclusively through message passing, and never shares mutable state directly.

## Core Principles

1. **Each entity is an actor** — An actor encapsulates its own state and behavior. No external code directly reads or writes an actor's internal state. Instead, actors expose a message-based interface.

2. **Message passing over direct mutation** — Instead of calling `player.points += 1`, send a message: `player.receive(:win_point)`. Actors process messages and update their own internal state. Use a `receive` or `handle` method as the single entry point for messages.

3. **No shared mutable state** — Actors never share references to mutable objects. When data needs to flow between actors, pass immutable copies or simple values (numbers, strings, symbols).

4. **Tell, don't ask** — Prefer telling an actor to do something (`:update_quality`, `:roll_dice`) over asking for its state and computing externally. Actors should make their own decisions based on messages received.

5. **Supervisor/coordinator pattern** — Use a coordinator actor (e.g., Game, GildedRose) to orchestrate interactions between child actors. The coordinator sends messages and receives responses, but does not reach into children's state.

6. **Outbox pattern for side effects** — For actors that produce output (like Trivia's `puts`), collect output messages in an outbox/log that the coordinator drains, rather than performing I/O directly inside the actor.

## Guidelines

- Keep all code within the existing module namespaces
- Maintain the same public API so existing tests continue to pass
- Use Ruby 3.4+ features: `Data.define`, `it` block parameter, pattern matching
- Implement message handling with `case/in` or `case/when` on message symbols/tuples
- Where `puts` is used (Trivia), keep the output interface but route output through message passing internally
- The message-passing should be in-process (method calls that simulate message sends) — no need for threads, queues, or Ractors
- Think of each class as an independent actor with an inbox of messages it can handle
