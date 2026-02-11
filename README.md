# Refactoring Guide

A comprehensive reference for identifying code smells and applying
refactorings to transform code into cleaner, more maintainable designs.

---

## Table of Contents

1. [Code Smells](#code-smells)
2. [Refactorings](#refactorings)
3. [Design Patterns](#design-patterns)
4. [Transformation Sequence](#transformation-sequence)

---

## Code Smells

*Code smells are indicators of potential problems in the code that suggest
refactoring opportunities.*

### 1. Parallel Array Syndrome

**Description:** Multiple arrays storing related lookup data that must be
kept in sync. The relationship between arrays is implicit and relies on
matching indices.

**Indicators:**
- Multiple arrays defined together with the same length
- Accessing multiple arrays with the same index
- Comments explaining which array corresponds to what

**Example:**
```ruby
ones_place = ['one',   'two',   'three', ...]
tens_place = ['ten',   'twenty', 'thirty', ...]
teenagers = ['eleven', 'twelve', 'thirteen', ...]
```

---

### 2. Mutable Accumulator

**Description:** Building a result through repeated mutation, typically
string concatenation or array pushing in a loop.

**Indicators:**
- Variable initialized to empty string/array
- Repeated `variable = variable + something` patterns
- Conditional additions scattered throughout the code

**Example:**
```ruby
num_string = ''
num_string = num_string + hundreds + ' hundred'
num_string = num_string + ' '
num_string = num_string + tens_place[write-1]
num_string = num_string + '-'
```

---

### 3. Index Arithmetic Smell

**Description:** Using arithmetic on array indices (typically `n-1`) due
to mismatch between natural numbering and zero-indexed arrays.

**Indicators:**
- `array[n-1]` access patterns
- Comments explaining the offset
- Off-by-one potential throughout the code

**Example:**
```ruby
num_string = num_string + teenagers[left-1]
# The "-1" is because teenagers[3] is 'fourteen', not 'thirteen'.
```

---

### 4. Comment-Heavy Logic

**Description:** Extensive comments explaining what code does, suggesting
the code itself isn't self-explanatory. Comments become a crutch for
unclear code.

**Indicators:**
- Multi-line comments before simple operations
- Comments restating what code does rather than why
- "Clever" code requiring explanation

---

### 5. Nested Conditional Complexity

**Description:** Deep if/else nesting for handling special cases, making
control flow hard to follow.

**Indicators:**
- Multiple levels of indentation
- Special cases handled inside other special cases
- Early returns mixed with nested logic

**Example:**
```ruby
if write > 0
  if ((write == 1) and (left > 0))
    # special teen handling
    left = 0
  else
    # regular tens handling
  end
  if left > 0
    # separator handling
  end
end
```

---

### 6. Dead Variable Assignments

**Description:** Variable assignments that serve no purpose - the value is
never read after being set.

**Indicators:**
- Assignment followed by end of scope
- Assignment pattern maintained for "symmetry" but not used
- Variables assigned then immediately overwritten

**Example:**
```ruby
write = left  # How many ones left to write out?
left  = 0     # Subtract off those ones. <-- never used after this
```

---

### 7. Mixed Concerns in Single Function

**Description:** One function handling multiple unrelated responsibilities
like error handling, special cases, and core logic all together.

**Indicators:**
- Early returns for error cases
- Special case handling at the top
- Core algorithm buried in the middle
- Multiple levels of abstraction in one function

---

### 8. Shovel Operator Chain

**Description:** Sequential `<<` operations building a mutable string,
making it hard to see the overall structure of the result.

**Indicators:**
- Multiple `string << value` lines in sequence
- Conditional `<<` operations scattered throughout
- Hard to visualize the final format

**Example:**
```ruby
filename = "#{target.publish_on.strftime("%d")}"
filename << "#{target.xyz_category_prefix}"
filename << "#{target.kind.gsub("_", "")}"
filename << "_%03d" % (target.age || 0) if target.personal?
filename << "_#{target.id.to_s}"
```

---

### 9. Module Method Doing Instance Work

**Description:** A `self.method` on a module that would be cleaner as an
instance method on a class, especially when the method operates primarily
on a single "subject" object passed as a parameter.

**Indicators:**
- `def self.method(obj)` pattern in a module
- The method repeatedly accesses `obj.something`
- No real module-level state or behavior

**Example:**
```ruby
module XYZ
  module Namer
    def self.xyz_filename(target)
      # repeatedly uses target.publish_on, target.kind, target.id, etc.
    end
  end
end
```

---

### 10. Manual Truncation Logic

**Description:** Complex inline conditionals for string length limiting
instead of using simple slice syntax.

**Indicators:**
- `length > n ? n : length` patterns
- Calculating truncation bounds manually
- Using `str[0..(variable)]` with pre-computed variable

**Example:**
```ruby
truncate_to = truncated_title.length > 9 ? 9 : truncated_title.length
filename << "_#{truncated_title[0..(truncate_to)]}"
```

---

### 11. Format Comment as Specification

**Description:** A large comment explaining the output format, which
indicates the code structure itself is not self-documenting.

**Indicators:**
- Multi-line comment describing expected output format
- Code below doesn't obviously map to the format description
- You need the comment to understand what the code produces

**Example:**
```ruby
# File format:
# [day of month zero-padded][three-letter prefix] \
# _[kind]_[age_if_kind_personal]_[target.id] \
# _[8 random chars]_[10 first chars of title].jpg
```

---

### 12. Weak Random Generation

**Description:** Using general-purpose random functions with hashing for
uniqueness instead of purpose-built secure random utilities.

**Indicators:**
- `rand()` for generating unique tokens
- Hashing random numbers for "randomness"
- Truncating hash output for shorter strings

**Example:**
```ruby
Digest::SHA1.hexdigest(rand(10000).to_s)[0,8]
```

---

### 13. Deeply Nested Negation Conditionals

**Description:** Chains of `if x != "A" and x != "B"` with more nested
conditions inside, making the logic nearly impossible to follow.

**Indicators:**
- Multiple `!=` comparisons combined with `and`
- Nested ifs inside negated conditions
- You need to mentally track "what we're NOT"
- 4+ levels of indentation

**Example:**
```ruby
if item.name != "Aged Brie" and item.name != "Backstage passes..."
  if item.quality > 0
    if item.name != "Sulfuras, Hand of Ragnaros"
      item.quality = item.quality - 1
    end
  end
end
```

---

### 14. External Object Manipulation (Feature Envy)

**Description:** One class reaches into another object to read and modify
its internal state repeatedly. The behavior belongs with the data.

**Indicators:**
- Multiple lines modifying `other_obj.field = ...`
- Methods that only operate on another object's data
- The host class has no state of its own being used
- Pattern: `obj.x = obj.x + 1` in an external class

**Example:**
```ruby
class GildedRose
  def update_quality
    @items.each do |item|
      item.quality = item.quality - 1  # manipulating item's state
      item.sell_in = item.sell_in - 1  # from outside
    end
  end
end
```

---

### 15. Type-Checking via String Comparison

**Description:** Using string comparisons against a type/name field to
determine behavior - a variant of "switch on type" smell.

**Indicators:**
- `if obj.name == "TypeA"` patterns
- Multiple branches checking the same string field
- Different behavior per string value

**Example:**
```ruby
if item.name == "Aged Brie"
  # brie behavior
elsif item.name == "Backstage passes to a TAFKAL80ETC concert"
  # passes behavior
elsif item.name == "Sulfuras, Hand of Ragnaros"
  # sulfuras behavior
end
```

---

### 16. Scattered Boundary Enforcement

**Description:** Multiple boundary checks (min/max) scattered throughout
the code instead of centralizing the constraint.

**Indicators:**
- Repeated `if x < 50` / `if x > 0` guards
- Boundary checks appear in multiple branches
- Easy to miss a check in one path

**Example:**
```ruby
if item.quality < 50
  item.quality = item.quality + 1
  if item.sell_in < 11
    if item.quality < 50  # checking again!
      item.quality = item.quality + 1
    end
  end
end
```

---

### 17. Anemic Data Model

**Description:** A data structure holds only data while another class
contains all the behavior that manipulates it.

**Indicators:**
- Struct or class with only attributes, no methods
- Another class with methods that only operate on that data
- "Manager" or "Service" class doing all the work
- Data and behavior are separated

**Example:**
```ruby
Item = Struct.new(:name, :sell_in, :quality)  # just data

class GildedRose  # all the behavior
  def update_quality
    @items.each do |item|
      # 40+ lines manipulating item
    end
  end
end
```

---

### 18. Explicit Returns in Case Branches

**Description:** Using `return` keyword on every case branch when Ruby
implicitly returns the last expression in a method.

**Indicators:**
- `return` keyword appearing in each `when` branch
- All branches of a case expression have explicit returns
- The case expression is the last thing in the method

**Example:**
```ruby
def speed
  case @type
  when :european_parrot
    return base_speed
  when :african_parrot
    return [0, base_speed - load].max
  when :norwegian_blue_parrot
    return (@nailed) ? 0 : compute_voltage_speed
  end
end
```

---

### 19. Unreachable Throw/Raise

**Description:** A `throw` or `raise` after case branches with no `else` -
indicating the developer didn't trust the case was exhaustive.

**Indicators:**
- Code after a case with no else that should never execute
- Comments like "Should be unreachable"
- Defensive programming due to unclear type handling

**Example:**
```ruby
def speed
  case @type
  when :european_parrot then base_speed
  when :african_parrot then computed_speed
  when :norwegian_blue_parrot then voltage_speed
  end
  throw "Should be unreachable!"
end
```

---

### 20. Ternary for Zero-or-Compute Pattern

**Description:** Using `condition ? 0 : complex_expression` when zero is
a special case that should be handled with a guard clause.

**Indicators:**
- Ternary where one branch is 0 and the other is complex
- The zero case represents "disabled" or "blocked" state
- The condition is a simple boolean check

**Example:**
```ruby
(@nailed) ? 0 : compute_base_speed_for_voltage(@voltage)
```

---

### 21. Semicolons in Ruby

**Description:** Semicolons at end of statements - a code smell from
other languages (C, Java, JavaScript) that adds visual noise in Ruby.

**Indicators:**
- Semicolons at the end of lines
- Multiple statements on one line separated by semicolons
- Inconsistent semicolon usage

**Example:**
```ruby
@type = type;
@number_of_coconuts = number_of_coconuts;
@voltage = voltage;
```

---

### 22. Computation Spread Across Methods by Type

**Description:** Type-specific computations spread across multiple helper
methods rather than consolidated into one place per type.

**Indicators:**
- Multiple private methods each handling one aspect of type variation
- Main method orchestrates calls to various type-specific helpers
- Hard to see all the behavior for one type in one place

**Example:**
```ruby
def speed
  case @type
  when :norwegian_blue_parrot
    return compute_base_speed_for_voltage(@voltage)  # helper 1
  end
end

def compute_base_speed_for_voltage voltage  # separate method
  [24.0, voltage * base_speed].min
end

def load_factor  # another separate method
  9.0
end
```

---

### 23. Duplicate Class Implementations

**Description:** Multiple classes implementing the same behavior in
different ways, often due to different developers or evolving
requirements.

**Indicators:**
- Multiple classes with the same public interface
- Each class has similar but subtly different logic
- Tests pass for all implementations
- No obvious reason for different implementations

**Example:**
```ruby
class TennisGame1
  def score
    # 40 lines of one approach
  end
end

class TennisGame2
  def score
    # 80 lines of a different approach
  end
end

class TennisGame3
  def score
    # 20 lines of yet another approach
  end
end
```

---

### 24. Sequential If Blocks as Poor Case Expression

**Description:** Multiple `if` statements checking the same variable
against different values, instead of using case/when or hash lookup.

**Indicators:**
- Consecutive `if (x == 0)`, `if (x == 1)`, `if (x == 2)` blocks
- Each block assigns to the same result variable
- The conditions are mutually exclusive

**Example:**
```ruby
if (@p1points == 0)
  result = "Love"
end
if (@p1points == 1)
  result = "Fifteen"
end
if (@p1points == 2)
  result = "Thirty"
end
```

---

### 25. Primitive Obsession with Paired Data

**Description:** Using separate primitive variables for data that belongs
together, instead of bundling them into an object.

**Indicators:**
- Parallel variables like `@p1points`, `@p2points`
- Same operations performed on each variable
- Methods that take one variable but need the other
- Symmetrical logic duplicated for each variable

**Example:**
```ruby
@player1_name = player1_name
@player2_name = player2_name
@p1points = 0
@p2points = 0
```

---

### 26. Cryptic Variable Names

**Description:** Single-letter or abbreviated variable names that obscure
meaning, requiring mental decoding to understand.

**Indicators:**
- Variables like @p1N, @p2N, @p1, @p2
- Comments needed to explain what variables mean
- Different naming conventions in the same code

**Example:**
```ruby
@p1N = player1_name  # player1_name
@p2N = player2_name  # player2_name
@p1 = 0             # player 1 points
@p2 = 0             # player 2 points
```

---

### 27. Redundant Conditions

**Description:** Conditions that are always true or always false,
adding noise without providing any filtering.

**Indicators:**
- `x >= 0` when x is initialized to 0 and only incremented
- `x != nil` after guaranteed initialization
- Conditions that can never be false given the code flow

**Example:**
```ruby
if (@p1points >= 4 and @p2points >= 0 and ...)  # @p2points >= 0 always true
```

---

### 28. Unused Methods

**Description:** Methods defined but never called, often left over from
refactoring or copied code.

**Indicators:**
- Public methods with no callers
- Helper methods that were superseded
- Test setup methods that are no longer needed

**Example:**
```ruby
def setp1Score(number)
  (0..number).each { |i| p1Score() }
end

def setp2Score(number)  # never called
  (0..number).each { |i| p2Score() }
end
```

---

### 29. God Function

**Description:** One function that does everything - fetching data,
calculating, formatting, and assembling output.

**Indicators:**
- Function is 30+ lines
- Multiple responsibilities visible (calc, format, output)
- Local variables accumulating different concerns
- Comments separating logical sections

**Example:**
```ruby
def statement(invoice, plays)
  total_amount = 0
  volume_credits = 0
  result = "Statement for #{invoice['customer']}\n"
  # ... 30+ lines doing everything
end
```

---

### 30. Inline Lambda for Reusable Logic

**Description:** A lambda defined inline for logic that should be a
named method or module function.

**Indicators:**
- `lambda { }` or `-> { }` in the middle of a method
- The lambda is called multiple times
- The logic is reusable outside this method

**Example:**
```ruby
format = lambda { |amount|
  "$#{'%.2f' % (amount / 100.0)}"
}
```

---

### 31. Hash as Domain Object

**Description:** Using raw hashes with string keys instead of proper
domain objects with named attributes.

**Indicators:**
- `obj['field']` access patterns throughout
- No type safety or validation
- Logic spread across functions that process the hash
- Comments explaining what fields the hash contains

**Example:**
```ruby
invoice['performances'].each do |perf|
  play = plays[perf['playID']]
  # ... using perf['audience'], play['type'], play['name']
end
```

---

### 32. Mixed Calculation and Presentation

**Description:** Computing values and building output strings in the
same method or loop.

**Indicators:**
- Arithmetic operations mixed with string concatenation
- `result +=` for both numeric totals and string building
- Formatting logic interleaved with business logic

**Example:**
```ruby
invoice['performances'].each do |perf|
  this_amount = calculate_amount(...)  # calculation
  result += " #{play['name']}: #{format.call(this_amount)}\n"  # presentation
  total_amount += this_amount  # accumulation
end
```

---

### 33. Type Dispatch via Case in Loop

**Description:** A case statement checking type inside a loop, indicating
the type-specific behavior should be polymorphic.

**Indicators:**
- `case obj['type']` or `case obj.type` inside an `each` block
- Different calculations per type
- Same pattern would repeat if you added a new type

**Example:**
```ruby
invoice['performances'].each do |perf|
  case play['type']
  when 'tragedy'
    this_amount = 40000
    # ...
  when 'comedy'
    this_amount = 30000
    # ...
  end
end
```

---

### 34. Parallel Arrays for Object Attributes

**Description:** Multiple arrays storing attributes that belong to the
same entity, indexed by position rather than bundled into objects.

**Indicators:**
- Multiple arrays initialized together (places, purses, in_penalty_box)
- Same index used across all arrays
- Array size represents max entities
- Adding a new attribute means adding another array

**Example:**
```ruby
@places = Array.new(6, 0)
@purses = Array.new(6, 0)
@in_penalty_box = Array.new(6, nil)

# Later accessed with same index:
@places[@current_player]
@purses[@current_player]
@in_penalty_box[@current_player]
```

---

### 35. Index-Based Current Item

**Description:** Using an integer index to track "current" item, with
manual increment/wrap logic instead of using collection rotation.

**Indicators:**
- `@current_player` or similar index variable
- `@current_player += 1` with wrap-around check
- `@players[@current_player]` access pattern
- Duplicated increment/wrap logic

**Example:**
```ruby
@current_player += 1
@current_player = 0 if @current_player == @players.length
```

---

### 36. Repeated Equality Checks for Categories

**Description:** Multiple `return if x == n` statements to map values
to categories instead of using arithmetic or lookup.

**Indicators:**
- Series of `return 'X' if y == n` statements
- Pattern repeats with regular intervals
- Same return value for multiple conditions

**Example:**
```ruby
return 'Pop' if @places[@current_player] == 0
return 'Pop' if @places[@current_player] == 4
return 'Pop' if @places[@current_player] == 8
return 'Science' if @places[@current_player] == 1
return 'Science' if @places[@current_player] == 5
return 'Science' if @places[@current_player] == 9
```

---

### 37. Stateful Flag Across Methods

**Description:** A boolean flag set in one method and read in another
to communicate state, instead of returning a value or using objects.

**Indicators:**
- Instance variable like `@is_getting_out_of_penalty_box`
- Set in one method, checked in a different method
- Flag resets create subtle bugs
- Hard to trace the flag's lifecycle

**Example:**
```ruby
def roll(roll)
  if roll % 2 != 0
    @is_getting_out_of_penalty_box = true
    # ...
  else
    @is_getting_out_of_penalty_box = false
  end
end

def was_correctly_answered
  if @is_getting_out_of_penalty_box
    # different behavior
  end
end
```

---

### 38. Pre-Generated Collection

**Description:** Creating a fixed number of items upfront when they
could be generated lazily or on-demand.

**Indicators:**
- `50.times` or similar loop at initialization
- Items are identical except for an index
- Not all items may be used
- Adding more requires code changes

**Example:**
```ruby
50.times do |i|
  @pop_questions.push "Pop Question #{i}"
  @science_questions.push "Science Question #{i}"
end
```

---

### 39. Duplicated Code Blocks

**Description:** The same multi-line code block appearing in multiple
places, often in different branches of conditionals.

**Indicators:**
- Copy-pasted blocks with minor variations
- Same sequence of operations repeated
- Bug fixes need to be applied multiple times

**Example:**
```ruby
# In penalty box branch:
winner = did_player_win()
@current_player += 1
@current_player = 0 if @current_player == @players.length
winner

# In normal branch:
winner = did_player_win
@current_player += 1
@current_player = 0 if @current_player == @players.length
return winner
```

---

### 40. Individual Parameters Instead of Collection

**Description:** Taking multiple individual parameters (d1, d2, d3, d4, d5)
when they represent a collection that should be passed as an array.

**Indicators:**
- Method signature with numbered parameter names
- Same operation performed on each parameter
- Parameters immediately converted to array inside method
- Adding/removing items requires changing method signature

**Example:**
```ruby
def self.chance(d1, d2, d3, d4, d5)
  total = 0
  total += d1
  total += d2
  total += d3
  total += d4
  total += d5
  return total
end
```

---

### 41. Copy-Paste Methods with Number Variation

**Description:** Nearly identical methods that differ only by a constant
value (ones, twos, threes, etc.).

**Indicators:**
- Methods with sequential names
- Method body identical except for one number
- Pattern would extend if more values added
- DRY violation across methods

**Example:**
```ruby
def self.ones(d1, d2, d3, d4, d5)
  sum = 0
  if (d1 == 1) then sum += 1 end
  if (d2 == 1) then sum += 1 end
  # ...
end

def self.twos(d1, d2, d3, d4, d5)
  sum = 0
  if (d1 == 2) then sum += 2 end
  if (d2 == 2) then sum += 2 end
  # ...
end
```

---

### 42. Mixed Class and Instance Methods

**Description:** A class with some methods as `self.method` and others
as instance methods, creating an inconsistent API.

**Indicators:**
- Some methods called as `Class.method(args)`
- Other methods requiring `Class.new(args).method`
- No clear reason for the difference
- Confusing to callers

**Example:**
```ruby
class Yatzy
  def self.chance(d1, d2, d3, d4, d5)  # class method
    # ...
  end

  def fours  # instance method
    # ...
  end
end
```

---

### 43. Manual Tally Counting

**Description:** Building a frequency count array manually instead of
using built-in collection methods.

**Indicators:**
- `counts = [0] * n` initialization
- `counts[value-1] += 1` pattern in loop
- Searching the counts array for specific frequencies
- Index arithmetic to convert back to values

**Example:**
```ruby
counts = [0]*6
counts[d1-1] += 1
counts[d2-1] += 1
counts[d3-1] += 1
counts[d4-1] += 1
counts[d5-1] += 1
```

---

### 44. Verbose Iteration Constructs

**Description:** Using verbose or archaic loop constructs instead of
idiomatic Ruby enumeration.

**Indicators:**
- `for i in Array(0..5)` instead of `(0..5).each`
- `for i in (Range.new(0, n))` instead of `(0..n).each`
- `for die in dice do` instead of `dice.each`
- Explicit loop variables when not needed

**Example:**
```ruby
for at in Array(0..4)
  if (@dice[at] == 4)
    sum += 4
  end
end
```

---

### 45. Inconsistent Variable Naming

**Description:** Multiple naming conventions or cryptic names used
within the same class or method.

**Indicators:**
- Mix of `_d1`, `d1`, `_d2_at` styles
- Single letters: s, t, i, n
- Different names for same concept (sum, s, total)
- Underscore prefixes used inconsistently

**Example:**
```ruby
def self.full_house(_d1, _d2, d3, d4, d5)
  tallies = []
  _d2 = false    # shadows parameter!
  _d2_at = 0
  _d3 = false
  # ...
end
```

---

### 46. Case Expression with Near-Duplicate Branches

**Description:** A case expression where each branch contains similar
multi-line content with only small variations.

**Indicators:**
- Heredocs or multi-line strings in each branch
- 80%+ of the text is identical across branches
- Only pronouns, quantities, or small words differ
- Adding a new case requires duplicating the whole block

**Example:**
```ruby
case number
when 2
  <<~VERSE
    2 bottles of beer on the wall, 2 bottles of beer.
    Take one down and pass it around, 1 bottle of beer on the wall.
  VERSE
when 1
  <<~VERSE
    1 bottle of beer on the wall, 1 bottle of beer.
    Take it down and pass it around, no more bottles of beer on the wall.
  VERSE
end
```

---

### 47. Embedded Knowledge in Literal Text

**Description:** Business logic embedded inside literal strings rather
than expressed through code that can vary.

**Indicators:**
- Numbers or words hardcoded in heredocs
- The same value appears multiple times in a string
- Changing a rule requires editing string content
- Logic and presentation are fused

**Example:**
```ruby
<<~VERSE
  #{number} bottles of beer on the wall, #{number} bottles of beer.
  Take one down and pass it around, #{number - 1} bottles of beer on the wall.
VERSE
# "one", "bottles", and the math are all hardcoded
```

---

## Refactorings

*Named transformations with before/after examples showing how to improve
code structure.*

### 1. Replace Parallel Arrays with Lookup Table

**Motivation:** Parallel arrays require keeping multiple data structures
in sync and use error-prone index arithmetic. A single hash with natural
keys is clearer and eliminates offset errors.

**Before:**
```ruby
ones_place = ['one',   'two',    'three',    'four',    'five',
             'six',   'seven',  'eight',    'nine']
tens_place = ['ten',   'twenty', 'thirty',   'forty',   'fifty',
             'sixty', 'seventy', 'eighty',  'ninety']
teenagers = ['eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen',
             'sixteen', 'seventeen', 'eighteen', 'nineteen']

# Usage requires index arithmetic:
ones_place[write-1]
teenagers[left-1]
tens_place[write-1]
```

**After:**
```ruby
NUMBERS = {
  1 => "one",
  2 => "two",
  3 => "three",
  # ... ones
  10 => "ten",
  11 => "eleven",
  # ... teens
  20 => "twenty",
  30 => "thirty",
  # ... tens
}

# Usage with natural keys:
NUMBERS[n]
NUMBERS[n % 10]
NUMBERS[n.truncate(-1)]
```

---

### 2. Replace Mutable Accumulator with Functional Composition

**Motivation:** Mutable accumulation scatters the result construction
throughout the code. Functional composition collects parts and joins
them in one expression.

**Before:**
```ruby
num_string = ''
if write > 0
  num_string = num_string + hundreds + ' hundred'
  if left > 0
    num_string = num_string + ' '
  end
end
# ... more conditional concatenation
num_string
```

**After:**
```ruby
[say(n / 100), "hundred", say(n % 100)].compact.join(" ")
```

**Key techniques:**
- Build an array of parts (some may be nil)
- Use `.compact` to remove nil values
- Use `.join(separator)` to combine with appropriate separator

---

### 3. Replace Nested Conditionals with Case Expression

**Motivation:** Nested if/else chains obscure the overall structure. A
case expression with ranges makes the branching logic flat and clear.

**Before:**
```ruby
if write > 0
  if ((write == 1) and (left > 0))
    num_string = num_string + teenagers[left-1]
    left = 0
  else
    num_string = num_string + tens_place[write-1]
  end
  if left > 0
    num_string = num_string + '-'
  end
end
```

**After:**
```ruby
case n
when (..20)
  NUMBERS[n]
when (..99)
  [NUMBERS[n.truncate(-1)], NUMBERS[n % 10]].compact.join("-")
else
  [say(n / 100), "hundred", say(n % 100)].compact.join(" ")
end
```

---

### 4. Extract Recursive Helper Method

**Motivation:** Separating the public interface from the recursive
implementation allows the main function to handle edge cases cleanly
while the helper focuses on the core algorithm.

**Before:**
```ruby
def english_number number
  if number < 0
    return 'Please enter a number that isn\'t negative.'
  end
  if number == 0
    return 'zero'
  end
  # ... 60+ lines of recursive logic
end
```

**After:**
```ruby
def english_number(n)
  return "zero" if n == 0
  say(n)
end

def say(n)
  case n
  when (..20)
    NUMBERS[n]
  when (..99)
    [NUMBERS[n.truncate(-1)], NUMBERS[n % 10]].compact.join("-")
  else
    [say(n / 100), "hundred", say(n % 100)].compact.join(" ")
  end
end
```

---

### 5. Replace Index Arithmetic with Natural Keys

**Motivation:** Using the actual number as the key eliminates off-by-one
errors and makes the code's intent clearer.

**Before:**
```ruby
ones_place[write-1]
# The "-1" is because ones_place[3] is 'four', not 'three'.
```

**After:**
```ruby
NUMBERS[n]
# The key IS the number. NUMBERS[3] is 'three'.
```

---

### 6. Remove Explanatory Comments by Making Code Self-Documenting

**Motivation:** When code is refactored to be clear, comments become
redundant noise. Delete comments that merely restate what clear code
already expresses.

**Before:**
```ruby
# "left" is how much of the number we still have left to write out.
# "write" is the part we are writing out right now.
# write and left... get it?  :)
left  = number
write = left/100          # How many hundreds left to write out?
left  = left - write*100  # Subtract off those hundreds.
```

**After:**
```ruby
# No comments needed - the code is self-explanatory:
[say(n / 100), "hundred", say(n % 100)].compact.join(" ")
```

---

### 7. Replace Module Method with Instance Class

**Motivation:** When a module's `self.method` repeatedly operates on a
single object, converting to a class with that object as instance data
makes the relationship explicit and enables further decomposition.

**Before:**
```ruby
module XYZ
  module Namer
    def self.xyz_filename(target)
      filename = "#{target.publish_on.strftime("%d")}"
      filename << "#{target.xyz_category_prefix}"
      filename << "#{target.kind.gsub("_", "")}"
      # ... more target.xxx calls
    end
  end
end
```

**After:**
```ruby
module XYZ
  class Namer < Struct.new(:file)
    def self.xyz_filename(file)
      new(file).filename
    end

    def filename
      # Now can use file.xxx without repeating "target"
      # And can extract private methods easily
    end
  end
end
```

---

### 8. Replace Shovel Chain with Array Composition

**Motivation:** Sequential `<<` operations obscure the structure. An array
of parts with `.compact.join` shows the format clearly in one place.

**Before:**
```ruby
filename = "#{target.publish_on.strftime("%d")}"
filename << "#{target.xyz_category_prefix}"
filename << "#{target.kind.gsub("_", "")}"
filename << "_%03d" % (target.age || 0) if target.personal?
filename << "_#{target.id.to_s}"
filename << "_#{random_chars}"
filename << "_#{truncated_title}"
filename << ".jpg"
```

**After:**
```ruby
def filename
  parts = [prefix, age, file.id, noise, title]
  parts.compact.join("_").concat(".jpg")
end
```

---

### 9. Extract Small Named Methods

**Motivation:** When each component is a simple expression, extracting
small named methods creates readable abstractions. Each method does one
thing and has a clear name.

**Before:**
```ruby
def filename
  day = file.publish_on.strftime("%d")
  cat = file.xyz_category_prefix
  k = file.kind.delete("_")
  # ... inline expressions mixed with logic
end
```

**After:**
```ruby
def prefix
  [publication_day, category, kind].join
end

def publication_day
  file.publish_on.strftime("%d")
end

def category
  file.xyz_category_prefix
end

def kind
  file.kind.delete("_")
end

def age
  return unless file.personal?
  format("%03d", file.age.to_i)
end

def noise
  SecureRandom.hex(4)
end

def title
  sanitized_title[0, 10]
end

def sanitized_title
  file.title.downcase.gsub(/[^\[a-z\]]/, "")
end
```

---

### 10. Replace Manual Truncation with Slice

**Motivation:** Ruby's `str[start, length]` handles strings shorter than
the limit gracefully, eliminating conditional length checks.

**Before:**
```ruby
truncated_title = target.title.gsub(/[^\[a-z\]]/i, '').downcase
truncate_to = truncated_title.length > 9 ? 9 : truncated_title.length
filename << "_#{truncated_title[0..(truncate_to)]}"
```

**After:**
```ruby
def title
  sanitized_title[0, 10]
end

def sanitized_title
  file.title.downcase.gsub(/[^\[a-z\]]/, "")
end
```

---

### 11. Use Struct for Simple Data Objects

**Motivation:** Use `Struct.new` for simple data-only objects (value
objects with no behavior). For classes with behavior, use explicit
`initialize` and `attr_reader` instead.

**Before:**
```ruby
class Namer
  def initialize(file)
    @file = file
  end

  def file
    @file
  end
end
```

**After (data-only object):**
```ruby
# Only for simple data holders without behavior:
Point = Struct.new(:x, :y)
```

**After (class with behavior):**
```ruby
class Namer
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def filename
    # behavior that uses file
  end
end
```

---

### 12. Replace Weak Random with SecureRandom

**Motivation:** Purpose-built secure random utilities are clearer, more
correct, and express intent better than hand-rolled alternatives.

**Before:**
```ruby
Digest::SHA1.hexdigest(rand(10000).to_s)[0,8]
```

**After:**
```ruby
SecureRandom.hex(4)  # produces 8 hex characters
```

---

### 13. Move Behavior to Data Object

**Motivation:** When one class exists only to manipulate another object's
state, the behavior should move to the object that owns the data.

**Before:**
```ruby
Item = Struct.new(:name, :sell_in, :quality)

class GildedRose
  def update_quality
    @items.each do |item|
      item.quality = item.quality - 1
      item.sell_in = item.sell_in - 1
      # ... 40 more lines manipulating item
    end
  end
end
```

**After:**
```ruby
Item = Struct.new(:name, :sell_in, :quality) do
  def update
    self.sell_in -= 1
    self.quality -= sell_in < 0 ? 2 : 1
    self.quality = quality.clamp(0, 50)
  end
end

class GildedRose < Struct.new(:items)
  def update_quality
    items.each(&:update)
  end
end
```

---

### 14. Replace Negated Chains with Case Expression

**Motivation:** `if x != "A" and x != "B"` chains are hard to follow.
A case statement with explicit `when` clauses shows what IS matched.

**Before:**
```ruby
if item.name != "Aged Brie" and item.name != "Backstage passes..."
  if item.quality > 0
    if item.name != "Sulfuras"
      item.quality = item.quality - 1
    end
  end
else
  # different logic
end
```

**After:**
```ruby
case name
when "Aged Brie"
  # brie logic
when "Backstage passes to a TAFKAL80ETC concert"
  # passes logic
when "Sulfuras, Hand of Ragnaros"
  # sulfuras logic (nothing)
else
  # default logic
end
```

---

### 15. Replace Scattered Bounds Checks with Clamp

**Motivation:** Multiple `if quality < 50` / `if quality > 0` checks
are error-prone. A single `.clamp(min, max)` enforces bounds consistently.

**Before:**
```ruby
if item.quality < 50
  item.quality = item.quality + 1
end
if item.quality < 50
  item.quality = item.quality + 1
end
if item.quality > 0
  item.quality = item.quality - 1
end
```

**After:**
```ruby
self.quality += delta
self.quality = quality.clamp(0, 50)
```

---

### 16. Enhance Struct with Block

**Motivation:** Structs can include methods via a block, adding behavior
to data structures without a separate class definition.

**Before:**
```ruby
Item = Struct.new(:name, :sell_in, :quality)

# Behavior defined elsewhere
```

**After:**
```ruby
Item = Struct.new(:name, :sell_in, :quality) do
  def update
    # behavior lives with data
  end
end
```

---

### 17. Replace Iterator Block with Symbol-to-Proc

**Motivation:** When iterating just to call a single method on each item,
`&:method` is more concise than a block.

**Before:**
```ruby
items.each { |item| item.update }
# or
items.each do |item|
  item.update
end
```

**After:**
```ruby
items.each(&:update)
```

---

### 18. Replace Conditional Increment with Case Expression

**Motivation:** When the logic for computing a delta varies by conditions,
a case expression that returns the delta is clearer than scattered
increments.

**Before:**
```ruby
if item.quality < 50
  item.quality = item.quality + 1
  if item.sell_in < 11
    if item.quality < 50
      item.quality = item.quality + 1
    end
  end
  if item.sell_in < 6
    if item.quality < 50
      item.quality = item.quality + 1
    end
  end
end
```

**After:**
```ruby
self.quality += case
                when sell_in < 0 then -self.quality
                when sell_in < 5 then 3
                when sell_in < 10 then 2
                else 1
                end
```

---

### 19. Replace Explicit Returns with Implicit

**Motivation:** Ruby implicitly returns the last expression. Explicit
`return` keywords add noise when they appear on every branch.

**Before:**
```ruby
def speed
  case @type
  when :european_parrot
    return base_speed
  when :african_parrot
    return [0, base_speed - load].max
  when :norwegian_blue_parrot
    return (@nailed) ? 0 : computed_speed
  end
end
```

**After:**
```ruby
def speed
  case type
  when :european_parrot
    base_speed
  when :african_parrot
    [0, base_speed - load].max
  when :norwegian_blue_parrot
    nailed ? 0 : computed_speed
  end
end
```

---

### 20. Replace Ternary Zero-Check with Guard Clause

**Motivation:** When zero represents a "blocked" or "disabled" state,
a guard clause makes the special case explicit and simplifies the
main expression.

**Before:**
```ruby
def speed
  case @type
  when :norwegian_blue_parrot
    return (@nailed) ? 0 : compute_speed
  end
end
```

**After:**
```ruby
def speed
  return 0 if nailed

  # main computation follows
  base_speed.clamp(0, 24)
end
```

---

### 21. Move Type Variation into Helper Method

**Motivation:** When the main method has shared logic (like bounds
checking) plus type-specific variation, move the variation into a helper
and let the main method focus on the common logic.

**Before:**
```ruby
def speed
  case @type
  when :european_parrot
    return base_speed
  when :african_parrot
    return [0, base_speed - load_factor * @coconuts].max
  when :norwegian_blue_parrot
    return (@nailed) ? 0 : [24.0, @voltage * base_speed].min
  end
end
```

**After:**
```ruby
def speed
  return 0 if nailed
  base_speed.clamp(0, 24)
end

private

def base_speed
  case type
  when :african_parrot then 12 - (9 * number_of_coconuts)
  when :european_parrot then 12
  when :norwegian_blue_parrot then voltage * 12
  end
end
```

---

### 22. Replace Unreachable Throw with Else Branch

**Motivation:** An unreachable `throw` after a case with no else
indicates defensive coding. Make the error handling explicit with
an `else` branch.

**Before:**
```ruby
def speed
  case @type
  when :european_parrot then base_speed
  when :african_parrot then computed_speed
  when :norwegian_blue_parrot then voltage_speed
  end
  throw "Should be unreachable!"
end
```

**After:**
```ruby
def base_speed
  case type
  when :african_parrot then 12 - (9 * number_of_coconuts)
  when :european_parrot then 12
  when :norwegian_blue_parrot then voltage * 12
  else
    raise "Unexpected type: #{type}"
  end
end
```

---

### 23. Consolidate Bounds at Call Site

**Motivation:** When different branches each apply their own min/max
logic, consolidate the bounds checking in the caller with a single
`.clamp(min, max)`.

**Before:**
```ruby
def speed
  case @type
  when :african_parrot
    return [0, base_speed - load].max  # floor at 0
  when :norwegian_blue_parrot
    return [24.0, voltage * base_speed].min  # cap at 24
  end
end
```

**After:**
```ruby
def speed
  return 0 if nailed
  base_speed.clamp(0, 24)  # bounds applied once
end

def base_speed
  case type
  when :african_parrot then 12 - (9 * number_of_coconuts)
  when :norwegian_blue_parrot then voltage * 12
  # ... can return values outside bounds
  end
end
```

---

### 24. Extract Domain Object from Primitives

**Motivation:** When parallel primitives (@p1points, @p2points) are
always manipulated together, extract them into a first-class object.

**Before:**
```ruby
@player1_name = player1_name
@player2_name = player2_name
@p1points = 0
@p2points = 0

def won_point(player_name)
  if player_name == @player1_name
    @p1points += 1
  else
    @p2points += 1
  end
end
```

**After:**
```ruby
class Player < Struct.new(:name, :points)
  def initialize(name)
    super(name, 0)
  end

  def win_point
    self.points += 1
  end
end

@player1 = Player.new(player1_name)
@player2 = Player.new(player2_name)

def won_point(player_name)
  players.find { it.name == player_name }.win_point
end
```

---

### 25. Replace Sequential Ifs with Case/Hash Lookup

**Motivation:** Sequential `if (x == 0) ... if (x == 1)` blocks are
verbose and error-prone. Use case expressions or hash lookups instead.

**Before:**
```ruby
if (@p1points == 0)
  result = "Love"
end
if (@p1points == 1)
  result = "Fifteen"
end
if (@p1points == 2)
  result = "Thirty"
end
```

**After:**
```ruby
def score
  %w[Love Fifteen Thirty Forty][points]
end
```

---

### 26. Use Pattern Matching Case Expression

**Motivation:** Ruby 3's pattern matching allows matching on multiple
values simultaneously, making complex branching logic declarative.

**Before:**
```ruby
def score
  if @p1points == @p2points and @p1points < 3
    # tied, early game
  elsif @p1points == @p2points
    "Deuce"
  elsif @p1points >= 4 or @p2points >= 4
    # end game
  else
    # normal scoring
  end
end
```

**After:**
```ruby
def score
  case [max_points, point_diff]
  in [..2, 0] then "#{leader.score}-All"
  in [3.., 0] then "Deuce"
  in [..3, 1..] then "#{player1.score}-#{player2.score}"
  in [4.., 1] then "Advantage #{leader}"
  in [4.., 2..] then "Win for #{leader}"
  end
end
```

---

### 27. Unify Duplicate Implementations via Inheritance

**Motivation:** When multiple classes implement the same interface with
duplicated logic, extract common code into a parent class.

**Before:**
```ruby
class TennisGame1
  def initialize(p1, p2) ... end
  def won_point(name) ... end
  def score ... end  # 40 lines
end

class TennisGame2
  def initialize(p1, p2) ... end
  def won_point(name) ... end
  def score ... end  # 80 lines
end

class TennisGame3
  def initialize(p1, p2) ... end
  def won_point(name) ... end
  def score ... end  # 20 lines
end
```

**After:**
```ruby
class TennisGame
  # shared implementation
end

class TennisGame1 < TennisGame; end
class TennisGame2 < TennisGame; end
class TennisGame3 < TennisGame; end
```

---

### 28. Derive Computed Values with Helper Methods

**Motivation:** When logic depends on derived values (like max_points,
point_diff, leader), extract them as named helper methods.

**Before:**
```ruby
def score
  if (@p1points >= 4 or @p2points >= 4)
    minus_result = @p1points - @p2points
    if (minus_result == 1)
      result = "Advantage " + @player1_name
    elsif (minus_result == -1)
      result = "Advantage " + @player2_name
    # ...
  end
end
```

**After:**
```ruby
def score
  case [max_points, point_diff]
  in [4.., 1] then "Advantage #{leader}"
  # ...
  end
end

private

def leader
  players.max_by(&:points)
end

def max_points
  players.map(&:points).max
end

def point_diff
  players.map(&:points).reduce(&:-).abs
end

def players
  [player1, player2]
end
```

---

### 29. Replace Inline Lambda with Module Method

**Motivation:** An inline lambda for reusable formatting logic should
be extracted to a named method in a utility module.

**Before:**
```ruby
def statement(invoice, plays)
  format = lambda { |amount|
    "$#{'%.2f' % (amount / 100.0)}"
  }
  # ... uses format.call(amount) multiple times
end
```

**After:**
```ruby
module Utils
  module Formatters
    def usd(amount)
      format("$%.2f", amount / 100.0)
    end
  end
end

class DisplayStatement
  include Utils::Formatters
  # ... uses usd(amount)
end
```

---

### 30. Replace Hash with Domain Object

**Motivation:** Raw hashes with string keys lack type safety and
validation. Domain objects make fields explicit and can include behavior.

**Before:**
```ruby
invoice['performances'].each do |perf|
  play = plays[perf['playID']]
  this_amount = case play['type']
                when 'tragedy' then ...
                end
end
```

**After:**
```ruby
class Performance < Struct.new(:name, :type, :audience)
  def amount
    type.amount_for(audience)
  end
end

performances = invoice["performances"].map do |perf|
  Performance.new(play["name"], PlayTypes.build(play["type"]), ...)
end
```

---

### 31. Replace Type Case with Polymorphism

**Motivation:** A case statement on type inside a loop indicates each
type should be its own class with polymorphic behavior.

**Before:**
```ruby
case play['type']
when 'tragedy'
  this_amount = 40000
  this_amount += 1000 * (audience - 30) if audience > 30
when 'comedy'
  this_amount = 30000
  this_amount += 300 * audience
end
```

**After:**
```ruby
module PlayTypes
  class Tragedy
    def amount_for(audience)
      result = 40000
      result += 1000 * (audience - 30) if audience > 30
      result
    end
  end

  class Comedy
    def amount_for(audience)
      30000 + (300 * audience) + bonus(audience)
    end
  end
end
```

---

### 32. Use Factory Method for Type Instantiation

**Motivation:** When creating type-specific classes from a string type
field, a factory method centralizes the mapping and error handling.

**Before:**
```ruby
case play['type']
when 'tragedy' then Tragedy.new
when 'comedy' then Comedy.new
else raise "unknown type"
end
```

**After:**
```ruby
module PlayTypes
  def self.build(type)
    clazz = "Models::PlayTypes::#{type.classify}".safe_constantize
    raise "unknown type: #{type}" unless clazz
    clazz.new
  end
end
```

---

### 33. Separate Calculation from Presentation

**Motivation:** When calculation and display are mixed in one method,
separate them into domain models (calculation) and services (display).

**Before:**
```ruby
def statement(invoice, plays)
  total_amount = 0
  result = "Statement for #{invoice['customer']}\n"
  invoice['performances'].each do |perf|
    this_amount = calculate(...)
    result += " #{play['name']}: #{format(this_amount)}\n"
    total_amount += this_amount
  end
  result
end
```

**After:**
```ruby
class Statement < Struct.new(:customer, :performances)
  def total_amount
    performances.sum(&:amount)
  end

  def display
    Services::DisplayStatement.new(self).run
  end
end

class DisplayStatement < Struct.new(:statement)
  def run
    # presentation logic only
  end
end
```

---

### 34. Replace Loop Accumulation with Collection Methods

**Motivation:** Manual accumulation in loops can be replaced with
`.sum`, `.map`, and other collection methods.

**Before:**
```ruby
total_amount = 0
volume_credits = 0
invoice['performances'].each do |perf|
  total_amount += this_amount
  volume_credits += credits
end
```

**After:**
```ruby
def total_amount
  performances.sum(&:amount)
end

def total_credits
  performances.sum(&:credits)
end
```

---

### 35. Replace Parallel Arrays with Object Collection

**Motivation:** Parallel arrays for entity attributes should become
a collection of objects, each holding its own attributes.

**Before:**
```ruby
@players = []
@places = Array.new(6, 0)
@purses = Array.new(6, 0)
@in_penalty_box = Array.new(6, nil)

# Accessed via:
@places[@current_player]
@purses[@current_player]
```

**After:**
```ruby
class Player < Struct.new(:name, :purse, :location, :in_penalty_box)
  def initialize(name)
    super(name, 0, 0, false)
  end
end

@players = []  # collection of Player objects
current_player.location
current_player.purse
```

---

### 36. Replace Index Tracking with Collection Rotation

**Motivation:** Manual index management with wrap-around is error-prone.
Collection rotation lets the "current" item always be at position 0.

**Before:**
```ruby
@current_player = 0

def advance
  @current_player += 1
  @current_player = 0 if @current_player == @players.length
end

def current
  @players[@current_player]
end
```

**After:**
```ruby
class PlayerQueue
  attr_reader :players

  def advance_to_next_player
    players.rotate!
  end

  def current_player
    players.first
  end
end
```

---

### 37. Replace Repeated Returns with Modulo Arithmetic

**Motivation:** When values cycle through a fixed pattern, modulo
arithmetic eliminates repeated equality checks.

**Before:**
```ruby
return 'Pop' if @places[@current_player] == 0
return 'Pop' if @places[@current_player] == 4
return 'Pop' if @places[@current_player] == 8
return 'Science' if @places[@current_player] == 1
# ... 9 more lines
```

**After:**
```ruby
CATEGORIES = %w[Pop Science Sports Rock]

def category_of(location)
  CATEGORIES[location % CATEGORIES.count]
end
```

---

### 38. Replace Pre-Generated Collection with Lazy Generation

**Motivation:** Pre-generating items uses memory and limits flexibility.
Lazy generation creates items on demand.

**Before:**
```ruby
50.times do |i|
  @pop_questions.push "Pop Question #{i}"
  @science_questions.push "Science Question #{i}"
end

def ask_question
  puts @pop_questions.shift if current_category == 'Pop'
end
```

**After:**
```ruby
class QuestionDeck
  def initialize
    @questions = CATEGORIES.to_h { [it, 0] }
  end

  def next_question(category)
    i = questions[category]
    questions[category] += 1
    "#{category} Question #{i}"
  end
end
```

---

### 39. Replace Cross-Method Flag with Guard Clause

**Motivation:** Flags set in one method and read in another create
coupling and bugs. Guard clauses keep state local.

**Before:**
```ruby
def roll(roll)
  if roll % 2 != 0
    @is_getting_out_of_penalty_box = true
    take_turn
  else
    @is_getting_out_of_penalty_box = false
  end
end

def was_correctly_answered
  if @is_getting_out_of_penalty_box
    # award points
  end
end
```

**After:**
```ruby
def roll(roll)
  return unless can_take_turn?(roll)
  take_turn
end

private

def can_take_turn?(roll)
  return true unless current_player.in_penalty_box?
  if roll.odd?
    current_player.exit_penalty_box
    true
  else
    false
  end
end
```

---

### 40. Extract Collaborator Class

**Motivation:** When a class manages a collection with its own logic,
extract the collection into a dedicated collaborator class.

**Before:**
```ruby
class Game
  def initialize
    @players = []
    @current_player = 0
  end

  def add(player_name)
    @players.push player_name
  end

  def advance
    @current_player += 1
    @current_player = 0 if @current_player == @players.length
  end
end
```

**After:**
```ruby
class PlayerQueue
  attr_reader :players
  delegate :count, to: :players

  def add_player(player_name)
    players << Player.new(player_name)
  end

  def advance_to_next_player
    players.rotate!
  end

  def current_player
    players.first
  end
end

class Game
  delegate :advance_to_next_player, :current_player, to: :players
end
```

---

## Design Patterns

*Structural patterns that emerge from or guide refactoring efforts.*

### Lookup Table Pattern

**Description:** Replace algorithmic computation with direct table lookup
for known, finite sets of values.

**When to use:**
- Finite domain of inputs
- Each input maps to a specific output
- The mapping doesn't follow a simple formula
- You have irregular cases (like "eleven" not following "one-teen")

**Structure:**
```ruby
LOOKUP_TABLE = {
  key1 => value1,
  key2 => value2,
  # ...
}

def compute(input)
  LOOKUP_TABLE[input] || derive_from_parts(input)
end
```

**Benefits:**
- Eliminates complex conditional logic
- Makes irregular cases explicit
- Easy to modify/extend
- Self-documenting

---

### Self-Documenting Composition Pattern

**Description:** Structure code so that method names and composition
read as documentation, eliminating the need for format comments.

**When to use:**
- Building a composite result from multiple parts
- The format has a clear structure with named components
- You have a specification comment describing the format

**Structure:**
```ruby
def result
  [component_a, component_b, component_c].compact.join(separator)
end

def component_a
  # ...
end

def component_b
  # ...
end

def component_c
  # ...
end
```

**Benefits:**
- Method names describe what each part is
- The composition line shows the overall structure
- Changes to format are localized
- No need for format specification comments

---

### Struct-Based Value Wrapper Pattern

**Description:** Use Struct inheritance to create lightweight classes
that wrap a subject object for transformation or formatting.

**When to use:**
- A function primarily operates on one object
- You want to extract multiple helper methods
- The helpers need shared access to the subject
- No complex initialization logic needed

**Structure:**
```ruby
class Transformer
  attr_reader :subject

  def self.transform(subject)
    new(subject).result
  end

  def initialize(subject)
    @subject = subject
  end

  def result
    # use subject.xxx and extracted helpers
  end

  private

  def helper_a
    subject.something
  end

  def helper_b
    subject.other_thing
  end
end
```

**Benefits:**
- Class method preserves the original API
- Instance methods have implicit access to subject
- Easy to extract and test helpers independently
- Struct provides free initialization and accessors

---

### Rich Domain Object Pattern

**Description:** Enhance data structures with behavior, moving logic
from external manipulators into the objects that own the data.

**When to use:**
- A data structure (Struct, plain class) is being manipulated externally
- An external class does nothing but modify the data object
- The behavior is intrinsic to the data (not application-specific)
- You want to encapsulate business rules with the data

**Structure:**
```ruby
DataObject = Struct.new(:field_a, :field_b) do
  def perform_operation
    self.field_a = compute_new_value
    enforce_constraints
  end

  private

  def compute_new_value
    # logic that was external
  end

  def enforce_constraints
    self.field_a = field_a.clamp(min, max)
  end
end
```

**Benefits:**
- Behavior lives with the data it operates on
- External classes become thin coordinators
- Easier to test - test the object in isolation
- Encapsulation prevents invalid states

---

### Polymorphic Type Strategy Pattern

**Description:** Replace type-checking conditionals with polymorphic
classes, where each type class implements the same interface.

**When to use:**
- Case statements on type string/symbol inside loops
- Each type has different calculation logic
- You're adding new types frequently
- The type-specific logic is complex enough to warrant its own class

**Structure:**
```ruby
module Types
  def self.build(type_name)
    # factory method to instantiate the right class
  end

  class TypeA
    def calculate(input)
      # TypeA-specific logic
    end
  end

  class TypeB
    def calculate(input)
      # TypeB-specific logic
    end
  end
end

# Usage: the type object is composed into the domain object
class DomainObject < Struct.new(:name, :type, :data)
  def result
    type.calculate(data)
  end
end
```

**Benefits:**
- Adding a new type means adding a new class, not touching existing code
- Each type's logic is isolated and testable
- No conditional explosion as types multiply
- Open/Closed principle - open for extension, closed for modification

---

### Layered Architecture Pattern (Models/Services/Utils)

**Description:** Organize code into layers: Models for domain objects
and calculations, Services for orchestration and presentation, Utils
for shared utilities.

**When to use:**
- God functions mixing concerns
- Calculation and presentation tangled together
- Reusable utilities duplicated inline
- Code has no clear organizational structure

**Structure:**
```ruby
module Models
  class DomainObject < Struct.new(:fields)
    def computed_value
      # business logic
    end
  end
end

module Services
  class Presenter < Struct.new(:model)
    def run
      # formatting and output
    end
  end
end

module Utils
  module Formatters
    def format_money(cents)
      # reusable formatting
    end
  end
end
```

**Benefits:**
- Clear separation of concerns
- Each layer has a single responsibility
- Easy to test each layer in isolation
- Changes to one layer don't ripple through others

---

## Transformation Sequences

*Reusable refactoring sequences for common code patterns. Each sequence
describes a general approach that can be applied to similar problems.*

---

### Parallel Arrays to Lookup Table

**When to apply:** Code uses multiple parallel arrays to store related
data, accessed with index arithmetic.

**Steps:**

1. **Consolidate into single data structure** - Replace parallel arrays
   with a single hash or array of objects using natural keys.

2. **Extract helper method** - Create a private method for the lookup
   logic, keeping the public interface unchanged.

3. **Replace nested conditionals with case** - Convert if/else chains
   to case expressions with ranges or pattern matching.

4. **Replace mutable accumulator with composition** - Instead of
   building strings with `+=`, use `[parts].compact.join(separator)`.

5. **Remove dead code and redundant comments** - Delete unused variables
   and comments that restate what clear code already expresses.

6. **Final cleanup** - Ensure consistent style and verify edge cases.

---

### Module Method to Instance Class

**When to apply:** A module method (`def self.method(obj)`) repeatedly
accesses properties of a single object passed as a parameter.

**Steps:**

1. **Create class with subject as instance data** - Replace the module
   method with a class that takes the subject in `initialize`.

2. **Replace shovel chain with parts array** - Convert sequential `<<`
   operations to an array with `.compact.join(separator)`.

3. **Extract named helper methods** - For each component, create a
   private method with a descriptive name.

4. **Group related components** - Combine helpers into composition
   methods that reflect logical groupings.

5. **Replace manual logic with standard library** - Use `delete`,
   `SecureRandom.hex`, `str[0, n]` etc. instead of manual equivalents.

6. **Remove specification comments** - Self-documenting method names
   eliminate the need for format comments.

---

### Anemic to Rich Domain Object

**When to apply:** An external class manipulates another object's data
through its accessors - the behavior belongs with the data.

**Steps:**

1. **Add method stub to data object** - Add an `update` or similar
   method to the data class, initially empty or calling original code.

2. **Move one piece of logic** - Start with the simplest mutation and
   move it into the data object's method.

3. **Replace negated conditionals with case** - Use `case field` with
   explicit `when` clauses instead of `if x != "A" and x != "B"`.

4. **Consolidate variant logic** - Gather all updates for each variant
   into a single cohesive block.

5. **Centralize bounds checking** - Replace scattered min/max guards
   with a single `.clamp(min, max)` at the end.

6. **Simplify the coordinator** - The orchestrating class becomes a thin
   wrapper calling `items.each(&:update)`.

---

### Type Dispatch Simplification

**When to apply:** A method has a case statement on type with bounds
logic mixed into each branch.

**Steps:**

1. **Clean up initialization** - Ensure clean attribute setup with
   attr_reader and proper initialize.

2. **Extract guard clause for special cases** - If one condition (like
   disabled/blocked) applies across all types, extract it as a guard.

3. **Move type dispatch to helper** - Create a private method containing
   just the type-specific case expression.

4. **Remove explicit returns** - Let the case expression be the implicit
   return value.

5. **Consolidate bounds with clamp** - Replace scattered `[0, x].max`
   and `[limit, x].min` with single `.clamp(min, max)`.

6. **Add else branch for errors** - Replace unreachable throws with
   proper `else` branch raising descriptive error.

---

### Primitives to Domain Objects

**When to apply:** Parallel primitive variables (like `@item1_name`,
`@item1_score`, `@item2_name`, `@item2_score`) are manipulated together.

**Steps:**

1. **Create domain object class** - Extract a class holding the related
   attributes with behavior methods.

2. **Replace primitives with objects** - Replace `@item1_name, @item1_score`
   with `@item1 = DomainObject.new(name)`.

3. **Add derived value helpers** - Extract computed values like `leader`,
   `max_value`, `difference` as private helper methods.

4. **Replace sequential ifs with lookup** - Convert `if x == 0` chains
   to array or hash lookups.

5. **Use pattern matching for complex logic** - Replace nested conditionals
   with pattern matching on `[derived_value_a, derived_value_b]`.

6. **Extract shared base class** - If multiple classes share logic,
   move it to a base class.

---

### God Function to Layered Architecture

**When to apply:** A single function mixes data fetching, calculations,
formatting, and output assembly.

**Steps:**

1. **Create type strategy classes** - For each type in a case statement,
   create a class with the type-specific calculations.

2. **Create factory method** - Add a `build(type)` factory that maps
   type strings to class instances.

3. **Create domain objects** - Extract classes for the main entities
   with methods delegating to type strategies.

4. **Create aggregate object** - Build a class that holds collections
   with computed totals using `.sum(&:method)`.

5. **Extract utility modules** - Move reusable formatting logic into
   `Utils::` modules, mixed in where needed.

6. **Create presentation service** - Separate display logic into a
   service class that takes the domain object.

---

### Parallel Arrays to Collaborator Objects

**When to apply:** Multiple arrays store attributes of the same entities,
accessed by a shared index variable.

**Steps:**

1. **Create entity class** - Extract a class holding all attributes
   for one entity with behavior methods.

2. **Replace arrays with object collection** - Remove parallel arrays,
   store entity objects in a single collection.

3. **Extract collection manager** - Create a collaborator class to
   manage the collection with its own logic.

4. **Create lazy generators** - Replace pre-generated collections with
   classes that generate items on demand.

5. **Replace repeated checks with arithmetic** - Use modulo or array
   lookup instead of repeated equality checks.

6. **Eliminate cross-method flags** - Replace flags set in one method
   and read in another with guard clauses or return values.

---

### Repetitive Methods to Idiomatic Ruby

**When to apply:** Multiple methods have nearly identical bodies,
differing only by a constant value.

**Steps:**

1. **Replace individual parameters with splat** - Change numbered
   parameters to `*args` accepting a collection.

2. **Unify class/instance methods** - Convert all methods to instance
   methods with shared state in `@attributes`.

3. **Replace manual loops with collection methods** - Use `.sum`,
   `.count`, `.map` instead of explicit accumulation.

4. **Replace manual tallies** - Use `.tally` instead of building
   frequency arrays manually.

5. **Consolidate copy-paste methods** - Replace nearly identical methods
   with parameterized single implementation.

6. **Use collection predicates** - Replace loop-and-check patterns with
   `.uniq.one?`, `.sort == expected`, `.tally.values.sort`.

---

### Case Branches to Polymorphic Objects

**When to apply:** A case expression has multiple branches with similar
structure but varying details (quantities, text, behavior).

**Steps:**

1. **Create base class with defaults** - Define a base class with methods
   returning the default/common values.

2. **Identify varying parts** - Extract each piece that differs between
   branches as a method on the base class.

3. **Create subclasses for variants** - For each special case, create
   a subclass overriding only what differs.

4. **Create factory method** - Add `self.for(identifier)` returning the
   appropriate subclass instance.

5. **Replace case with factory delegation** - Call factory, then build
   result using methods on the returned object.

6. **Simplify to template** - The main method becomes a string template
   that interpolates the polymorphic object's methods.

---

## Notes

- Each code smell should have a descriptive name and clear identification
  criteria
- Each refactoring should include before/after code samples
- Refactorings should be context-independent and applicable to similar
  code structures
- The transformation sequence should be reproducible from the starting
  code to the final result
