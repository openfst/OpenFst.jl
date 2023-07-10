function compose(fst1::Fst, fst2::Fst)::Fst
    _create(VectorFst, typeof(fst1).parameters[1],
           @ccall fstlib.FstCompose(fst1.cptr::Ptr{Cvoid}, 
  	                            fst2.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

function determinize(fst::Fst, δ = 1.0e-3)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstDeterminize(fst.cptr::Ptr{Cvoid}, 
                                         δ::Cfloat)::Ptr{Cvoid})
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

function invert!(fst::Fst)::Nothing
    @ccall fstlib.FstInvert(fst.cptr::Ptr{Cvoid})::Cvoid
end

function minimize!(fst::Fst)::Nothing
    @ccall fstlib.FstMinimize(fst.cptr::Ptr{Cvoid})::Cvoid
end

function prune!(fst::Fst, thresh::AbstractFloat)::Nothing
    @ccall fstlib.FstPrune(fst.cptr::Ptr{Cvoid}, thresh::Cdouble)::Cvoid
end

function reverse(fst::Fst)::Fst
    _create(VectorFst, typeof(fst).parameters[1],
            @ccall fstlib.FstReverse(fst.cptr::Ptr{Cvoid})::Ptr{Cvoid})
end

function rmepsilon!(fst::Fst)::Nothing
    @ccall fstlib.FstRmEpsilon(fst.cptr::Ptr{Cvoid})::Cvoid
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
