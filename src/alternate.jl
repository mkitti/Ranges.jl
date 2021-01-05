"""
Alternate positional forms


"""
module Alternate

# For reference only in deference to the form below with keyword step
@static if false
"""
    range( length, start = 1, stop = length; step = nothing )

Alternate one, two, and three argument range argument `range`. Compact.
"""
Base.range(length, start = 1, stop = nothing) =
    start === 1 && stop === nothing ?
        Base.OneTo(length) :
        Base.range(start, stop; length)
"""
```julia
julia> Base.range(5)
Base.OneTo(5)

julia> Base.range(5, 2)
2:6

julia> Base.range(5, 2, 11)
2.0:2.25:11.0
```
"""


"""
    range( length, start = 1, stop = length; step = nothing )

Alternate one, two, and three argument range argument `range` 
"""
function Base.range(length, start = 1, stop = nothing; step = nothing)
    if step === nothing
        if start === 1 && stop === length 
            Base.OneTo(length)
        else
            Base._range(start, step, stop, length)
        end
    elseif stop === nothing
        Base._range(start, step, stop, length)
    else
        throw(ArgumentError("Cannot specify all of length = $length, start = $start, stop = $stop, and step = $step"))
    end
end
"""
```julia
julia> Base.range(5)
Base.OneTo(5)

julia> Base.range(5, 2)
2:6

julia> Base.range(5, 2, 11)
2.0:2.25:11.0
```
"""
end

end