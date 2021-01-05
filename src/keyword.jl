"""
    range(; start, stop, length, step)

All keyword form of Base.range
"""
Base.range(;start=1, stop=nothing, length=nothing, step=nothing) =
    Base._range(start, step, stop, length)

Base._range(::Nothing, step, stop, length) = Base.range(stop - (length-1)*step; length=length, step=step)

"""
    range(:bels; b, e, l, s)
    range(:[bels]*, args...)

Specify range properties using the following single letter abbreviations
[b]egin: start
[e]nd: stop
[l]ength: length
[s]step: step

If :bels is the first argument, use the abbreviations as keywords.
For symbols using some permutation of b, e, l, or s of one, two, or Three
members, specify the arguments in the order of the symbols used.

Defaults:
[b]egin: 1 or [`oneunit`](@ref) of given parameter
[e]nd: typemax or floatmax of b
[s]tep: 1
"""
Base.range(s::Symbol, args... ; kwargs...) = range(Val(s), args... ; kwargs...)

Base.range(::Val{:bels}; b=nothing, e=nothing, l=nothing, s=nothing) =
    Base._range(b, s, e, l)

# Single argument

Base.range(::Val{:b}, b) = b:typemax(b)
Base.range(::Val{:e}, e) = Base.OneTo(e)
Base.range(::Val{:l}, l) = Base.OneTo(l)
Base.range(::Val{:s}, s) = oneunit(s):s:typemax(s)

Base.range(::Val{:b}, b::AbstractFloat) = b:typemax(Int(b))
Base.range(::Val{:s}, s::AbstractFloat) = oneunit(s):s:typemax(Int(s))

# Two argument, bels order

Base.range(::Val{:be}, b, e) = b:e
Base.range(::Val{:bl}, b, l) = range(b; length=l)
Base.range(::Val{:bs}, b, s) = b:s:typemax(s)

Base.range(::Val{:el}, e, l) = range(e-l+1, e; length=l)
Base.range(::Val{:es}, e, s) = oneunit(e):s:e

Base.range(::Val{:ls}, l, s) = range(1; step=s, length=l)

Base.range(::Val{:bs}, b, s::AbstractFloat) = b:s:floatmax(s)

# Three argument, bels order (+4)

Base.range(::Val{:bel}, b, e, l) = Base.range(b, e; length=l)
Base.range(::Val{:bes}, b, e, s) = Base.range(b, e; step=s)
Base.range(::Val{:bls}, b, l, s) = Base.range(b; length=l, step=s)
Base.range(::Val{:els}, e, l, s) = Base.range(e - (l-1)*s; length=l, step=s)

# Two argument, reversed order

Base.range(::Val{:eb}, e, b) = b:e
Base.range(::Val{:lb}, l, b) = range(b; length=l)
Base.range(::Val{:sb}, s, b) = b:s:typemax(s)

Base.range(::Val{:le}, l, e) = Base.range(e-l+1, e; length=l)
Base.range(::Val{:se}, s, e) = oneunit(e):s:e

Base.range(::Val{:sl}, s, l) = Base.range(1; step=s, length=l)

# Three argument, swap last two (+4)

Base.range(::Val{:ble}, b, l, e) = Base.range(b, e; length=l)
Base.range(::Val{:bse}, b, s, e) = Base.range(b, e; step=s)
Base.range(::Val{:bsl}, b, s, l) = Base.range(b; length=l, step=s)
Base.range(::Val{:esl}, e, s, l) = Base.range(e - (l-1)*s; length=l, step=s)

# Three argument, end first, ebls (+4)

Base.range(::Val{:ebl}, e, b, l) = Base.range(b, e; length=l)
Base.range(::Val{:ebs}, e, b, s) = Base.range(b, e; step=s)
#Base.range(::Val{:bls}, b, l, s) = Base.range(b; length=l, step=s)
#Base.range(::Val{:els}, e, l, s) = Base.range(e - (l-1)*s; length=l, step=s)

Base.range(::Val{:elb}, e, l, b) = Base.range(b, e; length=l)
Base.range(::Val{:esb}, e, s, b) = Base.range(b, e; step=s)
#Base.range(::Val{:bsl}, b, s, l) = Base.range(b; length=l, step=s)
#Base.range(::Val{:esl}, e, s, l) = Base.range(e - (l-1)*s; length=l, step=s)

# Three argument, length first (+6)

Base.range(::Val{:lbe}, l, b, e) = Base.range(b, e; length=l)
#Base.range(::Val{:bes}, b, e, s) = Base.range(b, e; step=s)
Base.range(::Val{:lbs}, l, b, s) = Base.range(b; length=l, step=s)
Base.range(::Val{:les}, l, e, s) = Base.range(e - (l-1)*s; length=l, step=s)

Base.range(::Val{:leb}, l, e, b) = Base.range(b, e; length=l)
#Base.range(::Val{:bes}, b, s, e) = Base.range(b, e; step=s)
Base.range(::Val{:lsb}, l, s, b) = Base.range(b; length=l, step=s)
Base.range(::Val{:lse}, l, s, e) = Base.range(e - (l-1)*s; length=l, step=s)

# Three argument, step first (+6)

#Base.range(::Val{:bel}, b, e, l) = Base.range(b, e; length=l)
Base.range(::Val{:sbe}, s, b, e) = Base.range(b, e; step=s)
Base.range(::Val{:sbl}, s, b, l) = Base.range(b; length=l, step=s)
Base.range(::Val{:sel}, s, e, l) = Base.range(e - (l-1)*s; length=l, step=s)

#Base.range(::Val{:bel}, b, l, e) = Base.range(b, e; length=l)
Base.range(::Val{:seb}, s, e, b) = Base.range(b, e; step=s)
Base.range(::Val{:slb}, s, l, b) = Base.range(b; length=l, step=s)
Base.range(::Val{:sle}, s, l, e) = Base.range(e - (l-1)*s; length=l, step=s)