const F = JOpenFst
const testdir = "./testdata"
const tmpdir = "/tmp"

# FstClass

f = F.read(testdir * "/f1const.fst")

if !F.isfst(f)
  error("test failed: read")
end

final = F.final(f, 0)
if final != Inf
  error("test failed: final")
end

arctype = F.arctype(f)
if arctype != "standard"
  error("test failed: arctype")
end

fsttype = F.fsttype(f)
if fsttype != "const"
  error("test failed: fsttype")
end

numarcs = F.numarcs(f, 0)
if numarcs != 3
  error("test failed: numarcs")
end

numieps = F.numinputepsilons(f, 0)
if numieps != 1
  error("test failed: numinputepsilons")
end

numoeps = F.numoutputepsilons(f, 0)
if numoeps != 1
  error("test failed: numoutputepsilons")
end

start = F.start(f)
if start != 0
  error("test failed: start")
end

weighttype = F.weighttype(f)
if weighttype != "tropical"
  error("test failed: weighttype")
end

res = F.write(f, tmpdir * "/f1.fst")
if res == false
  error("test failed: write")
end

tf = F.read(tmpdir * "/f1.fst")

if !F.equal(f, tf)
  error("test failed: write")
end

# MutableFstClass
goldenarcs = [F.Arc(1, 2, 1.0, 1), F.Arc(0, 0, 2.0, 1), F.Arc(5, 6, 3.0, 0)]

mf = F.read(testdir * "/f1vector.fst");

F.setstart!(mf, 1)
start = F.start(mf)
if start != 1
  error("test failed: setstart")
end
# restore
F.setstart!(mf, 1)

F.setfinal!(mf, 0, 1.0)
final = F.final(mf, 0)
if final != 1.0
  error("test failed: setfinal")
end
# restore
F.setfinal!(mf, 0, Inf)

F.deletearcs!(mf, 0);
F.reservearcs(mf, 0, 3);
if F.numarcs(mf, 0) != 0
   error("test failed: deletearcs")
end

for a in goldenarcs
  F.addarc!(mf, 0, a)
end

F.deletearcs!(mf, 0)

if F.numarcs(mf, 0) != 0
   error("test failed: deletearcs")
end

if F.numstates(mf) != 2
   error("test failed: numstates")
end

F.reservestates(mf, 5);
F.addstate!(mf)

if F.numstates(mf) != 3
  error("test failed: numstates")
end

F.deletestates!(mf);

# VectorFstClass

svecf = F.StdVectorFst()
if !F.isfst(svecf) || F.fsttype(svecf) != "vector" || 
    F.arctype(svecf) != "standard"
  error("test failed: StdVectorFst construction")
end

lvecf = F.VectorFst{F.LogWeight}()
if !F.isfst(lvecf) || F.fsttype(lvecf) != "vector" || 
    F.arctype(lvecf) != "log"
  error("test failed: Log VectorFst construction")
end
