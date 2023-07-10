const F = OpenFst
const testdir = "./testdata"
const tmpdir = "/tmp"

f1 = F.read(testdir * "/f1const.fst")
if !F.isfst(f1)
  error("test failed: read")
end

f2 = F.read(testdir * "/f2.fst")
if !F.isfst(f2)
  error("test failed: read")
end

a1 = F.read(testdir * "/a1.fst")
if !F.isfst(a1)
  error("test failed: read")
end

a2 = F.read(testdir * "/a2.fst")
if !F.isfst(a2)
  error("test failed: read")
end

cf = F.compose(f1, f2)
goldencf = F.read(testdir * "/f12compose.fst")
if !F.isfst(cf) || !F.equal(cf, goldencf)
   error("test failed: compose")
end

inf = F.intersect(a1, a2)
goldeninf = F.read(testdir * "/a12intersect.fst")
if !F.isfst(inf) || !F.equal(inf, goldeninf)
   error("test failed: intersect")
end

conf = F.VectorFst(a1)
F.concat!(conf, a2)
goldenconf = F.read(testdir * "/a12concat.fst")
if !F.isfst(conf) || !F.equal(conf, goldenconf)
   error("test failed: concat")
end

clsf = F.VectorFst(a1)
F.closure!(clsf)
goldenclsf = F.read(testdir * "/a1closure.fst")
if !F.isfst(clsf) || !F.equal(clsf, goldenclsf)
   error("test failed: closure")
end

unf1 = F.VectorFst(a1)
F.union!(unf1, a2)
goldenunf = F.read(testdir * "/a12union.fst")
if !F.isfst(unf1) || !F.equal(unf1, goldenunf)
   error("test failed: union")
end

unf2 = F.VectorFst(a2)
F.union!(unf2, a1)
F.rmepsilon!(unf1)
F.rmepsilon!(unf2)
dunf1 = F.determinize(unf1)
dunf2 = F.determinize(unf2)
if !F.equivalent(dunf1, dunf2)
   error("test failed: equivalent")
end

invf = F.VectorFst(f1)
goldeninvf = F.read(testdir * "/f1invert.fst")
F.invert!(invf)
if !F.isfst(invf) || !F.equal(invf, goldeninvf)
   error("test failed: invert")
end

rmf = F.VectorFst(f1)
goldenrmf = F.read(testdir * "/f1rmepsilon.fst")
F.rmepsilon!(rmf)
if !F.isfst(rmf) || !F.equal(rmf, goldenrmf)
   error("test failed: rmepsilon")
end

detf = F.determinize(rmf)
goldendetf = F.read(testdir * "/f1determinize.fst")
if !F.isfst(detf) || !F.equal(detf, goldendetf)
   error("test failed: determinize")
end

disf = F.disambiguate(rmf)
goldendisf = F.read(testdir * "/f1disambiguate.fst")
if !F.isfst(disf) || !F.equal(disf, goldendisf)
   error("test failed: disambiguate")
end

minf = F.VectorFst(detf)
F.minimize!(minf)
goldenminf = F.read(testdir * "/f1minimize.fst")
if !F.isfst(minf) || !F.equal(minf, goldenminf)
   error("test failed: minimize")
end

prf = F.VectorFst(f)
F.prune!(prf, 0.5)
goldenpruf = F.read(testdir * "/f1prune.fst")
if !F.isfst(prf) || !F.equal(prf, goldenpruf)
  error("test failed: prune")
end

revf = F.reverse(f1)
goldenrevf = F.read(testdir * "/f1reverse.fst")
if !F.isfst(revf) || !F.equal(revf, goldenrevf)
  error("test failed: reverse")
end

distance = F.shortestdistance(f1)
print(distance[2])
if distance[2] != 1.0
   error("test failed: shortestdistance")
end
