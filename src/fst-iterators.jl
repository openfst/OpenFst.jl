# State iterator

# - OpenFst-style state iteration interface

# The following needs to be a mutable struct so it can be finalized
mutable struct StateIterator
    cptr::Ptr{Cvoid}
end

function delete!(siter::StateIterator)
    @ccall fstlib.StateIteratorDelete(siter.cptr::Ptr{Cvoid})::Nothing
end

function StateIterator(fst::Fst)
    cptr = @ccall fstlib.StateIteratorCreate(
        fst.cptr::Ptr{Cvoid})::Ptr{Cvoid}
    siter = StateIterator(cptr)
    finalizer(delete!, siter)
    return siter
end
    
function done(siter::StateIterator)::Bool
    @ccall fstlib.StateIteratorDone(siter.cptr::Ptr{Cvoid})::Cuchar
end

function value(siter::StateIterator)::Cint
    1 + @ccall fstlib.StateIteratorValue(siter.cptr::Ptr{Cvoid})::Cint
end

function next(siter::StateIterator)::Nothing
    @ccall fstlib.StateIteratorNext(siter.cptr::Ptr{Cvoid})::Nothing
end

# - Julia-style state iteration interface

# Julia state iterator is presentlyjust the FST
states(fst::Fst) = fst

# constructs OpenFst StateIterator
function Base.iterate(fst::Fst)
    siter = StateIterator(fst)
    iterate(fst, siter)
end

function Base.iterate(fst::Fst, siter)
    if done(siter)
        ret = nothing
    else
        ret = (value(siter), siter)
        next(siter)
    end
    return ret
end

Base.IteratorSize(fst::Fst) = Base.SizeUnknown()
Base.eltype(fst::Fst) = Cint

# Arc iterator

# - OpenFst-style arc iteration/indexing interface (0-based arc indexing)

# The following needs to be mutable struct so it can be finalized
mutable struct ArcIterator
    cptr::Ptr{Cvoid}
end

function delete!(aiter::ArcIterator)
    @ccall fstlib.ArcIteratorDelete(aiter.cptr::Ptr{Cvoid})::Nothing
end

function ArcIterator(fst::Fst, state::Integer)
    cptr = @ccall fstlib.ArcIteratorCreate(fst.cptr::Ptr{Cvoid}, 
                                           (state - 1)::Cint)::Ptr{Cvoid}
    aiter = ArcIterator(cptr)
    finalizer(delete!, aiter)
    return aiter
end
    
function done(aiter::ArcIterator)::Bool
    @ccall fstlib.ArcIteratorDone(aiter.cptr::Ptr{Cvoid})::Cuchar
end

function value(aiter::ArcIterator)::Arc
    ilabel = Ref{Cint}()
    olabel = Ref{Cint}()
    weight = Ref{Cdouble}()
    nextstate = Ref{Cint}()
    @ccall fstlib.ArcIteratorValue(
        aiter.cptr::Ptr{Cvoid}, ilabel::Ref{Cint}, olabel::Ref{Cint},
        weight::Ref{Cdouble}, nextstate::Ref{Cint})::Nothing
    Arc(ilabel[], olabel[], weight[], nextstate[] + 1)
end

function next(aiter::ArcIterator)::Nothing
    @ccall fstlib.ArcIteratorNext(aiter.cptr::Ptr{Cvoid})::Nothing
end

function position(aiter::ArcIterator)::Int32
    1 + @ccall fstlib.ArcIteratorPosition(aiter.cptr::Ptr{Cvoid})::Cint
end

function reset(aiter::ArcIterator)::Nothing
    @ccall fstlib.ArcIteratorReset(aiter.cptr::Ptr{Cvoid})::Nothing
end

function seek(aiter::ArcIterator, a::Integer)::Nothing
    @ccall fstlib.ArcIteratorSeek(aiter.cptr::Ptr{Cvoid}, 
                                  (a - 1)::Cint)::Nothing
end

# - Julia-style arc iteration/indexing interface (1-based arc indexing)
# the iter source type for FST arcs at a state
struct Arcs
    fst::Fst
    state::Int64
    aiter::ArcIterator
end

# returns a Julia-sytle arc iterator
function arcs(fst::Fst, state::Integer) 
    aiter = ArcIterator(fst, state)
    Arcs(fst, state, aiter)
end

