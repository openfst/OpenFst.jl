
using Test
using OpenFst


@testset "FST Class" begin
   include("fst-class-test.jl")
end

@testset "FST Iterators" begin
   include("fst-iterators-test.jl")
end

@testset "FST Ops" begin
   include("fst-ops-test.jl")
end
