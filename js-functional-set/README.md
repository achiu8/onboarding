# Functional Sets

In this challenge you'll produce a Set. We're defining the `Set` as "a function that accepts a number and returns a boolean." Or, in a fancier looking notation:

```
type Set = Function(Integer) => Boolean
```

## Constraints

Your Sets will only contain integers.

## Composability

As you produce functions, consider if they can be combined to implement others. In other words, can you implement some function _in terms of_ another? Look for and take advantage of these opportunities when appropriate.

## Tests

You'll need to write tests for each method you implement. You can run your tests with `node sets_test.js`.

## Release 1, Basic Operations

Define and test the following methods stubbed out in `sets.js`:

 * singletonSet
 * union
 * intersect
 * diff
 * filter

## Release 2, Operating on Collections

You have the basic set operations, now we want operations that can operate on the elements in the sets.

 * forall
 * exists
 * map
 * toString

## Release 3, Bounded

You'll notice these methods only operate on bounded integers. Why is this necessary? Describe your thoughts in `note.md`.
