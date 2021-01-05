
"""
    range(start => stop)

Create a [`PartialRange`] method with a `start` and `stop` but unspecified
`step` or `length`. The `PartialRange` is callable where `length` can be
specified as the sole argument or `step` can be specified as a keyword argument.
"""
function Base.range(r::Pair; kwargs...)
    r = PartialRange(r.first, r.second)
    if !isempty(kwargs)
        return r(;kwargs...)
    end
    r
end

"""
    range(start => stop, length)

Create a range from `start` to `stop` (inclusive) with the specified length.

Equivalent to range(start, stop; length)
"""
Base.range(r::Pair, length) = Base.range(r.first, r.second; length)

"""
    range(length, start => stop)

Create a range from `start` to `stop` (inclusive) with the specified length.

Equivalent to range(start, stop; length)
"""
Base.range(length, r::Pair) = Base.range(r.first, r.second; length)