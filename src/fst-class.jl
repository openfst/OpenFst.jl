abstract type Fst{Weight} end
abstract type MutableFst{Weight} <: Fst{Weight} end

# The following need to be mutable structs so they can be finalized

# A julia primitive MutableFst type
mutable struct VectorFst{Weight} <: MutableFst{Weight}
  cptr::Ptr{Cvoid}
end

# A julia primitive generic Fst type
# This is a catch-all for o.w. unspecified Fsts
mutable struct GenericFst{Weight} <: Fst{Weight}
  cptr::Ptr{Cvoid}
end

StdVectorFst = VectorFst{TropicalWeight}
StdGenericFst = GenericFst{TropicalWeight}

struct Arc
   ilabel::Int64
   olabel::Int64
   weight::Float64
   nextstate::Int64
end

nullptr = convert(Ptr{Cvoid}, 0);

isfst(fst::Fst)::Bool = (fst.cptr != nullptr)

function delete!(fst::Fst)
   @ccall fstlib.FstDelete(fst.cptr::Ptr{Cvoid})::Nothing
end

function create(fsttype, weighttype, cptr::Ptr{Cvoid})
   fst = fsttype{weighttype}(cptr)
   finalizer(delete!, fst)
   return fst
end

# Fst type

function read(file::String)
   cptr = @ccall fstlib.FstRead(file::Cstring)::Ptr{Cvoid}
   fst = GenericFst{Weight}(cptr)   
   if isfst(fst)
      ftype = fsttype(fst) == "vector" ? VectorFst : GenericFst
      wtype = WeightType[arctype(fst)]
      fst = ftype{wtype}(cptr)
      finalizer(delete!, fst)
      return fst
   else
      error("read failed")
      return nothing
   end
end

function write(fst::Fst, file::String)::Bool
   ret = @ccall fstlib.FstWrite(fst.cptr::Ptr{Cvoid}, file::Cstring)::Cuchar
   ret == 0 ? false : true
end

function start(fst::Fst)::Cint
   @ccall fstlib.FstStart(fst.cptr::Ptr{Cvoid})::Cint
end

function final(fst::Fst, state::Int64)::Cdouble
   @ccall fstlib.FstFinal(fst.cptr::Ptr{Cvoid}, state::Cint)::Cdouble
end

function numarcs(fst::Fst, state::Int64)::Cint
   @ccall fstlib.FstNumArcs(fst.cptr::Ptr{Cvoid}, state::Cint)::Cint
end

function numinputepsilons(fst::Fst, state::Int64)::Cint
   @ccall fstlib.FstNumInputEpsilons(fst.cptr::Ptr{Cvoid}, state::Cint)::Cint
end

function numoutputepsilons(fst::Fst, state::Int64)::Cint
   @ccall fstlib.FstNumOutputEpsilons(fst.cptr::Ptr{Cvoid}, state::Cint)::Cint
end

function weighttype(fst::Fst)::String
   str = @ccall fstlib.FstWeightType(fst.cptr::Ptr{Cvoid})::Cstring
   unsafe_string(str);  
end

function arctype(fst::Fst)::String
   str = @ccall fstlib.FstArcType(fst.cptr::Ptr{Cvoid})::Cstring
   unsafe_string(str);
end

function fsttype(fst::Fst)::String
   str = @ccall fstlib.FstType(fst.cptr::Ptr{Cvoid})::Cstring
   unsafe_string(str);  
end

# MutableFst type

function setstart!(fst::MutableFst, s::Int64)::Bool
    @ccall fstlib.FstSetStart(fst.cptr::Ptr{Cvoid}, s::Cint)::Cuchar
end

function setfinal!(fst::MutableFst, s::Int64, w::Float64)::Bool
    @ccall fstlib.FstSetFinal(fst.cptr::Ptr{Cvoid}, s::Cint, 
                             w::Cdouble)::Cuchar
end

function addarc!(fst::MutableFst, s::Int64, a::Arc)::Bool
    @ccall fstlib.FstAddArc(fst.cptr::Ptr{Cvoid}, s::Cint, a.ilabel::Cint, 
                            a.olabel::Cint, a.weight::Cdouble, 
                            a.nextstate::Cint)::Cuchar
end

function deletearcs!(fst::MutableFst, s::Int64)::Bool
    @ccall fstlib.FstDeleteArcs(fst.cptr::Ptr{Cvoid}, s::Cint)::Cuchar
end

function reservearcs(fst::MutableFst, s::Int64, n::Int64)::Bool
    @ccall fstlib.FstReserveArcs(fst.cptr::Ptr{Cvoid}, s::Cint, 
                                 n::Cint)::Cuchar
end

function numstates(fst::MutableFst)::Int64
    @ccall fstlib.FstNumStates(fst.cptr::Ptr{Cvoid})::Cint
end

function addstate!(fst::MutableFst)::Int64
    @ccall fstlib.FstAddState(fst.cptr::Ptr{Cvoid})::Cint
end

function reservestates(fst::MutableFst, n::Int64)::Bool
    @ccall fstlib.FstReserveStates(fst.cptr::Ptr{Cvoid}, n::Cint)::Cuchar
end

function deletestates!(fst::MutableFst)::Nothing
   @ccall fstlib.FstDeleteStates(fst.cptr::Ptr{Cvoid})::Cvoid
end

# VectorFst type

function VectorFst{W}() where W <: Weight
    arctype = ArcType[W]
    cptr = @ccall fstlib.VectorFstCreate(arctype::Cstring)::Ptr{Cvoid}
    create(VectorFst, W, cptr)
end

