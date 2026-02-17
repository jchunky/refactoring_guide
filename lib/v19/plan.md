# v19 Plan: Logic / Declarative Programming

## Approach
Express business logic as declarative rules, facts, and lookup tables.
Minimize imperative control flow. Rules should read like specifications.
A generic engine evaluates rules against data.

## Per-file plan

### bottles.rb
- Declare bottle number facts as a rules table: `{n => {quantity:, containers:, action:, successor:}}`
- Default rule for generic numbers, special rules for 0 and 1
- Verse generation looks up rules

### tennis.rb
- Score rules as declarative table: `[condition, result]` pairs
- Player state is simple data, score derived by finding first matching rule

### parrot.rb
- Speed rules as hash: `{type => lambda(coconuts, voltage)}`
- Single lookup + call, no case statements

### gilded_rose.rb
- Item update rules as hash: `{name_pattern => update_lambda}`
- Generic engine applies matching rule to each item

### theatrical_players.rb
- Pricing/credits rules as hash: `{type => {price_fn:, credits_fn:}}`
- Generic statement renderer applies rules from table

### yatzy.rb
- Scoring categories as declarative rules table
- Each rule: `{name:, scorer: lambda}`

### trivia.rb
- Categories as declarative lookup
- Game rules as declarative state machine transitions
- Keep mutable game shell for test API

### medicine_clash.rb
- Already declarative in nature — minor polish

### namer.rb / english_number.rb
- english_number: NUMBERS hash is already declarative, enhance with ranges
- namer: already clean — no changes
