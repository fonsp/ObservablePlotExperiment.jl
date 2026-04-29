
export plot

function plot(marks...; options...)
    ObservablePlot(; marks=collect(marks), options)
end



# so you can do .plot(...) on a mark:
function Base.getproperty(om::ObservableMark, s::Symbol)
    if s === :plot
        function (; kwargs...)
            plot(om; kwargs...)
        end
    else
        getfield(om, s)
    end
end
