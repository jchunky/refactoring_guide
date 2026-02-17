# v20 Plan: Pipeline / Data Transformation

## Approach
Express all logic as data flowing through transformation pipelines.
Use `.then` as pipe operator. Module functions take data in, return data out.
No objects with behavior — just data + transformations.

## Per-file plan

### bottles.rb
- Verse as pipeline: number → bottle_data → format_verse
- Module functions, no classes except thin Bottles wrapper for API

### tennis.rb
- Score as pipeline: (p1_points, p2_points) → classify → format
- Game keeps mutable shell, score computed via pipeline

### parrot.rb
- Speed as pipeline: parrot_data → check_nailed → compute_base → clamp

### gilded_rose.rb
- Update as pipeline: (name, sell_in, quality) → compute_new_values → apply
- Item keeps Struct for mutation (test API)

### theatrical_players.rb
- Statement as pipeline: (invoice, plays) → build_performances → compute_totals → format

### yatzy.rb
- Each scoring method as pipeline over dice array

### trivia.rb
- Keep mutable game shell
- Internal operations as pipelines where possible

### medicine_clash.rb
- Clash as pipeline: medicines → filter → map_days → intersect → filter_range

### namer.rb / english_number.rb
- Already pipeline-friendly — enhance with `.then`
