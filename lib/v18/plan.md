# v18 Plan: Event Sourcing / Command Pattern

## Approach
Model state changes as immutable events. Derive state by replaying event logs.
Separate command handling from state computation. Use reduce/fold pattern.

## Per-file plan

### bottles.rb
- Stateless — no events needed. Already pure transformation.
- Keep as-is with minor polish.

### tennis.rb
- Events: `PointScored(player_name)`
- State: `{p1_name, p2_name, p1_points, p2_points}`
- Game accumulates events, derives score by reducing events into state
- `won_point` appends event, `score` replays to compute

### parrot.rb
- Stateless computation — no events. Keep as-is.

### gilded_rose.rb
- Items must mutate (test API), but internally model update as event
- Each `update` produces an `ItemUpdated(name, new_sell_in, new_quality)` event
- Apply event to item. Light-touch event sourcing.

### theatrical_players.rb
- Stateless rendering — no events. Keep as-is with minor polish.

### yatzy.rb
- Stateless scoring — no events. Keep as-is.

### trivia.rb
- Events: `PlayerAdded`, `DiceRolled`, `CorrectAnswer`, `WrongAnswer`
- State derived by reducing events
- Game appends events, replays to get current state
- Output derived from events rather than emitted during transitions

### medicine_clash.rb
- Stateless query — no events. Keep as-is.

### namer.rb / english_number.rb
- Stateless — no changes.
