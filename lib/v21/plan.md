# v21 Plan: Protocol-based Polymorphism

## Approach
Define explicit protocol modules with required method stubs.
Each type implements the protocol independently — no inheritance.
Use registry hashes for type dispatch instead of dynamic class lookup.

## Per-file plan

### bottles.rb
- Define `BottleNumberProtocol` with required methods: `to_s`, `action`, `successor`
- Implement `RegularBottleNumber`, `ZeroBottleNumber`, `OneBottleNumber` — each standalone
- Registry: `BOTTLE_NUMBER_TYPES = { 0 => ZeroBottleNumber, 1 => OneBottleNumber }`

### tennis.rb
- Players are simple Structs (no protocol needed — uniform type)
- Game classes still need TennisGame1/2/3 aliases (test API)
- Focus protocol on score computation abstraction

### parrot.rb
- Define `ParrotSpeedProtocol` module
- `EuropeanParrot`, `AfricanParrot`, `NorwegianBlueParrot` each include protocol
- Registry: `PARROT_TYPES = { european_parrot: EuropeanParrot, ... }`
- `Parrot.new` dispatches via registry

### gilded_rose.rb
- Define `ItemUpdater` protocol
- `AgedBrieUpdater`, `BackstagePassUpdater`, `SulfurasUpdater`, `NormalUpdater`
- Registry maps item names to updater classes

### theatrical_players.rb
- Define `PerformanceProtocol` with `#price`, `#credits`
- `ComedyPerformance`, `TragedyPerformance` each include protocol
- Registry: `PERFORMANCE_TYPES = { "comedy" => ComedyPerformance, ... }`

### yatzy.rb
- Single Yatzy class — no polymorphism needed. Keep as-is.

### trivia.rb
- Keep current structure — no type hierarchy to replace
- Minor polish only

### medicine_clash.rb / namer.rb / english_number.rb
- No type dispatch — keep as-is
