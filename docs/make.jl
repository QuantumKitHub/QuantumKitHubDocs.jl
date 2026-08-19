# Script to build the MultiDocumenter demo docs
#
#   julia --project docs/make.jl [--temp] [deploy]
#
# When `deploy` is passed as an argument, it goes into deployment mode
# and attempts to push the generated site to gh-pages. You can also pass
# `--temp`, in which case the source repositories are cloned into a temporary
# directory (as opposed to `docs/clones`).
using MultiDocumenter
import Documenter

clonedir = ("--temp" in ARGS) ? mktempdir() : joinpath(@__DIR__, "clones")
outpath = joinpath(@__DIR__, "build/")
@info """
Cloning packages into: $(clonedir)
Building aggregate site into: $(outpath)
"""

function inhouse_ref(name)
    return MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, name),
        path = name,
        name = name,
        giturl = "https://github.com/QuantumKitHub/$name.jl.git",
    )
end


@info "Building aggregate MultiDocumenter site"
docs = [
    MultiDocumenter.DropdownNav(
        "Toolbox",
        [
            inhouse_ref("MatrixAlgebraKit"),
            inhouse_ref("TensorOperations"),
            inhouse_ref("VectorInterface"),
            # inhouse_ref("SparseArrayKit"),
        ],
    ),
    MultiDocumenter.DropdownNav(
        "Tensors",
        [
            inhouse_ref("TensorKit"),
            inhouse_ref("TensorKitTensors"),
            inhouse_ref("TensorKitSectors"),
            # inhouse_ref("SUNRepresentations"),
            # inhouse_ref("CategoryData"),
        ],
    ),
    MultiDocumenter.DropdownNav(
        "Tensor Networks",
        [
            inhouse_ref("MPSKit"),
            inhouse_ref("PEPSKit"),
            inhouse_ref("TNRKit"),
        ],
    ),
]

MultiDocumenter.make(
    outpath,
    docs;
    search_engine = MultiDocumenter.SearchConfig(
        index_versions = ["stable"],
        engine = MultiDocumenter.PageFind,
    ),
    rootpath = "/QuantumKitHubDocs.jl/",
    canonical_domain = "https://quantumkithub.github.io/",
    sitemap = true,
)

Documenter.deploydocs(; repo = "github.com/QuantumKitHub/QuantumKitHubDocs.jl.git", push_preview = true)
