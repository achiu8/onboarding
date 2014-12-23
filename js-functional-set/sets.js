/**
 * A Set is defined as a function (not a class) that accepts an integer N, and returns a boolean indicating whether N is in the Set
 *
 * Definition: type Set = Function(Integer) => Boolean
 * e.x. mySet(element) => true // Element is in the set
 */

/**
 * Returns the set of the one given element.
 *
 * Definition: Function(Integer) => Set
 */
function singletonSet(element) {
  return function(el) {
    return element == el;
  }
} //=> Set

function set(elements) {
  return function(el) {
    return elements.indexOf(el) > -1;
  }
}

/**
 * Returns the union of the two given sets,
 * the sets of all elements that are in either `set1` or `set2`.
 *
 * Definition: Function(Set, Set) => Set
 */
function union(set1, set2) {
  return function(el) {
    return set1(el) || set2(el);
  }
} //=> Set

/**
 * Returns the intersection of the two given sets,
 * the set of all elements that are both in `set1` and `set2`.
 *
 * Definition: Function(Set, Set) => Set
 */
function intersect(set1, set2) {
  return function(el) {
    return set1(el) && set2(el);
  }
} //=> Set

/**
 * Returns the difference of the two given sets,
 * the set of all elements of `set1` that are not in `set2`.
 *
 * Definition: Function(Set, Set) => Set
 */
function diff(set1, set2) {
  return function(el) {
    return set1(el) && !set2(el);
  }
} //=> Set

/**
 * Returns the subset of `set1` for which `predicateFnc` holds.
 *
 * Definition: Function(Set, Function(Integer) => Boolean) => Set
 */
function filter(set1, predicateFnc) {
  return function(el) {
    return intersect(set1, predicateFnc)(el);
  }
} //=> Set

/**
 * The bounds for `forall` and `exists` are +/- 1000.
 */
var BOUND = 1000;

/**
 * Returns whether all bounded integers within `s` satisfy `predicateFnc`.
 *
 * Definition: Function(Set, Function(Integer) => Boolean ) => Boolean
 */
function forall(s, predicateFnc) {
  function iter(a) {
    if (a > BOUND) { return true; }
    else if (diff(s, predicateFnc)(a)) { return false; }
    else { return iter(a + 1); }
  }
  return iter(-BOUND);
} //=> Boolean

/**
 * Returns whether there exists a bounded integer within `s`
 * that satisfies `predicateFnc`.
 *
 * Definition: Function(Set, Function(Integer) => Boolean ) => Boolean
 */
function exists(s, predicateFnc) {
  var inverseFnc = function(el) { return !predicateFnc(el); };
  return !forall(s, inverseFnc);
} //=> Boolean

/**
 * Returns a set transformed by applying `f` to each element of `s`.
*
 * Definition: Function(Set, Function(Integer) => Integer ) => Set
 */
function map(s, fnc) {
  return function(el) {
    var reverseFnc = function(n) { return fnc(n) == el; };
    return exists(s, reverseFnc);
  }
} //=> Set

/**
 * Displays the contents of a set
 *
 * Definition: Function(Set) => String
 */
function toString(s) {
  var elements = [];
  for(var i = -BOUND; i <= BOUND; i++) {
    if(s(i)) {
      elements.push(i);
    }
  }
  return "{ " + elements.join(", ") + " }";
}

/**
 * Prints the contents of a set on the console.
 */
function printSet(s) {
  console.log(toString(s));
}

/* Export */
module.exports = {
  singletonSet: singletonSet,
  set: set,
  union: union,
  intersect: intersect,
  diff: diff,
  filter: filter,
  forall: forall,
  exists: exists,
  map: map,
  toString: toString,
  printSet: printSet
}
