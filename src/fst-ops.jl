@enum ArcSortType ilabel olabel

"""
    arcsort!(fst::MutableFst, sort_type::ArcSortType)
Sort the arcs leaving each state, modifying its first argument.
# Arguments:
    fst: FST to sort
    sort_type: ilabel|olabel
"""
function arcsort!(fst::MutableFst, sort_type::ArcSortType)::Nothing
    @ccall fstlib.FstArcSort(fst.cptr::Ptr{Cvoid}, sort_type::Cint)::Cvoid
end

"""
        arcsort(fst::Fst, sort_type::ArcSortType)
Sort the arcs leaving _state_, returning the result.
# Arguments:
    fst: input FST
    sort_type: ilabel|olabel
"""
function arcsort(fst::Fst, sort_type::ArcSortType)::Fst
    ofst = VectorFst(fst)
    arcsort!(ofst, sort_type)
    return ofst
end

@enum ComposeFilter auto null trivial sequence alt_sequence match no_match

"""
    compose(fst1::Fst, fst2::Fst, connect = true, filter = auto)
Compose two FSTs, returning the result. Either _fst1_ needs to be 
olabel sorted or _fst2_ needs to be ilabel sorted.
# Arguments:
    fst1,2: input FSTs
    connect: connect the result
    filter: auto|null|trivial|sequence|alt_sequence|match|no_match
"""
function compose(fst1::Fst, fst2::Fst, connect::Bool = true, 
                 filter::ComposeFilter = auto)::Fst
    _create(VectorFst, typeof(fst1).parameters[1],
            @ccall fstlib.FstCompose(fst1.cptr::Ptr{Cvoid}, 
  	                             fst2.cptr::Ptr{Cvoid},
                                     connect::Cuchar,
                                     filter::Cint)::Ptr{Cvoid})
end

"""
   closure!(fst::MutableFst)
Compute the Kleene closure of an FST, modifying its argument.
"""
function closure!(fst::MutableFst)::Nothing
    @ccall fstlib.FstClosure(fst.cptr::Ptr{Cvoid})::Cvoid
end

"""
   closure(fst::Fst)
Compute the Kleene closure of an FST, returning the result.
"""
function closure(fst::Fst)::Fst
    ofst = VectorFst(fst)
    closure!(ofst)
    return ofst
end

"""
   concat!(fst1::MutableFst, fst2::Fst)
Concatenate two Fsts, modifying the 1st argument.
"""
function concat!(fst1::MutableFst, fst2::Fst)::Nothing
    @ccall fstlib.FstConcat(fst1.cptr::Ptr{Cvoid}, 
  	                    fst2.cptr::Ptr{Cvoid})::Cvoid
end

"""
   concat(fst1::Fst, fst2::Fst)
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
    fst: input FST
    δ: weight delta for comparison
"""
function determinize(fst::Fst, δ::AbstractFloat = 1.0e-3)::Fst
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
    fst: input FST
    δ: weight delta for comparison
"""
function disambiguate(fst::Fst, δ::AbstractFloat = 1.0e-3)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstDisambiguate(fst.cptr::Ptr{Cvoid}, 
                                          δ::Cfloat)::Ptr{Cvoid})
end

"""
    equal(fst1::Fst, fst2::Fst, δ = 1.0e-3)
Tests if two FSTs have identical states (with the same numbering) and arcs.
"""
function equal(fst1::Fst, fst2::Fst, δ::AbstractFloat = 1.0e-3)::Bool
    @ccall fstlib.FstEqual(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                           δ::Cfloat)::Cuchar
end

@enum EpsNormalizeType eps_norm_input eps_norm_output

"""
    epsnormalize(fst::Fst, norm_type::EpsNormalizeType)
Epsilon normalizes an FST, returning the result.
# Arguments:
    fst: input FST
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
    fst1,2: input FSTs
    δ: weight delta for comparison
"""
function equivalent(fst1::Fst, fst2::Fst, δ::AbstractFloat = 1.0e-3)::Bool
    @ccall fstlib.FstEquivalent(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                                δ::Cfloat)::Cuchar
end


"""
    intersect(fsa1::Fst, fsa2::Fst,, connect = true, filter = auto)
Intersects two FSAs, returning the result. Either _fsa1_ or _fst2_
needs to be label sorted.
# Arguments:
    fst1,2: input FSAs
    connect: connect the result
    filter: auto|null|trivial|sequence|alt_sequence|match|no_match
