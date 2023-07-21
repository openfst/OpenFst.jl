const F = OpenFst
const testdir = "./testdata"
const tmpdir = "/tmp"

# FstClass

f = F.read(testdir * "/f1const.fst")

@test F.isfst(f)
@test F.final(f, 1) == Inf
@test F.arctype(f) == "standard"
@test F.fsttype(f) == "const"
@test F.numarcs(f, 1) == 3
@test F.numinputepsilons(f, 1) == 1
@test F.numoutputepsilons(f, 1) == 1
@test F.start(f) == 1
@test F.weighttype(f) == "tropical"
@test F.write(f, tmpdir * "/f1.fst")
@test F.equal(f, F.read(tmpdir * "/f1.fst"))

# MutableFstClass
goldenarcs = [F.Arc(1, 2, 1.0, 2), F.Arc(0, 0, 2.0, 2), F.Arc(5, 6, 3.0, 1)]
mf = F.read(testdir * "/f1vector.fst")

F.setstart!(mf, 2)
@test F.start(mf) == 2

# restore
F.setstart!(mf, 2)

F.setfinal!(mf, 1, 1.0)
@test F.final(mf, 1) == 1.0

# restore
F.setfinal!(mf, 1, Inf)

F.deletearcs!(mf, 1);
F.reservearcs(mf, 1, 3);
@test F.numarcs(mf, 1) == 0

for a in goldenarcs
    F.addarc!(mf, 1, a)
end
F.deletearcs!(mf, 1)
@test F.numarcs(mf, 1) == 0

@test F.numstates(mf) == 2

F.reservestates(mf, 5);
F.addstate!(mf)
@test F.numstates(mf) == 3

F.deletestates!(mf)

# VectorFstClass

svecf = F.StdVectorFst()
@test (F.isfst(svecf) &&
       F.fsttype(svecf) == "vector" &&
       F.arctype(svecf) == "standard" &&
       typeof(svecf) == F.VectorFst{F.TropicalWeight})

lvecf = F.VectorFst{F.LogWeight}()
@test (F.isfst(lvecf) &&
       F.fsttype(lvecf) == "vector" &&
       F.arctype(lvecf) == "log" &&
       typeof(lvecf) == F.VectorFst{F.LogWeight})

copyf = F.VectorFst(f)
@test F.equal(copyf, f)

