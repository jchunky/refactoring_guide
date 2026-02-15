# Exos

A collection of (anonymized) legacy code, for refactoring purposes.

Some simplifications have been made, in order to avoid dependencies
like ActiveRecord and PostgreSQL.

For some of the samples I've retrofitted tests onto the code, which
can be awkward and weird.

Have at it!

## Code Examples

* `calendar/holiday.rb`
  Contains basic utility methods to calculate mothersday and fathersday
  (in Norway).
  This was extracted from a kitchen sink class in a Rails application.
  Specs have been retrofitted.

* `gossip/v1.rb`
  This was originally a feature in a Rails application for tipping people
  about content on the site by sending a short message and a link via email
  or sms.
  This has been extracted into a tiny Sinatra application, but the basic
  structure of the feature is the same: A controller action that talks to
  a utility-type module, which use a couple of the active record models
  in the application. Also there's a mailer and the view that goes along
  with it. I've replaced the mailer with the `Pony` gem, and faked out
  ActiveRecord.

* `metadata/xyz.rb`
  Extracted from code for a cron job that loads the entire environment of
  a Rails application. That code prepares metadata for a file that gets
  transferred to a 3rd party.

* `reckoning/v1.rb`
  This was lifted almost unchanged from a Sinatra application. Names
  have been changed to protect the innocent (or the guilty, as the case
  may be).

* `restrictions/content.rb`
  Extracted from authorization logic in a Sinatra application (API).

* `sms/dispatch.rb`
  I extracted this from an ActiveRecord model in a Rails application.
  It had a test that sent an actual SMS to one of the developers. It
  was wrapped in VCR, so the message only got sent when we re-recorded
  the specs.

* `tinyurl/lookup.rb`
  This was actually part of the `gossip` example, but is juicy enough
  to stand alone. This calls out to the is.gd url shortening service.
  The only change I've made is to add methods for `endpoint` and
  `environment` so that I could add tests without going mad.

* `xyz/namer.rb`
  This was extracted from the same Rails application as the `metadata`
  example. The purpose of the code is to name a file per a bunch of
  business rules. The name of the file would decide which of 60 target
  organizations would receive it into their production system, and what
  directory/category it would be in. Extremely critical piece of code
  that had seen a lot of bugs and a lot of churn before we got it more
  or less right. How we did that without tests is a mystery.
  I've added tests.

* `codersdojo/scheduler_interrupt_listener.rb`
  The codersdojo is a great little project. At one point I wanted to
  make a small contribution to it, and got sucked into the codebase.
  It has many fascinating opportunities for thinking about Object Oriented
  Design, as well as how tests are used. I didn't port the tests over,
  because they have several dependencies.

  For more indepth context about this code example see the section
  _CodersDojo_ below.

  I think this particular example has a small abstraction hiding inside of
  it. What do you think?


## CodersDojo

This code was lifted unchanged from [github.com/it-agile/codersdojo](https://github.com/it-agile/codersdojo_client/blob/8f811002d6e612c06c586811282135d46bfbb308/lib/run/scheduler_interrupt_listener.rb)

The context for this code is this: You have a script running in the background
while you perform a Kata. This script records the state of the code each time
you run the tests (green or red), and the number of seconds between each test run.

When you kill the script, you're given several options:
- just exit
- upload your kata/performance to the the codersdojo website
  (and then exit, presumably)
- revert to the last green state (and then resume)
- just resume

There are three tests in the original project (not ported to this example),
and they specify the following:

- By default there is no last action.
- On Ctrl-C + e the program should exit
- On Ctrl-C + any other command, it should execute that command

[scheduler_interrupt_listener_spec.rb](https://github.com/it-agile/codersdojo_client/blob/5d8148ad60fc0d2ad45879b9d30abd8deb979e8f/spec/unit/run/scheduler_interrupt_listener_spec.rb)

## Suggestion #1

1. Create a branch.
   e.g. `git checkout -b holiday1`.
2. Refactor, committing every time your tests pass.
   Describe the step that you took.
3. Go back to master.
4. Create a new branch.
   e.g. `git checkout -b holiday2`.
5. Refactor again.
6. Rinse.
7. Repeat.
8. Repeat a lot.

Each time you refactor, think about the steps that you take.

Can you take smaller steps?
Can you make changes in a different order?
Can you go through the refactoring without ever getting failing tests?
Is a different approach more satisfying?

