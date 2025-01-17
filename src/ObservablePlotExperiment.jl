module ObservablePlotExperiment


export @jsl


include("jsl.jl")
import .JSL: @jsl


include("embed_data.jl")
include("Mark.jl")
include("Plot.jl")
include("show.jl")
include("api/plot.jl")
include("api/marks.jl")
include("api/tidy.jl")
include("api/inspector.jl")


end