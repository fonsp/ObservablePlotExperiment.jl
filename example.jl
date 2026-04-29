### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 06be8ac3-fa55-449d-ad3f-8162bd36c6b7
begin
	# Learn more: https://plutojl.org/en/docs/packages-advanced/
	import Pkg
	Pkg.activate(temp=true)
	Pkg.develop(path=".")
	Pkg.add([
		"CSV"
		"Dates"
		"DataFrames"
		"Revise"
		"HypertextLiteral"
	])
end

# ╔═╡ b3656548-3be2-47ed-898e-3634003eee0b
using Revise, ObservablePlotExperiment

# ╔═╡ 76ec430d-3c01-4545-8be3-e82528257c33
using CSV, DataFrames

# ╔═╡ b5ab10a0-d0c1-477e-8985-8cfbbc38fc6b
using Dates

# ╔═╡ 9b80c3d6-ed15-499f-806b-6fa1091c417a
using HypertextLiteral

# ╔═╡ fec4e333-9ac1-48b1-af9e-c521e62dc5e0
const inspector_style = @htl """
	<style>
.observablehq--expanded,
.observablehq--collapsed,
.observablehq--function,
.observablehq--import,
.observablehq--string:before,
.observablehq--string:after,
.observablehq--gray {
  color: var(--cm-color-editor-text);
}

.observablehq--collapsed,
.observablehq--inspect a {
  cursor: pointer;
}

.observablehq--field {
  text-indent: -1em;
  margin-left: 1em;
}

.observablehq--empty {
  color: var(--cm-color-comment);
}

.observablehq--keyword,
.observablehq--blue {
  color: var(--cm-color-keyword);
}

.observablehq--forbidden,
.observablehq--pink {
  color: var(--cm-color-comment);
}

.observablehq--orange {
  color: var(--cm-color-tag);
}

.observablehq--null,
.observablehq--undefined {
  color: var(--cm-color-builtin);
}
	
.observablehq--boolean {
  color: var(--cm-color-atom);
}

.observablehq--number,
.observablehq--bigint,
.observablehq--date,
.observablehq--regexp,
.observablehq--symbol,
.observablehq--green {
  color: var(--cm-color-number);
}

.observablehq--index,
.observablehq--key {
  color: var(--cm-color-var);
}

.observablehq--prototype-key {
  color: #aaa;
}

.observablehq--empty {
  font-style: oblique;
}

.observablehq--string,
.observablehq--purple {
  color: var(--cm-color-string);
}

.observablehq--inspect {
  font-family: Menlo, monospace;
  overflow-x: auto;
  display: block;
  white-space: pre;
}

.observablehq--error .observablehq--inspect {
  word-break: break-all;
  white-space: pre-wrap;
}space: pre-wrap;
}
	</style>
	"""

# ╔═╡ bd4bab37-46e8-4f84-a360-1d59a6e90b9b
function debug_js_value(something_to_debug)
	@htl """
	$inspector_style
	<div >
	
	
	<script id="insp">
	const { Inspector } = this?.insplib ?? await import("https://unpkg.com/@observablehq/inspector@5.0.1/src/index.js?module")
	    
	

	const elem = this ?? document.createElement("span")
	const insp = elem.insp ?? new Inspector(elem)

	try {
		insp.fulfilled($(ObservablePlotExperiment.smart_embed_data(something_to_debug)))
	} catch(e) {
		insp.rejected(e)
		console.error(e)
	}

	elem.insp = insp
	elem.insplib = Inspector
	return elem
	
	</script>
	</div>
	"""
end

# ╔═╡ f89d818c-8ebd-4dbb-bca2-2e0aab2e399e
@bind zz html"<input type=range>"

# ╔═╡ 5ac00890-ef6b-456a-9463-ad88c538df09
debug_js_value(Float64[1,2,3/2,zz])

# ╔═╡ 4e6cc694-41d9-4052-818b-4e60c631144b
with_js_lib(x) = @jsl """
	await (async () => {
	const Plot = this?.plotlib ?? await import("https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm");
	return $x
	})()
	"""
	

# ╔═╡ b28904fd-8cc9-41fc-9806-748ede4cc6cd
md"""
Combining with Plot:
"""

# ╔═╡ 5f744aee-dadd-4b04-a067-7a102a36ae83
md"""
# Getting the data
"""

# ╔═╡ 464672aa-cc48-11ef-3173-9bb6140273d2
url1 = "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_mm_mlo.csv"

# ╔═╡ 55d66238-68c1-4c7a-8159-f411fa663260
url2 = "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_daily_mlo.csv"

# ╔═╡ 1e735495-ef76-433a-b3a4-dd787fa4f669
# ╠═╡ disabled = true
#=╠═╡
Text(read(download(url2), String))
  ╠═╡ =#

# ╔═╡ 3525308c-a7d7-4373-8826-f5a46a21c42a
d = CSV.read(download(url1), DataFrame; comment="#")