"""
function intersect(fst1::Fst, fst2::Fst, connect::Bool = true, 
                   filter::ComposeFilter = auto)::Fst
    _create(VectorFst, typeof(fst1).parameters[1],
            @ccall fstlib.FstIntersect(fst1.cptr::Ptr{Cvoid}, 
                                       fst2.cptr::Ptr{Cvoid},
                                       connect::Cuchar,
                                       filter::Cint)::Ptr{Cvoid})
end

"""
    invert!(fst::MutableFst)
Interchanges in the input and output labels on all arcs, modifying its
argument.
"""
function invert!(fst::MutableFst)::Nothing
    @ccall fstlib.FstInvert(fst.cptr::Ptr{Cvoid})::Cvoid
end

"""
    invert(fst::Fst)
Interchanges in the input and output labels on all arcs, returning
the result.
"""
function invert(fst::Fst)::Fst
    ofst = VectorFst(fst)
    invert!(ofst)
    return ofst
end

"""
    isomorphic(fst1::Fst, fst2::Fst, δ = 1.0e-3)
Tests if two FSTs have identical states (up to a renumbering) and arcs.
"""
function isomorphic(fst1::Fst, fst2::Fst, δ::AbstractFloat = 1.0e-3)::Bool
    @ccall fstlib.FstIsomorphic(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                                δ::Cfloat)::Cuchar
end

"""
    minimize!(fst::MutableFst)
Creates the minimal, deterministc FST, modifying its argument. The input
must be deterministic and epsilon-free.
"""
function minimize!(fst::MutableFst)::Nothing
    @ccall fstlib.FstMinimize(fst.cptr::Ptr{Cvoid})::Cvoid
end

"""
     minimize(fst::Fst)
Creates the minimal, deterministc FST, returning the result. The input
must be deterministic and epsilon-free.
"""
function minimize(fst::Fst)::Fst
    ofst = VectorFst(fst)
    minimize!(ofst)
    return ofst
end

@enum ProjectType input=1 output=2

"""
    project!(fst::MutableFst, project_type::ProjectType)
Creates an acceptor by copying the labels on one side of the FST to the other,
modifying its first argument.
# Arguments:
    fst: FST to project
    project_type: input|output
"""
function project!(fst::MutableFst, project_type::ProjectType)::Nothing
    @ccall fstlib.FstProject(fst.cptr::Ptr{Cvoid}, project_type::Cint)::Cvoid
end

"""
    project(fst::Fst, project_type::ProjectType)
Creates an acceptor by copying the labels on one side of the FST to the other,
returning the result.
# Arguments:
    fst: input FST
    project_type: input|output
"""
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

"""
    push!(fst::MutableFst, reweight_type::ReweightType, δ = 1.0e-6,
          remove_total_weight = false)
Pushes the weights of an FST, modifying its 1st argument.
# Arguments:
    fst: FST to push    
    reweight_type: reweight_to_initial|reweight_to_final
    remove_to_weight: true|false
    δ: weight delta for convergence
"""
function push!(fst::MutableFst, reweight_type::ReweightType, δ::AbstractFloat = 1.0e-6,
               remove_total_weight::Bool = false)::Nothing
    @ccall fstlib.FstPush(fst.cptr::Ptr{Cvoid}, reweight_type::Cint,
                          δ::Cfloat, remove_total_weight::Cuchar)::Cvoid
end

"""
    push(fst::Fst, reweight_type::ReweightType, δ = 1.0e-6,
          remove_total_weight = false)
Pushes the weights of an FST, modifying its 1st argument.
# Arguments:
    fst: input FST
    reweight_type: reweight_to_initial|reweight_to_final
    remove_to_weight: true|false
    δ: weight delta for convergence
"""
function push(fst::Fst, reweight_type::ReweightType, δ::AbstractFloat = 1.0e-3,
               remove_total_weight::Bool = false)::Fst
    ofst = VectorFst(fst)
    push!(ofst, reweight_type, δ, remove_total_weight)
    return ofst
end

"""
    randgen(fst::Fst)
Generate a random path (using a uniform distribution) of an FST,
returning the result as an FST.
"""
function randgen(fst::Fst)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstRandGen(fst.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

"""
        reverse(fst::Fst)::Fst
Reverse an FST
"""
function reverse(fst::Fst)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstReverse(fst.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

"""
    rmepsilon!(fst::Fst)
Removes the (input/output) epsilons from an FST, modifying its first argument.
"""
function rmepsilon!(fst::MutableFst)::Nothing
    @ccall fstlib.FstRmEpsilon(fst.cptr::Ptr{Cvoid})::Cvoid
end

"""
    rmepsilon(fst::Fst)
