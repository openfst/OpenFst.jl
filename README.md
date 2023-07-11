# OpenFst.jl
# Julia OpenFst interface

## Installation
$  ( cd src; make )  
$  export LOAD_PATHS=./src   
$  julia --project=./  

## Usage
This interface is similar in functionality to the 
[OpenFst command-line](https://www.openfst.org) and 
[python](https://python.openfst.org) interfaces. Principal differences:
1. the Julia convention of 1-based indexing is followed
for states and arcs. 
2. weights are specified by floating point numbers supporting
TropicalWeight, LogWeight, and Log64Weight.
3. Most [OpenFst operations](https://www.openfst.org/twiki/bin/view/FST/FstQuickTour#AvailableOperations) are supported but mostly only default options

See the examples below for FST creation, access, and operations.

## Examples
See ./runexamp.sh

## Testing
See ./runtests.sh
