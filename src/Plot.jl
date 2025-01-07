using HypertextLiteral



Base.@kwdef struct ObservablePlot
    options = Dict{String,Any}()
    marks::Vector{ObservableMark} = ObservableMark[]
end

function Base.show(io::IO, m::MIME"text/html", p::ObservableMark)
    Base.show(io, m, ObservablePlot(marks=[p]))
end

function Base.show(io::IO, m::MIME"text/html", p::ObservablePlot)
    Base.show(io, m, @htl """
    <div>

    <script id="yolo">


    const Plot = this?.plotlib ?? await import("https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm");


    const plot = Plot.plot({
        ...$(p.options),
        marks: $(get_js_content.(p.marks)),
    })


    const div = this ?? document.createElement("div")
    div.innerHTML = ""
    div.append(plot);

    div.plotlib = Plot
    return div

    </script>
    </div>

    """)
end

