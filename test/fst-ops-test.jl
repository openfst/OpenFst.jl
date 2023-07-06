const F = JOpenFst
const testdir = "./testdata"
const tmpdir = "/tmp"

f1 = F.read(testdir * "/f1const.fst")
if !F.isfst(f1)
  error("read")
end

f2 = F.read(testdir * "/f2.fst")
if !F.isfst(f2)
  error("read")
end

cf = F.compose(f1, f2)
goldencf = F.read(testdir * "/f12compose.fst")
if !F.isfst(cf) || !F.equal(cf, goldencf)
   error("compose")
end

rf1 = F.reverse(f1)
goldenrf1 = F.read(testdir * "/f1reverse.fst")
if !F.isfst(rf1) || !F.equal(rf1, goldenrf1)
  error("reverse")
end

distance = F.shortestdistance(f)
if distance[2] != 1.0
  error("shortestdistance")
end
