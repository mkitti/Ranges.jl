# Length and Step concept from Andrés Riedemann and Mason Protter

export Length, Step

struct Length{length,T <: Union{Nothing,Integer} }
    Length(value::T) where T = new{value,T}()
end
value(::Length{value}) = value

struct Step{step,T}
    Step(value::T) where T = new{value,T}()
end
value(::Step{value}) = value

import Base: (:)

(:)(start, stop, ::Length{length}) where length = Base._range(start, nothing, stop, length)
(:)(start::T, ::Length{length}, stop::T) where T<:Real where length = Base._range(start, nothing, stop, length)
(:)(::Length{length}, start, stop) where length = Base._range(start, nothing, stop, length)

(:)(start, stop, ::Step{step}) where step = start:step:stop
(:)(start::T, ::Step{step}, stop::T) where T<:Real where step = start:step:stop
(:)(::Step{step}, start, stop) where step = start:step:stop

(:)(start, stop, ::Step{1}) = start:stop
(:)(start::T, ::Step{1}, stop::T) where T<:Real = start:stop
(:)(::Step{1}, start, stop) = start:stop

Base.range(start, stop, ::Length{length}) where length = Base._range(start, nothing, stop, length)
Base.range(start, stop, ::Step{step}) where step = Base._range(start, step, stop, nothing)
Base.range(start, stop, ::Step{1}) where step = Base._range(start, nothing, stop, nothing)

Base.range(::Length{length}, start, stop) where length = Base._range(start, nothing, stop, length)
Base.range(start, ::Step{1}, stop) where step = Base._range(start, nothing, stop, nothing)

# Use step and length methods to produce a new range with modifications

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

"""
    first(r::AbstractRange, f)

Modify range with a new `start` element. Does not modify `end` or `step`.
"""
Base.first(r::AbstractRange, f) = Base.range(f, last(r), step=step(r))

"""
    last(r::AbstractRange, l)

Modify range with a new last element. Does not change `start` or `step`.
"""
Base.last(r::AbstractRange, l) = Base.range(first(r), l, step=step(r))