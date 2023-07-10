#=
Example code to test an identity using intersection and union with random FSTs
=#

using OpenFst
F = OpenFst

# Create a flower automaton
flower = F.VectorFst{F.TropicalWeight}()
F.addstate!(flower)
F.setstart!(flower, 1)        # states numbered from 1 per Julia
F.setfinal!(flower, 1, 0.0)
for i in 1:4
    arc = F.Arc(ilabel=i, olabel=i, weight=i, nextstate=1)
    F.addarc!(flower, 1, arc)
end

# Convenience functions
optimize(f) = F.minimize(F.determinize(F.rmepsilon(f)))
equiv(f1, f2) = F.equivalent(optimize(f1), optimize(f2))

# Create a random FST
function randfst(ifst) 
  # union some paths in the flower automaton
  ofst = F.VectorFst{F.TropicalWeight}()
  for i in 1:5
    path = F.randgen(ifst)
    F.union!(ofst, path)
  end
  # Optimize the result
  optimize(ofst)
end

# Test that intersection distributes over union
fst1 = randfst(flower)
fst2 = randfst(flower)
fst3 = randfst(flower)

# F1 * (F2 U F3)
result1 = F.intersect(fst1, F.union(fst2, fst3))
# F1 * F2 U F1 * F3
result2 = F.union(F.intersect(fst1, fst2), F.intersect(fst1, fst3))

println(equiv(result1, result2))


