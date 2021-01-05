"""
    PartialRange(start, stop)
"""
struct PartialRange
    start::Number
    stop::Number
end

(r::PartialRange)(length) = Base.range(r.start, r.stop; length)
(r::PartialRange)(; length=nothing, step=nothing) = Base.range(r.start, r.stop; length, step)

Base.step(r::PartialRange, s) = Base.range(r.start, r.stop; step=s)
Base.length(r::PartialRange, l) = Base.range(r.start, r.stop; length=l)

