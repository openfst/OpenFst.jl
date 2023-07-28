# OpenFst.jl
# Julia OpenFst interface

## Installation

In the Julia REPL, hit `]` to enter the package mode and type
```julia
pkg> add https://github.com/openfst/OpenFst.jl
```
and then to check that everything is ok
```julia
pkg> test OpenFst
```
On the first call of 
```julia
julia> using OpenFst
```
[OpenFst](https://www.openfst.org) will be downloaded and installed.

## Usage
This interface is similar in functionality to the
[OpenFst command-line](https://www.openfst.org) and
[python](https://python.openfst.org) interfaces. Principal differences:
1. the Julia convention of 1-based indexing is followed for states,
arcs and labels. E.g. the first state and arc of a state has index 1
and label 1 is epsilon. Label ID 0 and state ID 0 are reserved for
'nolabel' and 'nostateid' respectively.
2. the Julia convention of naming functions that modify their
argument is followed. So the constructive `union(fst1, fst2)` returns a new FST
but the destructive 'union!(fst1, fst2)' modifies its first argument and
returns `nothing`. Destructive versions of operations are provided when
more efficient and corresponding constructive versions are usually included
for convenience.
3. weights are currently specified by floating point numbers supporting
TropicalWeight, LogWeight, and Log64Weight
4. Most [OpenFst operations](https://www.openfst.org/twiki/bin/view/FST/FstQuickTour#AvailableOperations) are supported but currently mainly with
only the default options

See the example below for FST creation, access, and operation syntax.

## Example
Executing

 	$ julia --project=./ exampl.jl

will run this example:

	#=
	Example code for Julia OpenFst interface
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

	# Show flower automaton
	F.show(flower)
	println("start = ", F.start(flower))
	println("num states = ", F.numstates(flower))
	for s in F.states(flower)
		println("state ", s,
				": # arcs = ", F.numarcs(flower, s),
				", final weight = ", F.final(flower, s))
		for a in F.arcs(flower, s)
		   F.show(a)
		end
	end

	# Convenience functions
	optimize(f) = F.arcsort(F.minimize(F.determinize(F.rmepsilon(f))), F.ilabel)
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

	fst1 = randfst(flower)
	fst2 = randfst(flower)
	fst3 = randfst(flower)

	# Test that intersection associates
	# F1 * (F2 * F3)
	result1 = F.intersect(fst1, F.intersect(fst2, fst3))
	# (F1 * F2) * F3
	result2 = F.intersect(F.intersect(fst1, fst2), fst3)
	println("Intersection associates: ", equiv(result1, result2))

	# Test that intersection distributes over union
	# F1 * (F2 U F3)
	result1 = F.intersect(fst1, F.union(fst2, fst3))
	# F1 * F2 U F1 * F3
	result2 = F.union(F.intersect(fst1, fst2), F.intersect(fst1, fst3))
	println("Intersection distributes over union: ", equiv(result1, result2))

The output of this script is:

	OpenFst.VectorFst{OpenFst.TropicalWeight}
	start = 1
	num states = 1
	state 1: # arcs = 4, final weight = 0.0
	Arc(ilabel = 1, olabel = 1, weight = 1.0, nextstate = 1)
	Arc(ilabel = 2, olabel = 2, weight = 2.0, nextstate = 1)
	Arc(ilabel = 3, olabel = 3, weight = 3.0, nextstate = 1)
	Arc(ilabel = 4, olabel = 4, weight = 4.0, nextstate = 1)
	Intersection associates: true
	Intersection distributes over union: true

## Testing
See ./runtests.sh

## To Do
1. Wrap: encode info map relabel replace reweight
2. Expose more options to operations in the interface
3. Improve julia safety - catch more errors in julia not C++
4. Extend to general weights and arcs
