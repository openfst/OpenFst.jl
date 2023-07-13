const F = OpenFst
const testdir = "./testdata"
const tmpdir = "/tmp"

f = F.read(testdir * "/f1const.fst")
mf = F.read(testdir * "/f1vector.fst")

if !F.isfst(f)
  error("test failed: read")
end

# StateIterator
goldenstates = [1,2]

# - OpenFst-style iteration interface
siter = F.StateIterator(f)
teststates = Vector{Int32}()
while !F.done(siter)
   push!(teststates, F.value(siter))
   F.next(siter)
end

if teststates != goldenstates
   error("test failed: state iterator (1)")
end 

# - Julia-style iteration interface
teststates = Vector{Int32}()
for s in F.states(f)
   push!(teststates, s)
end

if teststates != goldenstates
   error("test failed: state iterator (2)")
end 

# ArcIterator
goldenarcs = [F.Arc(2, 3, 1.0, 2), F.Arc(1, 1, 2.0, 2), F.Arc(6, 7, 3.0, 1)]

# - OpenFst-style iteration/indexing interface (0-based arc indexing)
aiter = F.ArcIterator(f, 1)
testarcs = Vector()
while !F.done(aiter)
   push!(testarcs, F.value(aiter))
   F.value(aiter)
   F.next(aiter)
end

if testarcs != goldenarcs
   error("test failed: arc iterator (1)")
end 

F.reset(aiter)
F.seek(aiter, 2)
if F.position(aiter) != 2 || F.value(aiter) != goldenarcs[2]
   error("test failed: arc iterator (2)")
end

# - Julia-style iteration/indexing interface (1-based arc indexing)
testarcs = Vector()
for a in F.arcs(f, 1)
   push!(testarcs, a)
end

if testarcs != goldenarcs
   error("test failed: arc iterator (3)")
end 

farcs = F.arcs(f, 1)
if farcs[1] != goldenarcs[1]
   error("test failed: arc index (1)")
end

# - OpenFst-style iteration/indexing interface (0-based arc indexing)
aiter = F.MutableArcIterator(mf, 1)
testarcs = Vector()

while !F.done(aiter)
   push!(testarcs, F.value(aiter))
   F.value(aiter)
   F.next(aiter)
end

if testarcs != goldenarcs
   error("test failed: mutable arc iterator (1)")
end 

F.reset(aiter)
F.seek(aiter, 2)
if F.position(aiter) != 2 || F.value(aiter) != goldenarcs[2]
   error("test failed: mutable arc iterator (2)")
end

F.setvalue(aiter, goldenarcs[1])

if F.value(aiter) != goldenarcs[1]
   error("test failed: mutable arc iterator (3)")
end

# restore
F.setvalue(aiter, goldenarcs[2])

# - Julia-style iteration/indexing interface (1-based arc indexing)
testarcs = Vector()
for a in F.arcs(mf, 1)
   push!(testarcs, a)
end

mfarcs = F.arcs(mf, 1)
if mfarcs[1] != goldenarcs[1]
   error("test failed: mutable arc index (1)")
end

mfarcs[1] = goldenarcs[2]

if mfarcs[1] != goldenarcs[2]
   error("test failed: mutable arc index (2)")
end

# restore
mfarcs[1] != goldenarcs[1]

