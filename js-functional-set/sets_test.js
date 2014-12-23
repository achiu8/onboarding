var Sets = require('./sets.js');

test("Singleton does not contain element", function () {
  var s1 = Sets.singletonSet(1);
  return !s1(4)
});

test("Singleton contains element", function () {
  var s1 = Sets.singletonSet(1);
  return s1(1)
});

// Union
test("One of the sets contain the element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([2, 4, 6, 8, 10]);
  return Sets.union(s1, s2)(1)
});

test("Neither set contains the element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([2, 6, 8, 10]);
  return !Sets.union(s1, s2)(4)
});

test("Both sets contains the element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([1, 4, 6, 8, 10]);
  return Sets.union(s1, s2)(1)
});

//Intersect
test("One of the sets contains the element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([2, 4, 6, 8, 10]);
  return !Sets.intersect(s1, s2)(1)
});

test("Neither set contains the element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([1, 4, 6, 8, 10]);
  return !Sets.intersect(s1, s2)(2)
});

test("Both sets contains the element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([1, 4, 6, 8, 10]);
  return Sets.intersect(s1, s2)(1)
});

//Diff
test("Set 1 has one element that Set 2 does not", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([1, 3, 5, 7, 10]);
  return Sets.diff(s1, s2)(9)
});

test("Set 1 has one element that Set 2 does not", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([1, 3, 5, 7, 10]);
  return !Sets.diff(s1, s2)(10)
});

test("Set 1 and Set 2 have the same elements", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var s2 = Sets.set([1, 3, 5, 7, 9]);
  return !Sets.diff(s1, s2)(1)
});

test("Set 1 has no elements", function () {
  var s1 = Sets.set([]);
  var s2 = Sets.set([1, 3, 5, 7, 9]);
  return !Sets.intersect(s1, s2)(1)
});

//Filter
test("The function holds for all of Set 1; element in Set 1", function () {
  var s1 = Sets.set([1, 2, 3, 4]);
  var lessThanFive = function(n) { return n < 5; };
  return Sets.filter(s1, lessThanFive)(1)
});

test("The function holds for all of Set 1; element not in Set 1", function () {
  var s1 = Sets.set([1, 3, 4]);
  var lessThanFive = function(n) { return n < 5; };
  return !Sets.filter(s1, lessThanFive)(2)
});

test("The function holds for some of Set 1; element in Set 1", function () {
  var s1 = Sets.set([1, 3, 4, 5, 6]);
  var lessThanFive = function(n) { return n < 5; };
  return !Sets.filter(s1, lessThanFive)(5)
});

test("The function holds for some of Set 1; element not in Set 1", function () {
  var s1 = Sets.set([1, 3, 4, 5, 6]);
  var lessThanFive = function(n) { return n < 5; };
  return !Sets.filter(s1, lessThanFive)(2)
});

test("The function holds for none of Set 1; function holds for element", function () {
  var s1 = Sets.set([5, 6, 7, 8, 9]);
  var lessThanFive = function(n) { return n < 5; };
  return !Sets.filter(s1, lessThanFive)(2)
});

//Forall
test("All of Set 1 satisfies the condition", function () {
  var s1 = Sets.set([2, 4, 6, 8, 10]);
  var isEven = function(n) { return n % 2 == 0; };
  return Sets.forall(s1, isEven)
});

test("Some of Set 1 satisfies the condition", function () {
  var s1 = Sets.set([2, 3, 6, 8, 10]);
  var isEven = function(n) { return n % 2 == 0; };
  return !Sets.forall(s1, isEven)
});

test("None of Set 1 satisfies the condition", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var isEven = function(n) { return n % 2 == 0; };
  return !Sets.forall(s1, isEven)
});

test("Element of Set 1 outside of bounds does not satisfy condition", function () {
  var s1 = Sets.set([2, 4, 6, 8, 1001]);
  var isEven = function(n) { return n % 2 == 0; };
  return Sets.forall(s1, isEven)
});

//Exists
test("All elements in Set 1 satisfies the condition", function () {
  var s1 = Sets.set([2, 4, 6, 8, 10]);
  var isEven = function(n) { return n % 2 == 0; };
  return Sets.exists(s1, isEven)
});

test("One element in Set 1 satisfies the condition", function () {
  var s1 = Sets.set([1, 3, 6, 7, 9]);
  var isEven = function(n) { return n % 2 == 0; };
  return Sets.exists(s1, isEven)
});

test("No element in Set 1 satisfies the condition", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var isEven = function(n) { return n % 2 == 0; };
  return !Sets.exists(s1, isEven)
});

test("Element of Set 1 outside of bounds satisfies the condition", function () {
  var s1 = Sets.set([1, 3, 5, 7, 1002]);
  var isEven = function(n) { return n % 2 == 0; };
  return !Sets.exists(s1, isEven)
});

//Map
test("Modified Set 1 contains element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var doubleNum = function(n) { return n * 2; };
  return Sets.map(s1, doubleNum)(2)
});

test("Modified Set 1 contains element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var squareNum = function(n) { return n * n; };
  return Sets.map(s1, squareNum)(9)
});

test("Modified Set 1 does not contain element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var doubleNum = function(n) { return n * 2; };
  return !Sets.map(s1, doubleNum)(3)
});

test("Modified Set 1 does not contain element", function () {
  var s1 = Sets.set([1, 3, 5, 7, 9]);
  var squareNum = function(n) { return n * n; };
  return !Sets.map(s1, squareNum)(5)
});


console.log("All tests passed")


/* test(String name, Function fnc)
 *  - name: the name of the test
 *  - fnc: a function that returns true if the test passes, otherwise false
 * `test` will throw an exception if fnc() returns false
 */
function test(name, fnc) {
  console.log("====================================================")
  console.log('Test: "%s"', name);
  console.log("====================================================")
  try {
    console.assert(fnc(), name);
  } catch (e) {
    console.log("Test Failed\n");
    throw e;
  }
  console.log("Test Passed\n");
}
