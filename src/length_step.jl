"""
    length(r::AbstractRange, len)

Create a range with the same `start` and `stop` but with the specified length, `len`
"""
Base.length(r::AbstractRange, len) = Base.range(first(r), last(r), length=len)
"""
    length(start => stop, len)

Create a range from start to stop and the specified length
"""
Base.length(r::Pair, len) = Base.range(first(r), last(r), length=len)

"""
    length(start, stop, length)

Create a range from start to stop (inclusive) with the specified length
"""
Base.length(start, stop, length) = Base.range(start, stop; length = length)

"""
    step(r::AbstractRange, step)

Return a range with the same `start` and `stop` but with the specified step
"""
Base.step(r::AbstractRange, s) = Base.range(first(r), last(r), step=s)

"""
    step(r::Pair, s)

Return a range with the `start` and `stop` but with the specified step
"""
Base.step(r::Pair, s) = Base.range(first(r), last(r), step=s)
Base.step(start, stop, step) = Base.range(start, stop; step=step)

Base.first(r::AbstractRange, f) = Base.range(f, last(r), step=step(r))
Base.last(r::AbstractRange, l) = Base.range(first(r), l, step=step(r))