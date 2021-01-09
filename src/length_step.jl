# Length and Step concept from Andrés Riedemann and Mason Protter

export Length, Step

struct Length{T <: Union{Nothing,Integer} }
    length::T
end
Length(value::T) where T = Length{T}(value)
value(length::Length{T}) where T = length.length
Base.length(length::Length{T}) where T = length.length

struct Step{T}
    step::T
    Step(value::T) where T = isone(value) ? new{Nothing}(nothing) : Step{T}(value)
    Step{T}(value::T) where T = new{T}(value)
end
value(step::Step{T}) where T = step.step
Base.step(step::Step{T}) where T = step.step

AnyNothing = (Any, Nothing)

for (A,B,C) in Iterators.product( AnyNothing, AnyNothing, AnyNothing )
    Base._range(start::A, step::Step, stop::B, length::C) = Base._range(start, step.step, stop, length)
    if A != Nothing && C != Nothing
        Base._range(start::A, step::B, stop::C, length::Length) = Base._range(start, step, stop, length.length == stop - start + 1 ? nothing : length.length)
    else
        Base._range(start::A, step::B, stop::C, length::Length) = Base._range(start, step, stop, length.length)
    end
end

for (A,B) in Iterators.product( AnyNothing, AnyNothing )
    if A != Nothing && B != Nothing
        Base._range(start::A, step::Step, stop::B, length::Length) = Base._range(start, step.step, stop, length.length == stop - start + 1 ? nothing : length.length)
    else
        Base._range(start::A, step::Step, stop::B, length::Length) = Base._range(start, step.step, stop, length.length)
    end
end

(::Base.Colon)(start, stop, length::Length) = Base._range(start, nothing, stop, length)
(::Base.Colon)(start::T, length::Length, stop::T) where T<:Real = Base._range(start, nothing, stop, length)
(::Base.Colon)(length::Length, start, stop) = Base._range(start, nothing, stop, length)

(::Base.Colon)(start, stop, ::Length{Nothing}) = Base._range(start, nothing, stop, nothing)
(::Base.Colon)(start::T, ::Length{Nothing}, stop::T) where T<:Real = Base._range(start, nothing, stop, nothing)
(::Base.Colon)(::Length{Nothing}, start, stop) = Base._range(start, nothing, stop, nothing)

(::Base.Colon)(start, stop, step::Step) = start:step.step:stop
(::Base.Colon)(start::T, step::Step, stop::T) where T<:Real = start:step.step:stop
(::Base.Colon)(step::Step, start, stop) = start:step.step:stop

(::Base.Colon)(start, stop, ::Step{Nothing}) = start:stop
(::Base.Colon)(start::T, ::Step{Nothing}, stop::T) where T<:Real = start:stop
(::Base.Colon)(::Step{Nothing}, start, stop) = start:stop

Base.range(start, stop, length::Length) = Base._range(start, nothing, stop, length)
Base.range(start, length::Length, stop) = Base._range(start, nothing, stop, length)
Base.range(length::Length, start, stop) = Base._range(start, nothing, stop, length)

Base.range(start, stop, ::Length{Nothing}) = Base._range(start, nothing, stop, nothing)
Base.range(start, ::Length{Nothing}, stop) = Base._range(start, nothing, stop, nothing)
Base.range(::Length{Nothing}, start, stop) = Base._range(start, nothing, stop, nothing)

Base.range(start, stop, step::Step) = Base._range(start, step, stop, nothing)
Base.range(start, step::Step, stop) = Base._range(start, step, stop, nothing)
Base.range(step::Step, start, stop) = Base._range(start, step, stop, nothing)
Base.range(start::Number, step::Step, stop::T) where {T <:Integer} = Base._range(start, step, stop, nothing)

Base.range(start, stop; length::Length) = Base._range(start, nothing, stop, length)

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