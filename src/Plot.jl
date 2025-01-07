using HypertextLiteral



Base.@kwdef struct ObservablePlot
    options = Dict{String,Any}()
    marks::Vector{ObservableMark} = ObservableMark[]
end


# a mark on its own should display as plot
function Base.show(io::IO, m::MIME"text/html", p::ObservableMark)
    Base.show(io, m, ObservablePlot(marks=[p]))
end

