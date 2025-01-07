
export plot

function plot(marks...; options...)
    ObservablePlot(; marks=collect(marks), options)
end
