# v17 Plan: Actor Model / Message Passing

## Approach
Each entity encapsulates its own state and exposes a message-based interface.
Communication happens through `receive`/`send_message` methods. No direct state access.
Coordinators orchestrate actors. Side effects collected in outbox.

## Per-file plan

### bottles.rb
- BottleNumber as an actor that receives messages (:to_s, :action, :successor)
- Bottles as coordinator that sends messages to BottleNumber actors
- Light touch — this kata is stateless so actor model is minimal

### tennis.rb
- Player as actor with `receive` handling `:win_point`, `:score`, `:name`, `:points`
- Game as coordinator that sends messages to player actors
- Internal state (points) only modified through message handling

### parrot.rb
- Parrot as actor receiving `:speed` message
- Internal dispatch based on type — handled inside the actor
- Minimal change — already well encapsulated

### gilded_rose.rb
- Item as actor receiving `:update` message
- GildedRose as coordinator sending `:update` to each item actor
- Item handles its own quality/sell_in logic internally via message

### theatrical_players.rb
- Performance as actor receiving `:price`, `:credits`, `:format` messages
- Statement as coordinator sending messages to performance actors

### yatzy.rb
- Yatzy as actor receiving scoring messages
- Each scoring method is a message the actor handles

### trivia.rb
- Player as actor receiving `:move`, `:win_point`, `:enter_penalty_box`, etc.
- QuestionBank as actor receiving `:next_question`
- Game as coordinator/supervisor orchestrating player and question actors
- Output collected in outbox, printed by coordinator

### medicine_clash.rb
- Keep Struct-based API (test requires `<<`)
- Medicine as actor-like entity with message for `:days_taken`
- Minimal change

### namer.rb
- Already well encapsulated — no changes needed

### english_number.rb
- Pure stateless function — actor model doesn't apply. No changes.
