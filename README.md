# Ranges

This package provides additional ways to create a range in Julia. This package has no dependencies other than the Julia standard library.

A range is sequence of numbers or other items that have a `start` and a `stop`. Here we focus on arithmetic linear ranges which are actually
arithmetic sequences starting at `start`, incremented by a `step` and ending at or before `stop`.

Ranges in Julia often start at `1` by default due to the one-based nature of the language. They are often inclusive of their endpoint at `stop`
if reachable by incrementing by `step`. In particular, this differs from a language such as Python where ranges start at `0` and tend not to
include the upper bound.

The additional forms added here use the following principles:
1. Provide complementary syntax to `start:stop` and `start:step:stop`. That is if you can do it well with the colon syntax, a redundant
`range` method is not added here. Rather `range` allows you to construct a sequence not easily done with colon.
2. Allow for maximum user friendliness.

Because of item 1 above, the emphasis here is on providing additional syntax for `length` since `step` is well covered by the colon syntax.

## Positional syntax

This package adds several positional forms of `range`:
```julia
range(length) # 1:length
range(start, length) # start:start+length
range(start, stop, length) # range(start, stop; length)
range(start, step, stop, length) # Base._range, one arg must be nothing
```

In the positional syntax, `length` is always the last argument.

The single argument form mimicks the Python version, except that it starts from `1` and ends with the `length` argument given.

The two argument form allow for `start` and `length` to be provided. The reason `range(start,stop)` is not implemented is that this
is easily handled by the colon syntax in base Julia: `start:stop`.

The three argument form allows for `start`, `stop`, and `length` to be specified as positional arguments.

The four argument form allows for `start`, `step`, `stop`, and `length` to be specified as positional arguments. One of the arguments must be `nothing`.

`step` is not used here because it can be specified by `start:step:stop` in base Julia.

Usage:
```julia
julia> using Ranges

julia> range(5)
Base.OneTo(5)

julia> range(2, 5)
2:6

julia> range(1, 10, 3)
1.0:4.5:10.0

julia> range(1, nothing, 10, 4)
1.0:3.0:10.0
```

## range Pair Syntax: range(start => stop, length) and variations.

Because the order of arguments may not be intuitive, `start` and `stop` may be provided as `start => stop` which is a `Pair`.

This allows `length` to be provided as either the first or last argument.

```julia
range(start => stop, length) # Same as range(start, stop; length)
range(length, start => stop) # Same as range(start, stop; length)
range(start => stop) # Produces a curried function
```

The last form returns another function that remembers the `start` and `stop` given in the `Pair`.
It takes a single positional argument of `length`. It can also optionally take a single keyword argument
of either `step` or `length`.

Usage:
```julia
julia> using Ranges

julia> range(1 => 5, 2)
1.0:4.0:5.0

julia> range(2, 1 => 5)
1.0:4.0:5.0

julia> range(3, 1 => 5)
1.0:2.0:5.0

julia> r = range(1 => 5)
Ranges.PartialRange(1, 5)

julia> r(3)
1.0:2.0:5.0

julia> r(step = 2)
1:2:5

julia> r(length = 3)
1.0:2.0:5.0
```

## range(; start, stop, step, length)

If you would like to be clear about all parameters given for a range, all four prameters can be specified as keywords.

```julia
julia> using Ranges

julia> range(;length = 3, start = 1)
1:3

julia> range(;length = 3, start = 1, stop = 5)
1.0:2.0:5.0

julia> range(; start=3, step = 2, length=100)
3:2:201
```

## range with abbreviations

If you liked the flexiblity of the keyword form, but also found it more verbose, this package also provides a single letter abbreviation form
via the *BELS* system. *BELS* stands for `[b]egin`, `[e]nd`, `[l]ength`, and `[s]tep`, drawing inspiration from existing Julia concepts.

| Current | New | Example | New Abbreviation | 
| --- | --- | --- | --- |
| start | begin | a[begin] | b |
| stop | end | a[end] | e |
| length | length | length(a) | l |
| step | step | step(a) | s |

Each of these forms involve providing a `Symbol` as the first argument. If that symbol is `:bels`, then `b`, `e`, `l`, and `s` may be provided as keywords.

If the symbol uses less than four letters, then the symbol denotes the order of positional arguments. For example, `:bel` indicates that the order of arguments
will be `[b]egin`, `[e]nd`, and `[l]ength`. If the symbol was `:bes`, then the order of arguments will be `[b]egin`, `[e]nd`, and `[s]tep`.

