# Guidelines for contribution

This document described guidelines for contributions for projects led by members
of the [Poisot lab of computational ecology][pl], Université de Montréal. It
should be followed by lab members (at all times), as well as people with
suggested added features, or willing to contribute enhancement or bug fixes.

[pl]: http://poisotlab.io/

Edits to this document must be suggested as pull requests on the github project
located at `https://github.com/PoisotLab/PLCG`, and not made on the document
itself.

It is suggested to include this file to your projects via a `Makefile` rule:

``` makefile
CONTRIBUTING.md:
  wget -O $@ https://raw.githubusercontent.com/PoisotLab/PLCG/master/README.md
```

## Issues

Reporting issues is the simplest and most efficient way to contribute. A useful
issue includes:

1. The version of all relevant software
2. Your operating system
3. A minimal reproducible example (the shortest code we can copy/paste to reproduce the issue)

## Authorship

Any contribution to the code of a software grants authorship on the next paper
describing this software, and immediate authorship to the next release (which
will receive a DOI). Any contribution to a paper hosted as a public
version-controlled repository grants authorship of the paper. For this reason,
it is important to correctly identify yourself. For `R` packages, this is done
through the `DESCRIPTION` file. Whenever a `CONTRIBUTORS` file is found, add
your name to it as part of the workflow described next. For authorship of
papers, the first and last authors will decide on the position.s

## Workflow

This section describes the general steps to make sure that your contribution is
integrated rapidly. The general workflow is as follows:

1. Fork the repository (see *Branches, etc.* below)
2. Create an *explicitely named branch*
3. Create a pull request *even if you haven't pushed code yet*
4. Be as explicit as possible on your goals

### Pull requests

Creating a pull request *before* you push any code will signal that you are
interested in contributing to the project. Once this is done, push often, and be
explicit about what the commits do. This gives the opportunity for feedback
during your work, and allow for tweaks in what you are doing.

A *good* pull request (in addition to satisfying to all of the criteria below)
is:

1. Single purpose - it should do one thing, and one thing only
2. Short - it should ideally involve less than 250 lines of code
3. Limited in scope - it should ideally not span more than a handful of files

This will ensure that your contribution is rapidly reviewed and evaluated.

### Branches, etc.

The `master` branch is *always* the currently stable, build passing, adequately
covered version. Ideally, no one should ever push directly into master. The
reference branch for development is `dev`.

For the development of new features, it is generally recommended to fork the
`master` branch, and submit your pull request to the `dev` branch. For
"hotfixes" (changes that address issues), forking either branch is fine, and
we'll take care of pulling the changes into `dev` and/or `master` as needed.

## Tests and coverage

Most of our repositories undergo continuous integration, and code coverage
analysis.

It is expected that:

1. Your commits will not break a passing repo
2. Your commits *can* make a breaking repo pass (thank you so much!)
3. Your additions or changes will be adequately tested

This information will be given in the thread of your pull request. Most of our
repositories are set-up in a way that new commits that decrease coverage by more
than 10% won't be pulled.

Good tests make sure that:

1. The code works as it should
2. The code breaks as it should (see *Program defensively* below)
3. Functions play nicely together

Before merging the content of *any* pull request, the following tests are done:

1. The branch to be merged *from* passes the build
2. The future branch (*i.e.* with the changeset) passes the build
3. The code coverage does not decrease by more than (usually) 10%

## Coding practices

### Use functions

Don't repeat yourself. If you have to do something more than once, write a
function for it. Functions should be as short as possible, and should be single
purpose. Think of every piece of code you write as an element of a library.

### Program defensively

Check user input, check data structure, and fail often but explicitly.

Bad:
``` julia
function add(x, y)
  return x + y
end
```

Acceptable:
``` julia
function add(x, y)
  @assert typeof(x) == Int64
  @assert typeof(y) == Int64
  return x + y
end
```

Good:
``` julia
function add(x, y)
  if typeof(x) != Int64
    throw(TypeError("The first argument should be an Int64", "add", Int64, typeof(x)))
  end
  if typeof(y) != Int64
    throw(TypeError("The second argument should be an Int64", "add", Int64, typeof(y)))
  end
  return x + y
end
```

### Use type-static functions

Any given function must *always* return an object of the same type.

A function like `y = (x) -> x>3?true:x` (returns `true` if `x` is larger than 3,
else returns `x`) is not acceptable, as it is hard to predict, hard to debug,
and hard to use.

### Comment

Comment your code -- comments should not explain what the code *does* (this is
for the documentation), but how it does it.

### Variables names

Be as explicit as possible. Have a look at the rest of the codebase before you
start. Using `i`, `j`, `k` for loops is, as usual, fine.

### Docstrings and documentation

Write some. `R` packages, must be compiled with `roxygen`, `python` code must
have docstrings for all documentable objects, and `Julia` functions must be
documented using `Docile.jl` and `Lexicon.jl`.##

There are three levels of documentation: the API documentation (which will be
generated from the docstrings), the documentation for fellow developers (which
resides ideally entirely in the comments), and documentation for the end users.
Your pull request must include relevant changes and additions to the
documentation.

### Versioning

We use [semantic versioning][sv] (`major`.`minor`.`patch`). Anything that adds
no new feature should increase the `patch` number, new non-API-breaking changes
should increase `minor`, and major changes should increase `major`. Any increase
of a higher level resets the number after it (*e.g*, `0.3.1` becomes `1.0.0` for
the first major release). It is highly recommended that you do not start working
on API-breaking changes without having received a go from us first.

[sv]: http://semver.org/
