# Guidelines for contribution

This document described guidelines for contributions for projects led by members
of the [Poisot lab of computational ecology][pl], Université de Montréal. It
should be followed by lab members (at all times), as well as people with
suggested added features, or willing to contribute enhancement or bug fixes.

## Authorship

Any contribution to the code of a software grants authorship on the next paper
describing this software. Any contribution to a paper hosted as a public
version-controlled repository grants authorship of the paper. For this reason,
it is important to correctly identify yourself. For `R` packages, this is done
throug the `DESCRIPTION` file. Whenever a `CONTRIBUTORS` file is found, add your
name to it as part of the workflow described next. For authorship of papers, the
first and last authors will decide on the position.

## Workflow

This section describes the general steps to make sure that your contribution is
integrated rapidly. The general workflow is as follows:

1. Fork the repository
2. Create an *explicitely named branch*
3. Create a pull request *even if you haven't pushed code yet*
4. Be as explicit as possible on your goals

Creating a pull request *before* you push any code will signal that you are
interested in contributing to the project. Once this is done, push often, and be
explicit about what the commits do. This gives the opportunity for feedback
during your work, and allow for tweaks in what you are doing.

## Tests and coverage

Most of our repositories undergo continuous integration, and code coverage analysis.

It is expected that:

1. Your commits will not break a passing repo
2. Your commits *can* make a breaking repo pass (thank you so much!)
3. Your additions or changes will be adequately tested

This information will be given in the thread of your pull request. Most of our
repositories are set-up in a way that new commits that decrease coverage by more
than 10% won't be pulled.

## Coding practices

### Use functions

Don't repeat yourself. If you have to do something more than once, write a
function for it.

### Program defensively

Check user input, check data structure, and fail often but explicitely.

### Use type-static functions

Any given function must *always* return an object of the same type.

A function like `y = (x) -> x>3?true:x` (returns `true` if `x` is larger than 3,
else returns `x`) is not acceptable, as it is hard to predict, hard to debug,
and hard to use.

### Comment

Comment your code -- comments should not explain what the code *does* (this is
for the documentation), but how it does it.

### Variables names

Be as explicit as possible. Have a look at the rest of the codebase before your
start.

### Docstrings and documentation

Write som. `R` packages, must be compiled with `roxygen`, `python` code must
have docstrings for all documentable objects, and `Julia` functions must be
commented.

If there is a documentation, add the parts relevant for your changes.

### Versionning

We use [semantic versioning][sv] (`major`.`minor`.`patch`). Anything that adds
no new feature should increase the `patch` number, new non-API-breaking changes
should increase `minor`, and major changes should increase `major`. Any increase
of a higher level resets the number after it (*e.g*, `0.3.1` becomes `1.0.0` for
the first major release).

[pl]: http://poisotlab.io/
[sv]: http://semver.org/
