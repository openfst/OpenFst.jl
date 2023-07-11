export LOADS_PATHS=./src
julia --project=./ -e 'using Pkg; Pkg.test()'