# ╔═╡ 063d8376-2c3b-4d74-abe8-582fe6bd9d1d
d2 = CSV.read(download(url2), DataFrame; comment="#", header=0)

# ╔═╡ 1cfc7eb7-a190-4072-9c3a-f3abac8befa7


# ╔═╡ cdfa1d2a-baa0-4831-a6b1-69385efa8eb3
dates = [Date(x[1], x[2], x[3]) for x in eachrow(d2)]

# ╔═╡ 97d30320-ff55-4d2c-90bc-935ca233f1cc
tidyzip(x=[1,2,3], y=[6,7])

# ╔═╡ d9329375-5915-4868-96e2-4d9bf5594df7
debug_js_value(tidyzip(x=[1,2,3], y=[6,7]))

# ╔═╡ 3e91edb7-3a29-4288-b8e0-826296e06d20
vals = [x[5] for x in eachrow(d2)]

# ╔═╡ a5b6e36c-574c-4921-adfd-de5ab004579c
cell(nothing; 
	fill=vals[1:2000], 
	x=dayofmonth.(dates[1:2000]), 
	y=month.(dates[1:2000]), 
	fy=year.(dates[1:2000]),
).x |> with_js_lib |> debug_js_value

# ╔═╡ 383c54e5-9315-4b52-b77b-43f73dc252dd
cell(zip(dates[1:400], vals[1:400]); 
	x=@jsl("d => d[0].getUTCDate()"),
	y=@jsl("d => d[0].getUTCMonth()"),
	fy=@jsl("d => d[0].getUTCFullYear()"),
	fill=@jsl("d => d[1]"),
	
)

# ╔═╡ 1a8a376d-6a66-4c77-b5f5-5929a1e330a5
cell(tidyzip(
	CO₂=vals[1:400], 
	month=month.(dates[1:400]),
	day=dayofmonth.(dates[1:400]),
	year=year.(dates[1:400])
); fill="CO₂", x="day", y="month", fy="year")

# ╔═╡ 52ddb495-724a-4572-aa55-0f490ac77c40
cell(nothing; 
	fill=vals[440:920], 
	x=dayofmonth.(dates[440:920]), 
	y=month.(dates[440:920]), 
	fy=year.(dates[440:920]),
).plot(x=(label="day",), y=(label="month",), fy=(label="year",))

# ╔═╡ 0c89c8ad-7ee9-4dcf-8bc3-f3a1bf3f73a4
# line(dates, vals)

# ╔═╡ 4c9a553c-2319-4d22-9afb-5c35232e4c29
vals

# ╔═╡ e7e02789-bc11-449c-863a-86a604bfff00
plot(
	line(
		zip(dates[1:70],vals[1:70]);
		marker=true,
		curve= "catmull-rom",
	);

	x=(label="asdf",),

	y =(
		label="CO2 ppm",
		transform=@jsl("x => x * 2"),
	),

)

# ╔═╡ d349e5b1-6be3-4399-af82-3322529b20a5
plot()

# ╔═╡ 37c1b129-f631-472a-bba8-9e4766d5739f
md"""
IDEA! when you pass in props that observablehq does not know but they exist in Plots/makie then we can show hints

like markersize, xlabel, xlims
"""

# ╔═╡ 9a4b7cd3-c436-48ca-9d61-214f76b217fe
plot(
	line(zip(dates[1:100], vals[1:100]); curve="catmull-rom",),
	dot(zip(dates[1:100], vals[1:100]); tip=true);
	
	y=(
		grid=true,
		transform=@jsl("x => x*2"),
	),
)

# ╔═╡ 468ca161-92f6-4f51-b1fb-7d3a14ca47b4
lineY(vals; tip=true)

# ╔═╡ c8224122-8307-46e4-85c9-82ed6591ba5b
lineY(vals; x=ObservablePlotExperiment.smart_embed_data(dates))

# ╔═╡ 9125e779-2903-40bc-b2f0-57864f4defd2


# ╔═╡ 32c9e066-d734-4226-bcf9-c8f2e9aa01e0
dot(zip(dates, vals))

# ╔═╡ eaea893c-2d29-45fb-b63f-b866b9ca9b9f
z = randn(101)

# ╔═╡ 654fe84c-783f-421e-9680-85ab2435f5b6
data = z[1:100] .+ z[2:101] .+ 2

# ╔═╡ d6aed7bc-972d-4916-915d-2c6adddc9768
data

# ╔═╡ 04152403-abde-4b8f-83ad-1b35bc374d32
dot(enumerate(data))

# ╔═╡ 36a7cd4f-e957-45ab-951e-1ee90a9ad333
lineY(data)

# ╔═╡ 0bffc169-cbb4-42e2-ba6c-8dc35fa606e7
lineX(data)

# ╔═╡ c05bb2f6-7a7c-4e55-88fe-18b803b339c0
plot(
	lineY(data),
	dot(enumerate(data))
)