Effort is made to produce a range given any combination of arguments.

```julia
range(:bels; b, e, l, s)
range(:[bels], args...)
```

Usage:
```julia
julia> using Ranges

julia> range(:bels, b=5, e=10, l=3)
5.0:2.5:10.0

julia> range(:bels, e=10, l=3, s=2)
6:2:10

julia> range(:be, 1, 10)
1:10

julia> range(:be, 2, 10)
2:10

julia> range(:bl, 2, 10)
2:11
```

### Change range length

```julia
length(r::AbstractRange, len)
length(r::Pair, len)
```

Usage:
```julia
julia> length(1:5, 11)
1.0:0.4:5.0

julia> length(1:5, 21)
1.0:0.2:5.0

julia> length(3.5 => 22.2, 11)
3.5:1.87:22.2
```

### Change range step

```julia
step(r::AbstractRange, s)
step(r::Pair, s)
```

Usage:
```julia
julia> step(1:5, 2)
1:2:5

julia> step(1:10, 2)
1:2:9

julia> step(1 => 5.5, 3)
1.0:3.0:4.0
```

### Change first element

```julia
first(r::AbstractRange, f)
```

Usage:
```julia
julia> first(1:5, 3)
3:1:5
```

### Change last element
```julia
last(r::AbstractRange, l)
```

Usage:
```julia
julia> last(1:5, 3)
1:1:3
```
# Creating a range in Base Julia, a Review

Let's review the distinct ways to create a range in base Julia. In general, ranges in Base
are iterators and use Julia's iteration protocol. To obtain the actually sequence a method such as `collect` can be used to obtain all the elements
of the iterator in order.

### Colon Syntax

The colon syntax allows ranges to be created using `start`, `stop`, and optionally `step`.

The simplest colon syntax is `start:stop` where `step` defaults to `1`. In this case `start` and `stop` are included in the iteration.
This produces a Julia struct of type `UnitRange`.

```julia
julia> 1:5
1:5

julia> print( collect( 1:5 ) )
[1, 2, 3, 4, 5]

julia> typeof(1:5)
UnitRange{Int64}
```

A second colon syntax allows you to specify `step`: `start:step:stop`. If `stop` cannot be reached by incrementing by `step` from `start`,
`stop` may not be included in the iteration. This produces a Julia struct of type `StepRange`.

```julia
julia> 1:2:10
1:2:9

julia> print( collect( 1:2:10 ) )
[1, 3, 5, 7, 9]

julia> typeof(1:2:10)
StepRange{Int64,Int64}
```

### range(start; stop, step, length) Syntax

The method `range` comes in several forms. The first form takes a single positional argument, `start`, and accepts
`stop`, `step`, and/or `length` as keyword arguments. This can produce either a `UnitRange`, `StepRange`, or `StepRangeLen`.

If neither `step` or `length` is specified, `step` defaults to `1`.

A combination of only `start` and `step` will produce an `ArgumentError`. Specifying all three keywords will also
produce an `ArgumentError`.

```julia
julia> range(1; stop = 5)
1:5

julia> typeof( range(1; stop = 5) )
UnitRange{Int64}

julia> range(1; stop = 5, length = 3)
1.0:2.0:5.0

julia> typeof( range(1; stop = 5, length = 3) )
StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}

julia> range(1; length = 3, step = 2)
1:2:5

julia> typeof( range(1; length = 3, step = 2) )
StepRange{Int64,Int64}

julia> range(2; length=3)
2:4

julia> range(2; step=3)
ERROR: ArgumentError: At least one of `length` or `stop` must be specified

julia> range(1; stop=5, length = 2, step = 4)
ERROR: ArgumentError: Too many arguments specified; try passing only one of `stop` or `length`
```

### range(start, stop; step, length)

A second form of range allows for two positional arguments, `start` and `stop`. At least one
additional keyword, `step` or `length` must be provided.

It is not valid to provide two positional arguments only. It is also not valid to provide
both keyword arguments in this form. These will throw an `ArgumentError`.

```julia
julia> range(1, 5, step = 2)
1:2:5

julia> range(1, 5, length = 2)
1.0:4.0:5.0

julia> range(1, 5)
ERROR: ArgumentError: At least one of `length` or `step` must be specified
...

julia> range(1, 5, length = 2, step = 4)
ERROR: ArgumentError: Too many arguments specified; try passing only one of `stop` or `length`
```

## Other Ranges.jl

This package is unrelated to https://github.com/JuliaArrays/Ranges.jl which is obsolete.