function Base.iterate(arcs::Arcs, aiter = arcs.aiter)
    if done(aiter)
        ret = nothing
    else
        ret = (value(aiter), aiter)
        next(aiter)
    end
    return ret
end

Base.eltype(arcs::Arcs) = Arc

function Base.length(arcs::Arcs)::Int32
    numarcs(arcs.fst, arcs.state)    
end

function Base.getindex(arcs::Arcs, i::Integer)::Arc
    seek(arcs.aiter, i)   
    value(arcs.aiter)   
end

# Mutable Arc iterator

# - OpenFst-style arc iteration/indexing interface (0-based arc indexing)

# The following needs to be mutable struct so it can be finalized
mutable struct MutableArcIterator
    cptr::Ptr{Cvoid}
end

function delete!(aiter::MutableArcIterator)
    @ccall fstlib.MutableArcIteratorDelete(aiter.cptr::Ptr{Cvoid})::Nothing
end

function MutableArcIterator(fst::MutableFst, state::Integer)
    cptr = @ccall fstlib.MutableArcIteratorCreate(fst.cptr::Ptr{Cvoid}, 
                                                  (state - 1)::Cint)::Ptr{Cvoid}
    aiter = MutableArcIterator(cptr)
    finalizer(delete!, aiter)
    return aiter
end
    
function done(aiter::MutableArcIterator)::Bool
    @ccall fstlib.MutableArcIteratorDone(aiter.cptr::Ptr{Cvoid})::Cuchar
end

function value(aiter::MutableArcIterator)::Arc
    ilabel = Ref{Cint}()
    olabel = Ref{Cint}()
    weight = Ref{Cdouble}()
    nextstate = Ref{Cint}()
    @ccall fstlib.MutableArcIteratorValue(
        aiter.cptr::Ptr{Cvoid}, ilabel::Ref{Cint}, olabel::Ref{Cint},
        weight::Ref{Cdouble}, nextstate::Ref{Cint})::Nothing
    Arc(ilabel[], olabel[], weight[], nextstate[] + 1)
end

function next(aiter::MutableArcIterator)::Nothing
    @ccall fstlib.MutableArcIteratorNext(aiter.cptr::Ptr{Cvoid})::Nothing
end

function position(aiter::MutableArcIterator)::Int32
    1 + @ccall fstlib.MutableArcIteratorPosition(
        aiter.cptr::Ptr{Cvoid})::Cint
end

function reset(aiter::MutableArcIterator)::Nothing
    @ccall fstlib.MutableArcIteratorReset(aiter.cptr::Ptr{Cvoid})::Nothing
end

function seek(aiter::MutableArcIterator, a::Integer)::Nothing
    @ccall fstlib.MutableArcIteratorSeek(aiter.cptr::Ptr{Cvoid}, 
                                        (a - 1)::Cint)::Cvoid
end

function setvalue(aiter::MutableArcIterator, arc::Arc)::Nothing
    @ccall fstlib.MutableArcIteratorSetValue(
        aiter.cptr::Ptr{Cvoid}, arc.ilabel::Cint, 
        arc.olabel::Cint, arc.weight::Cdouble, 
        (arc.nextstate - 1)::Cint)::Cvoid
end

# - Julia-style arc iteration/indexing interface (1-based arc indexing)

# the iter source for FST mutable arcs at a state
struct MutableArcs
    fst::MutableFst
    state::Int32
    aiter::MutableArcIterator
end

function arcs(fst::MutableFst, state::Integer)
    aiter = MutableArcIterator(fst, state)
    MutableArcs(fst, state, aiter)
end

function Base.iterate(arcs::MutableArcs, aiter = arcs.aiter)
    if done(arcs.aiter)
        ret = nothing
    else
        ret = (value(arcs.aiter), arcs.aiter)
        next(arcs.aiter)
    end
    return ret
end

Base.eltype(arcs::MutableArcs) = Arc

function Base.length(arcs::MutableArcs)::Int32
    numarcs(arcs.fst, arcs.state)    
end

function Base.getindex(arcs::MutableArcs, i::Integer)::Arc
    seek(arcs.aiter, i)   
    value(arcs.aiter)   
end

function Base.setindex!(arcs::MutableArcs, arc::Arc, i::Integer)::Nothing
    seek(arcs.aiter, i)   
    setvalue(arcs.aiter, arc);
end