# ╔═╡ b3fe231e-2656-4e97-b026-977e6b854125
plot(
	(
		lineY(data .+ i)
		for i in 1:10
	)...,
)

# ╔═╡ 5872fbe3-702b-4ebf-8cc9-ec9322c4aa7b
peaks = map(enumerate(data)) do (i,x)
	left = data[max(begin,i-1)]
	right = data[min(end,i+1)]
	left < x > right
end

# ╔═╡ 6a13b7fe-f12c-4518-a1df-9bbd55174765
plot(
	lineY(data; tip=false, marker=true),
	text(enumerate(data); 
		lineAnchor="bottom", 
		dy=-6,
		filter=peaks,
	),
	x=(label="index"),
	height=200,
)

# ╔═╡ 0e96533e-0420-4fd4-90ee-0786a2d98fe5
md"""
# Pkg setup

This is needed because this notebook is in the same repo as the package. Normally you would just do

```julia
using ObservablePlotExperiment
```


"""

# ╔═╡ Cell order:
# ╟─fec4e333-9ac1-48b1-af9e-c521e62dc5e0
# ╟─bd4bab37-46e8-4f84-a360-1d59a6e90b9b
# ╠═5ac00890-ef6b-456a-9463-ad88c538df09
# ╠═f89d818c-8ebd-4dbb-bca2-2e0aab2e399e
# ╠═4e6cc694-41d9-4052-818b-4e60c631144b
# ╠═a5b6e36c-574c-4921-adfd-de5ab004579c
# ╠═d6aed7bc-972d-4916-915d-2c6adddc9768
# ╠═04152403-abde-4b8f-83ad-1b35bc374d32
# ╠═36a7cd4f-e957-45ab-951e-1ee90a9ad333
# ╠═0bffc169-cbb4-42e2-ba6c-8dc35fa606e7
# ╟─b28904fd-8cc9-41fc-9806-748ede4cc6cd
# ╠═c05bb2f6-7a7c-4e55-88fe-18b803b339c0
# ╠═b3fe231e-2656-4e97-b026-977e6b854125
# ╟─5f744aee-dadd-4b04-a067-7a102a36ae83
# ╠═76ec430d-3c01-4545-8be3-e82528257c33
# ╠═464672aa-cc48-11ef-3173-9bb6140273d2
# ╠═55d66238-68c1-4c7a-8159-f411fa663260
# ╠═1e735495-ef76-433a-b3a4-dd787fa4f669
# ╠═3525308c-a7d7-4373-8826-f5a46a21c42a
# ╠═063d8376-2c3b-4d74-abe8-582fe6bd9d1d
# ╠═1cfc7eb7-a190-4072-9c3a-f3abac8befa7
# ╠═cdfa1d2a-baa0-4831-a6b1-69385efa8eb3
# ╠═383c54e5-9315-4b52-b77b-43f73dc252dd
# ╠═1a8a376d-6a66-4c77-b5f5-5929a1e330a5
# ╠═52ddb495-724a-4572-aa55-0f490ac77c40
# ╠═97d30320-ff55-4d2c-90bc-935ca233f1cc
# ╠═d9329375-5915-4868-96e2-4d9bf5594df7
# ╠═3e91edb7-3a29-4288-b8e0-826296e06d20
# ╠═0c89c8ad-7ee9-4dcf-8bc3-f3a1bf3f73a4
# ╠═4c9a553c-2319-4d22-9afb-5c35232e4c29
# ╠═e7e02789-bc11-449c-863a-86a604bfff00
# ╠═d349e5b1-6be3-4399-af82-3322529b20a5
# ╠═6a13b7fe-f12c-4518-a1df-9bbd55174765
# ╠═5872fbe3-702b-4ebf-8cc9-ec9322c4aa7b
# ╠═37c1b129-f631-472a-bba8-9e4766d5739f
# ╠═9a4b7cd3-c436-48ca-9d61-214f76b217fe
# ╠═468ca161-92f6-4f51-b1fb-7d3a14ca47b4
# ╠═c8224122-8307-46e4-85c9-82ed6591ba5b
# ╠═9125e779-2903-40bc-b2f0-57864f4defd2
# ╠═32c9e066-d734-4226-bcf9-c8f2e9aa01e0
# ╠═eaea893c-2d29-45fb-b63f-b866b9ca9b9f
# ╠═654fe84c-783f-421e-9680-85ab2435f5b6
# ╟─0e96533e-0420-4fd4-90ee-0786a2d98fe5
# ╠═06be8ac3-fa55-449d-ad3f-8162bd36c6b7
# ╠═b5ab10a0-d0c1-477e-8985-8cfbbc38fc6b
# ╠═9b80c3d6-ed15-499f-806b-6fa1091c417a
# ╠═b3656548-3be2-47ed-898e-3634003eee0b
