#=
Module that wraps OpenFst in Julia.
The OpenFst 'script-level' interface, used for the binary command
and Python-extension, is also used here.  That offers better run-time
safety and handles different semirings in one untemplated class (FstClass).
=#

module OpenFst

using Pkg.Artifacts

const fstlib = joinpath(dirname(pathof(OpenFst)), "jopenfst.so")

include("weight.jl")
include("fst-class.jl")
include("fst-iterators.jl")
include("fst-ops.jl")

function __init__()
    so_ext = Sys.isapple() ? ".dylib" : ".so"
    cdir = pwd()

    OPENFST_PATH = if "JULIA_OPENFST_PATH" in keys(ENV)
        ENV["JULIA_OPENFST_PATH"]
    else
        path = joinpath(artifact"openfst", "openfst-1.8.2.post1")
        builddir = mkpath(joinpath(path, "build"))
        cd(path)
        lib = joinpath(builddir, "lib", "libfst" * so_ext)
        if ! isfile(lib)
            @debug "Building openfst"
            run(`./configure --prefix $(buildpath)`)
            run(`make -j $(Base.Threads.nthreads())`)
            run(`make install`)
        else
            @debug "$(lib) file exists, not doing anything"
        end
        builddir
    end

    @debug "Using openfst located in $OPENFST_PATH"

    pkgdir = dirname(pathof(OpenFst))
    lib = joinpath(pkgdir, "jopenfst.so")
    if "JULIA_OPENFST_PATH" in keys(ENV) || ! isfile(lib)
        @debug "Compiling \"$(lib)\""
        cd(pkgdir)
        run(`make PREFIX=$(realpath(joinpath(OPENFST_PATH)))`)
    end

    cd(cdir)
end

end

