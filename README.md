# OpenFst.jl
# Julia OpenFst interface

## Installation
$  ( cd src; make )  
$  export LOAD_PATHS=./src   
$  julia --project=./  

## Examples
See ./runexamp.sh

## Usage
This interface is similar in funcitionality to the 
[OpenFst command-line](https://www.openfst.org) and 
[python](python.openfst.org) interfaces. Principal differences:
1. the Julia convention of 1-based indexing is followed
for states and arcs. 
2. Weights are specified by floating point numbers supporting
TropicalWeight, LogWeight, and Log64Weight.

## Testing
See ./runtests.sh
