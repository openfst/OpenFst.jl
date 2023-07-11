function compose(fst1::Fst, fst2::Fst)::Fst
    _create(VectorFst, typeof(fst1).parameters[1],
           @ccall fstlib.FstCompose(fst1.cptr::Ptr{Cvoid}, 
  	                            fst2.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

function closure!(fst::MutableFst)::Nothing
   @ccall fstlib.FstClosure(fst.cptr::Ptr{Cvoid})::Cvoid
end

function closure(fst::Fst)::Fst
   ofst = VectorFst(fst)
   closure!(ofst)
   return ofst
end

function concat!(fst1::MutableFst, fst2::Fst)::Nothing
   @ccall fstlib.FstConcat(fst1.cptr::Ptr{Cvoid}, 
  	                   fst2.cptr::Ptr{Cvoid})::Cvoid
end

function concat(fst1::Fst, fst2::Fst)::Fst
   ofst = VectorFst(fst1)
   concat!(ofst, fst2)
   return ofst
end

function connect!(fst::MutableFst)::Nothing
   @ccall fstlib.FstConnect(fst.cptr::Ptr{Cvoid})::Cvoid
end

function connect(fst::Fst)::Fst
   ofst = VectorFst(fst)
   connect!(ofst)
   return ofst
end

function determinize(fst::Fst, δ = 1.0e-3)::Fst
   _create(VectorFst, typeof(fst).parameters[1],
           @ccall fstlib.FstDeterminize(fst.cptr::Ptr{Cvoid}, 
                                        δ::Cfloat)::Ptr{Cvoid})
end

function difference(fst1::Fst, fst2::Fst)::Fst
   _create(VectorFst, typeof(fst1).parameters[1],
           @ccall fstlib.FstDifference(fst1.cptr::Ptr{Cvoid}, 
     	                                fst2.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end
function disambiguate(fst::Fst, δ = 1.0e-3)::Fst
   _create(VectorFst, typeof(fst).parameters[1],
           @ccall fstlib.FstDisambiguate(fst.cptr::Ptr{Cvoid}, 
                                         δ::Cfloat)::Ptr{Cvoid})
end

function equal(fst1::Fst, fst2::Fst, δ = 1.0e-3)::Bool
   @ccall fstlib.FstEqual(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                          δ::Cfloat)::Cuchar
end

function equivalent(fst1::Fst, fst2::Fst, δ = 1.0e-3)::Bool
   @ccall fstlib.FstEquivalent(fst1.cptr::Ptr{Cvoid}, fst2.cptr::Ptr{Cvoid},
                               δ::Cfloat)::Cuchar
end

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

function prune!(fst::MutableFst, thresh::AbstractFloat)::Nothing
   @ccall fstlib.FstPrune(fst.cptr::Ptr{Cvoid}, thresh::Cdouble)::Cvoid
end

function prune(fst::Fst, thresh::AbstractFloat)::Fst
   ofst = VectorFst(fst)
   prune!(ofst, thresh)
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
		   reverse::Cuchar, δ::Cdouble)::Ptr{Cdouble}
   distance = Vector{Float64}(undef, n[])   
   dptr = Base.unsafe_convert(Ref{Cdouble}, distance)
   unsafe_copyto!(dptr, sptr, n[]);
   distance
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
