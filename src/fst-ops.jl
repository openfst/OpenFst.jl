@enum ArcSortType ilabel olabel

"""
    arcsort!(fst::MutableFst, sort_type::ArcSortType)
Sort the arcs leaving a state, modifying its first argument.
# Arguments:
sort_type: ilabel|olabel
"""
function arcsort!(fst::MutableFst, sort_type::ArcSortType)::Nothing
    @ccall fstlib.FstArcSort(fst.cptr::Ptr{Cvoid}, sort_type::Cint)::Cvoid
end

"""
    arcsort(fst::Fst, sort_type::ArcSortType)
Sort the arcs leaving a state, returning the result.
# Arguments:
sort_type: ilabel|olabel
"""
function arcsort(fst::Fst, sort_type::ArcSortType)::Fst
    ofst = VectorFst(fst)
    arcsort!(ofst, sort_type)
    return ofst
end

"""
    compose(fst1::Fst, fst2::Fst)
Compose two FSTs, returning the result. Either _fst1_ needs to be 
olabel sorted or _fst2_ needs to be ilabel sorted.
"""
function compose(fst1::Fst, fst2::Fst)::Fst
    _create(VectorFst, typeof(fst1).parameters[1],
            @ccall fstlib.FstCompose(fst1.cptr::Ptr{Cvoid}, 
  	                             fst2.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

"""
   closure!(fst::MutableFst)
Compute the Kleene closure of an FST, modifying its argument"
"""
function closure!(fst::MutableFst)::Nothing
    @ccall fstlib.FstClosure(fst.cptr::Ptr{Cvoid})::Cvoid
end

"""
   closure(fst::MutableFst)
Compute the Kleene closure of an FST, returning the result.
"""
function closure(fst::Fst)::Fst
    ofst = VectorFst(fst)
    closure!(ofst)
    return ofst
end

"""
   concat!(fst::MutableFst, fst::Fst)
Concatenate two Fsts, modifying the 1st argument.
"""
function concat!(fst1::MutableFst, fst2::Fst)::Nothing
    @ccall fstlib.FstConcat(fst1.cptr::Ptr{Cvoid}, 
  	                    fst2.cptr::Ptr{Cvoid})::Cvoid
end

"""
   concat(fst::Fst, fst::Fst)
Concatenate two Fsts, returning the result.
"""
function concat(fst1::Fst, fst2::Fst)::Fst
    ofst = VectorFst(fst1)
    concat!(ofst, fst2)
    return ofst
end

"""
    connect!(fst::MutableFst)
Remove inaccessible and non-coaccessible states from an FST, modifying 
its argument.
"""
function connect!(fst::MutableFst)::Nothing
    @ccall fstlib.FstConnect(fst.cptr::Ptr{Cvoid})::Cvoid
end

"""
    connect(fst::Fst)
Remove inaccessible and non-coaccessible states from an FST, returning
the result.
"""
function connect(fst::Fst)::Fst
    ofst = VectorFst(fst)
    connect!(ofst)
    return ofst
end

"""
    determinize(fst::Fst, δ = 1.0e-3)
Determinizes an FST, returning the result.
# Arguments:
δ: weight delta for comparison
"""
function determinize(fst::Fst, δ = 1.0e-3)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstDeterminize(fst.cptr::Ptr{Cvoid}, 
                                         δ::Cfloat)::Ptr{Cvoid})
end


"""
    difference(fsa1::Fst, fsa2::Fst)
Removes strings in _fsta2_ from _fsta1_. Either _fsta1_ needs to be 
olabel sorted or _fsta2_ needs to be ilabel sorted and 
_fsta2_ needs to be epsilon-free, unweighted, and deterministic.
"""
function difference(fst1::Fst, fst2::Fst)::Fst
    _create(VectorFst, typeof(fst1).parameters[1],
            @ccall fstlib.FstDifference(fst1.cptr::Ptr{Cvoid}, 
     	                                fst2.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

"""
    disambiguate(fst::Fst, δ = 1.0e-3)
Ensures no two paths are labeled with the same string in an FSA, returning
the result.
# Arguments:
δ: weight delta for comparison
"""
function disambiguate(fst::Fst, δ = 1.0e-3)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstDisambiguate(fst.cptr::Ptr{Cvoid}, 
                                          δ::Cfloat)::Ptr{Cvoid})
end

"""
    equal(fst1::Fst, fst2::Fst, δ = 1.0e-3)
Tests if two FSTs have identical states (with the same numbering) and arcs.
"""
function equal(fst1::Fst, fst2::Fst, δ = 1.0e-3)::Bool
    @ccall fstlib.FstEqual(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                           δ::Cfloat)::Cuchar
end

@enum EpsNormalizeType eps_norm_input eps_norm_output

"""
   epsnormalize(fst::Fst, norm_type::EpsNormalizeType)
Epsilon normalizes an FST, returning the result.
# Arguments:
norm_type: eps_norm_input|eps_norm_output
"""
function epsnormalize(fst::Fst, norm_type::EpsNormalizeType)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstEpsNormalize(fst.cptr::Ptr{Cvoid}, 
                                          norm_type::Cint)::Ptr{Cvoid})
end


"""
    equivalent(fst1::Fst, fst2::Fst, δ = 1.0e-3)
Tests if two FSAs accept the same strings with the same weights.
# Arguments:
δ: weight delta for comparison
"""
function equivalent(fst1::Fst, fst2::Fst, δ = 1.0e-3)::Bool
    @ccall fstlib.FstEquivalent(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                                δ::Cfloat)::Cuchar
end


"""
    compose(fsa1::Fst, fsa2::Fst)
Intersects two FSAs, returning the result. Either _fsa1_ or _fst2_
needs to be label sorted.
"""
function intersect(fst1::Fst, fst2::Fst)::Fst
    _create(VectorFst, typeof(fst1).parameters[1],
            @ccall fstlib.FstIntersect(fst1.cptr::Ptr{Cvoid}, 
                                       fst2.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

function invert!(fst::MutableFst)::Nothing
    @ccall fstlib.FstInvert(fst.cptr::Ptr{Cvoid})::Cvoid
end

function invert(fst::Fst)::Fst
    ofst = VectorFst(fst)
    invert!(ofst)
    return ofst
end

"""
    isomorphic(fst1::Fst, fst2::Fst, δ = 1.0e-3)
Tests if two FSTs have identical states (up to a renumbering) and arcs.
"""
function isomorphic(fst1::Fst, fst2::Fst, δ = 1.0e-3)::Bool
    @ccall fstlib.FstIsomorphic(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                                δ::Cfloat)::Cuchar
end

function minimize!(fst::MutableFst)::Nothing
    @ccall fstlib.FstMinimize(fst.cptr::Ptr{Cvoid})::Cvoid
end

function minimize(fst::Fst)::Fst
    ofst = VectorFst(fst)
    minimize!(ofst)
    return ofst
end

@enum ProjectType input=1 output=2

function project!(fst::MutableFst, project_type::ProjectType)::Nothing
    @ccall fstlib.FstProject(fst.cptr::Ptr{Cvoid}, project_type::Cint)::Cvoid
end

function project(fst::Fst, project_type::ProjectType)::Fst
    ofst = VectorFst(fst)
    project!(ofst, project_type)
    return ofst
end

function prune!(fst::MutableFst, thresh::AbstractFloat)::Nothing
    @ccall fstlib.FstPrune(fst.cptr::Ptr{Cvoid}, thresh::Cdouble)::Cvoid
end

function prune(fst::Fst, thresh::AbstractFloat)::Fst
    ofst = VectorFst(fst)
    prune!(ofst, thresh)
    return ofst
end

@enum ReweightType reweight_to_initial reweight_to_final

function push!(fst::MutableFst, reweight_type::ReweightType, δ = 1.0e-6,
               remove_total_weight = false)::Nothing
    @ccall fstlib.FstPush(fst.cptr::Ptr{Cvoid}, reweight_type::Cint,
                          δ::Cfloat, remove_total_weight::Cuchar)::Cvoid
end

function push(fst::Fst, reweight_type::ReweightType, δ = 1.0e-3,
               remove_total_weight = false)::Fst
    ofst = VectorFst(fst)
    push!(ofst, reweight_type, δ, remove_total_weight)
    return ofst
end

function randgen(fst::Fst)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstRandGen(fst.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

function reverse(fst::Fst)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstReverse(fst.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

function rmepsilon!(fst::MutableFst)::Nothing
    @ccall fstlib.FstRmEpsilon(fst.cptr::Ptr{Cvoid})::Cvoid
end

function rmepsilon(fst::Fst)::Fst
    ofst = VectorFst(fst)
    rmepsilon!(ofst)
    return ofst
end

function shortestdistance(fst::Fst, reverse = false, 
	                  δ = 1.0e-6)::Vector{Cdouble}
    n = Ref{Int32}()
    sptr = @ccall fstlib.FstShortestDistance(
        fst.cptr::Ptr{Cvoid}, n::Ref{Cint}, 
	reverse::Cuchar, δ::Cfloat)::Ptr{Cdouble}
    distance = Vector{Float64}(undef, n[])   
    dptr = Base.unsafe_convert(Ref{Cdouble}, distance)
    unsafe_copyto!(dptr, sptr, n[]);
    distance
end

function shortestpath(fst::Fst, nshortest = 1, unique = false,
	              δ = 1.0e-6)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstShortestPath(
                fst.cptr::Ptr{Cvoid}, nshortest::Cint,
	        unique::Cuchar, δ::Cfloat)::Ptr{Cvoid})
end

function synchronize(fst::Fst)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstSynchronize(fst.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

function topsort!(fst::MutableFst)::Nothing
    @ccall fstlib.FstTopSort(fst.cptr::Ptr{Cvoid})::Cvoid
end

function topsort(fst::Fst)::Fst
    ofst = VectorFst(fst)
    topsort!(ofst)
    return ofst
end

function union!(fst1::MutableFst, fst2::Fst)::Nothing
    @ccall fstlib.FstUnion(fst1.cptr::Ptr{Cvoid}, 
                           fst2.cptr::Ptr{Cvoid})::Cvoid
end

function union(fst1::Fst, fst2::Fst)::Fst
    ofst = VectorFst(fst1)
    union!(ofst, fst2)
    return ofst
end