Removes the (input/output) epsilons from an FST, returning the result.
"""
function rmepsilon(fst::Fst)::Fst
    ofst = VectorFst(fst)
    rmepsilon!(ofst)
    return ofst
end

"""
    shortestdistance(fst::Fst, reverse = false, δ = 1.0e-6)
Finds the single-source shortest distance from the initial states, returning
a Vector of distances. The ith entry in the distance vector
corresponds to the ith state distance. If the length n of the vector is
less than the number of states in the FST, then the distance for any
state s >= n is semiring *0*.
# Arguments
    fst: input FST
    reverse: false: distance from initial state, true: from (super-)final state
    δ: weight delta for convergence
"""
function shortestdistance(fst::Fst, reverse::Bool = false, 
	                  δ::AbstractFloat = 1.0e-6)::Vector{Cdouble}
    n = Ref{Int32}()
    sptr = @ccall fstlib.FstShortestDistance(
        fst.cptr::Ptr{Cvoid}, n::Ref{Cint}, 
	reverse::Cuchar, δ::Cfloat)::Ptr{Cdouble}
    distance = Vector{Float64}(undef, n[])   
    dptr = Base.unsafe_convert(Ref{Cdouble}, distance)
    unsafe_copyto!(dptr, sptr, n[]);
    distance
end

@enum QueueType trivial_queue fifo_queue lifo_queue shortest_first_queue top_order_queue state_order_queue scc_queue auto_queue

"""
    shortestdistance(fst::Fst, reverse = false, δ = 1.0e-6)
Finds the single-source shortest distance from the initial states, returning
a Vector of distances. The ith entry in the distance vector
corresponds to the ith state distance. If the length n of the vector is
less than the number of states in the FST, then the distance for any
state s >= n is semiring *0*.
# Arguments
    fst: input FST
    queue_type: fifo_queue|lifo_queue|shortest_first_queue|top_order_queue|state_order_queue|auto_queue
    δ: weight delta for convergence
"""
function shortestdistance(fst::Fst, queue_type::QueueType,
                        δ::AbstractFloat = 1.0e-6)::Vector{Cdouble}
    n = Ref{Int32}()
    sptr = @ccall fstlib.FstShortestDistanceWithQueue(
        fst.cptr::Ptr{Cvoid}, n::Ref{Cint}, 
	    queue_type::Cint, δ::Cfloat)::Ptr{Cdouble}
    distance = Vector{Float64}(undef, n[])   
    dptr = Base.unsafe_convert(Ref{Cdouble}, distance)
    unsafe_copyto!(dptr, sptr, n[]);
    distance 
end

"""
    shortestpath(fst::Fst, nshortest = 1, unique = false, δ = 1.0e-6)
Finds the (n) shortest paths(s) in an FST.
# Arguments
    fst: input FST
    δ: weight delta for convergence
"""
function shortestpath(fst::Fst, nshortest::Integer = 1, unique::Bool = false,
	              δ::AbstractFloat = 1.0e-6)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstShortestPath(
                fst.cptr::Ptr{Cvoid}, nshortest::Cint,
	        unique::Cuchar, δ::Cfloat)::Ptr{Cvoid})
end

"""
    synchronize(fst::Fst)
Synchronizes the labels of an FST.
"""
function synchronize(fst::Fst)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstSynchronize(fst.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

"""
   topsort!(fst::MutableFst)
Topologically sorts the states of an acyclic FST, moditying its argument.
"""
function topsort!(fst::MutableFst)::Nothing
    @ccall fstlib.FstTopSort(fst.cptr::Ptr{Cvoid})::Cvoid
end

"""
   topsort!(fst::Fst)
Topologically sorts the states of an acyclic FST, returning the result.
"""
function topsort(fst::Fst)::Fst
    ofst = VectorFst(fst)
    topsort!(ofst)
    return ofst
end

"""
   union!(fst1::MutableFst, fst2::Fst)
Unions two Fsts, modifying its 1st argument.
"""
function union!(fst1::MutableFst, fst2::Fst)::Nothing
    @ccall fstlib.FstUnion(fst1.cptr::Ptr{Cvoid}, 
                           fst2.cptr::Ptr{Cvoid})::Cvoid
end

"""
   union(fst1::Fst, fst2::Fst)
Unions two Fsts, returning the result.
"""
function union(fst1::Fst, fst2::Fst)::Fst
    ofst = VectorFst(fst1)
    union!(ofst, fst2)
    return ofst
end

"""
    verify(fst::Fst)
Checks the sanity of an FST, returning false if it is incomplete or ill-formed.
"""
function verify(fst::Fst)::Bool
    @ccall fstlib.FstVerify(fst.cptr::Ptr{Cvoid})::Cuchar
end
