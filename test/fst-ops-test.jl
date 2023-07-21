const F = OpenFst
const testdir = "./testdata"
const tmpdir = "/tmp"

f1 = F.read(testdir * "/f1const.fst")
@test F.isfst(f1)

f2 = F.read(testdir * "/f2.fst")
@test F.isfst(f2)

a1 = F.read(testdir * "/a1.fst")
@test F.isfst(a1)

a2 = F.read(testdir * "/a2.fst")
@test F.isfst(a2)

asrtf = F.VectorFst(f1)
F.arcsort!(asrtf, F.ilabel)
goldenasrtf = F.read(testdir * "/f1arcsort.fst")
@test F.isfst(asrtf) && F.equal(asrtf, goldenasrtf)

cf = F.compose(f1, f2)
goldencf = F.read(testdir * "/f12compose.fst")
@test F.isfst(cf) && F.equal(cf, goldencf)

trmf = F.VectorFst(a1)
F.connect!(trmf)
@test F.isfst(trmf) && F.equal(a1, trmf)

epsnf = F.epsnormalize(f1, F.eps_norm_input)
goldenepsnf = F.read(testdir * "/f1epsnorm.fst")
@test F.isfst(epsnf) && F.equal(epsnf, goldenepsnf)

inf = F.intersect(a1, a2)
goldeninf = F.read(testdir * "/a12intersect.fst")
@test F.isfst(inf) && F.equal(inf, goldeninf)

conf = F.VectorFst(a1)
F.concat!(conf, a2)
goldenconf = F.read(testdir * "/a12concat.fst")
@test F.isfst(conf) && F.equal(conf, goldenconf)

clsf = F.VectorFst(a1)
F.closure!(clsf)
goldenclsf = F.read(testdir * "/a1closure.fst")
@test F.isfst(clsf) && F.equal(clsf, goldenclsf)

unf1 = F.VectorFst(a1)
F.union!(unf1, a2)
goldenunf = F.read(testdir * "/a12union.fst")
@test F.isfst(unf1) && F.equal(unf1, goldenunf)

unf2 = F.VectorFst(a2)
F.union!(unf2, a1)
F.rmepsilon!(unf1)
F.rmepsilon!(unf2)
dunf1 = F.determinize(unf1)
dunf2 = F.determinize(unf2)
@test F.equivalent(dunf1, dunf2)

invf = F.VectorFst(f1)
goldeninvf = F.read(testdir * "/f1invert.fst")
F.invert!(invf)
@test F.isfst(invf) && F.equal(invf, goldeninvf)

projf = F.VectorFst(f1)
F.project!(projf, F.output)
goldenprojf = F.read(testdir * "/f1project.fst")
@test F.isfst(projf) && F.equal(projf, goldenprojf)

rmf = F.VectorFst(f1)
goldenrmf = F.read(testdir * "/f1rmepsilon.fst")
F.rmepsilon!(rmf)
@test F.isfst(rmf) && F.equal(rmf, goldenrmf)

detf = F.determinize(rmf)
goldendetf = F.read(testdir * "/f1determinize.fst")
@test F.isfst(detf) && F.equal(detf, goldendetf)

disf = F.disambiguate(rmf)
goldendisf = F.read(testdir * "/f1disambiguate.fst")
@test F.isfst(disf) && F.equal(disf, goldendisf)

minf = F.VectorFst(detf)
F.minimize!(minf)
goldenminf = F.read(testdir * "/f1minimize.fst")
@test F.isfst(minf) && F.equal(minf, goldenminf)

prf = F.VectorFst(f)
F.prune!(prf, 0.5)
goldenpruf = F.read(testdir * "/f1prune.fst")
@test F.isfst(prf) && F.equal(prf, goldenpruf)

pshf = F.VectorFst(f)
F.push!(pshf, F.reweight_to_initial)
goldenpshf = F.read(testdir * "/f1push.fst")
@test F.isfst(pshf) && F.equal(pshf, goldenpshf)

revf = F.reverse(f1)
goldenrevf = F.read(testdir * "/f1reverse.fst")
@test F.isfst(revf) && F.equal(revf, goldenrevf)

topf = F.VectorFst(a2)
F.topsort(topf)
@test F.isfst(topf) && F.isomorphic(a2, topf)

distance = F.shortestdistance(f1)
print(distance[2])
@test distance[2] == 1.0

shrtf = F.shortestpath(f1)
goldenshrtf = F.read(testdir * "/f1shortest.fst")
@test F.isfst(shrtf) && F.equal(shrtf, goldenshrtf)

