#=
Module that wraps OpenFst in Julia.
The OpenFst 'script-level' interface, used for the binary command
and Python-extension, is also used her.  That offers better run-time safety and
handles different semirings in one untemplated class (FstClass).
=#

module JOpenFst

const fstlib="/home/riley/src/jsalt/JOpenFst/src/jopenfst.so"

include("weight.jl")
include("fst-class.jl")
include("fst-iterators.jl")
include("fst-ops.jl")

end

