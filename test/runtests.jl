using Ranges
using Test

@testset "positional range" begin
    for length in [2, 10, 100]
        @test range(length) == Base.OneTo(length)
        for start in [-1, 0, 1, 10]
            @test range(start, length) == start:start+length-1
            for stop in [-2, 0, 2, 100]
                @test range(start, stop, length) == Base.range(start, stop; length)
                for step in [-1, 1, 1]
                    @test_throws ArgumentError range(start, step, stop, length)
                    @test range(start, step, stop, nothing) == Base.range(start, stop; step)
                    @test range(start, step, nothing, length) == Base.range(start; step, length)
                    @test range(start, nothing, stop, length) == Base.range(start, stop; length)
                    @test (range(nothing, step, stop, length),) .|> (Base.step, last, Base.length) == (step, stop, length)
                end
            end
        end
    end
end

@testset "Pair range and PartialRange" begin
    for start in [-1, 0, 1, 10]
        for stop in [-2, 0, 2, 100]
            r = range(start => stop)
            @test isa(r,Ranges.PartialRange)
            for length in [2, 10, 100]
                @test range(start => stop, length) == Base.range(start, stop; length)
                @test range(length, start => stop) == Base.range(start, stop; length)
                @test r(length) == Base.range(start, stop; length)
                @test r(;length) == Base.range(start, stop; length)
            end
            for step in [-1, 1, 1]
                @test r(;step) == Base.range(start, stop; step)
            end
        end
    end
end

@testset "Keyword range" begin
    for length in [2, 10, 100]
        @test range(;length) == Base.OneTo(length)
        @test range(:bels;l=length, b=1) == Base.OneTo(length)
        for start in [-1, 0, 1, 10]
            @test range(;start, length) == start:start+length-1
            @test range(:bels;b=start, l=length) == start:start+length-1
            for stop in [-2, 0, 2, 100]
                @test range(;start, stop, length) == Base.range(start, stop; length)
                @test range(:bels;b=start, e=stop, l=length) == Base.range(start, stop; length)
            end
            for step in [-1, 1, 1]
                @test range(;start, length, step) == Base.range(start; step, length)
                @test range(:bels;b=start, l=length, s=step) == Base.range(start; step, length)
            end
        end
        for stop in [-2, 0, 2, 100]
            @test range(;length, stop) == Base.range(1; length, stop)
            @test range(:bels;l=length, e=stop, b=1) == Base.range(1; length, stop)
        end
        for step in [-1, 1, 1]
            @test range(;length, step) == Base.range(1; length, step)
            @test range(:bels;l=length, s=step, b=1) == Base.range(1; length, step)
        end
    end
end

@testset "Abbreviated keyword range" begin
    b = 1
    e = 5
    l = 5
    s = 1
    bels = [:b, :e, :l, :s]
    dict = Dict(:b => b, :e => e, :l => l, :s => s)
    for sym in bels
        range(sym, dict[sym])
        s1 = setdiff(bels, (sym,))
        for sym2 in s1
            range(Symbol(sym,sym2), dict[sym], dict[sym2])
            s2 = setdiff(s1, (sym2,))
            for sym3 in s2
                @test range(Symbol(sym,sym2,sym3), dict[sym], dict[sym2], dict[sym3]) == range(1, 5; length=5)
                @test range(Symbol(sym,sym2,sym3), dict[sym], dict[sym2], dict[sym3]) == range(:bels; sym => dict[sym], sym2 => dict[sym2], sym3 => dict[sym3])
            end
        end
    end
end

@testset "Length changing" begin
    @test length(1:5, 11) == range(1,5; length=11)
    @test length(1 => 5.5, 11) == range(1,5.5; length=11)
end

@testset "Step changing" begin
    @test step(1:5, 2) == range(1,5; step=2)
    @test step(1 => 5.5, 2) == range(1,5.5; step=2)
end

@testset "First and Last changing" begin
    @test first(1:5, 3) == 3:5
    @test last(1:5, 3) == 1:3
end