"""
    range(length)

A range of the specified `length` starting at one. Alias for `Base.OneTo(length)``.

Equivalent to range(1; length) in Base.
"""
Base.range(length::Integer) = Base.OneTo(length)

"""
    range(start, length)

A [`UnitRange`](@ref) of the specified `length` starting at `start`.

See also `start:stop` for a UnitRange with a specific `stop`.

Equivalent to range(start; length) in Base
"""
Base.range(start::Number, length::Integer) = Base.range(start; length)

"""
    range(start, stop, length)

A range from `start` to `stop` (inclusive) of the specified `length`.

Equivalent to range(start, stop; length) in Base
"""
Base.range(start::Number, stop, length::Integer) = Base.range(start, stop; length)

"""
    range(start, step, stop, length)

This form allows all four arguments to be provided positionally. One of them must be `nothing`.

Equivalent to Base._range
"""
Base.range(start, step, stop, length) = Base._range(start, step, stop, length)