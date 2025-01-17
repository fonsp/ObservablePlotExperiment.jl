# ObservablePlotExperiment.jl
Fast exploratory plotting – Julia wrapper for the [Observable Plot](https://observablehq.com/plot/) library.

The Observable library is amazing and the combination with Julia through HypertextLiteral.jl works crazy well!


# How to use

The aim of the library is to have API that is super close to the original [Observable Plot](https://observablehq.com/plot/) library. **Check out [their documentation](https://observablehq.com/plot/features/marks).**

# Some examples
Een paar voorbeelden

> ## Wil je deze voorbeelden in actie zien?
> Check de notebook `example.jl` in deze repo!!



## Lijntjes

```julia
data = rand(100)
```

Met de ["shorthand syntax"](https://observablehq.com/plot/features/shorthand) kan je super makkelijk een lijnplot maken!

```julia
lineY(data)
```


Dit is eigenlijk hetzelfde als:

```julia
line(enumerate(data))
```

(wat ook weer een shorthand syntax is). Je kan hier ook `dot` ipv `line` gebruiken voor een scatter plot!

```julia
dot(enumerate(data))
```

## Plot – combineren van marks

Met de `plot` functie kan je meerdere marks combineren tot een plot. Zie de docs voor Plot: https://observablehq.com/plot/features/plots



```julia
plot(
	lineY(data),
	dot(enumerate(data))
)
```

Of:

```julia
plot(
	(
		lineY(data .+ i)
		for i in 1:10
	)...,
)
```


## Opties


Je kan ook opties geven aan Marks of Plots. De Julia kwargs worden met HypertextLiteral.jl vanzelf omgezelf naar JS datastructuren, yay!

```julia
plot(
	# dot(enumerate(data); ),
	lineY(data; tip=false, marker=true),
	text(enumerate(data); 
		lineAnchor="bottom", 
		dy=-6,
		filter=peaks,
	),
	x=(label="index"),
	# y=(type="log",),
	height=200,
)
```



## JS in Julia – verschillende manieren!

De package ObservablePlotExperiments zorgt er dus vanzelf voor dat Julia datastructuren naar JavaScript worden omgezet zodat het door obsplots gebruikt kan worden.

Maar wat helemaal vet is – je kan ook mini-JS-dingetjes in je Julia code stoppen, die dan dus JS-Julia-JS gaan! En het werkt gewoon!

Hier is een voorbeeld uit `example.jl` waar ik op verschillende manieren dezelfde plot maak.


```julia
dates::Vector{Dates.Date}
```

```julia
vals::Vector{Float64}
```

Eerste manier:

```julia
cell(zip(dates[1:400], vals[1:400]); 
	x=@jsl("d => d[0].getUTCDate()"),
	y=@jsl("d => d[0].getUTCMonth()"),
	fy=@jsl("d => d[0].getUTCFullYear()"),
	fill=@jsl("d => d[1]"),	
)
```

Tweede manier:

```julia
cell(tidyzip(
	CO₂=vals[1:400], 
	month=month.(dates[1:400]),
	day=dayofmonth.(dates[1:400]),
	year=year.(dates[1:400])
); fill="CO₂", x="day", y="month", fy="year")
```

Hier gebruik ik de functie `tidyzip` uit deze package. Die werkt ongeveer zo:

```julia
tidyzip(x=[1,2,3],y=[6,7,8]) ==
    [
        (x=1, y=6),
        (x=2, y=7),
        (x=3, y=8),
    ]
```



# How was this package made?

Want to learn more how to write a package like this? Take a look at Pluto's JS documentation: https://plutojl.org/en/docs/advanced-widgets/ 

The source code for this package is actually super easy, take a look!



