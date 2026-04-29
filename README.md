# ObservablePlotExperiment.jl

> <img src="https://unpkg.com/ionicons@7.1.0/dist/svg/list-outline.svg" width="20" align="top"> Tip: use the table of contents button in the top right of this README to navigate!

Fast exploratory plotting – Julia wrapper for the [Observable Plot](https://observablehq.com/plot/) library.

This is a package for high-performance browser-based exploratory plotting in Julia. It installs super fast (<5 secs precompile).

The Observable library is amazing and the combination with Julia through HypertextLiteral.jl works crazy well!


# How to use

The aim of the library is to have API that is super close to the original [Observable Plot](https://observablehq.com/plot/) library. **Check out [their documentation](https://observablehq.com/plot/features/marks).**

# Some examples
A few examples

> ## Want to see these examples in action?
> Check the notebook `example.jl` in this repo!!



## Little lines

```julia
using ObservablePlotExperiment
```


```julia
data = rand(100)
```

With the ["shorthand syntax"](https://observablehq.com/plot/features/shorthand) you can super easily make a line plot!

```julia
lineY(data)
```


This is actually the same as:

```julia
line(enumerate(data))
```

(which is also a shorthand syntax). You can also use `dot` instead of `line` here for a scatter plot!

```julia
dot(enumerate(data))
```

## Plot – combining marks

With the `plot` function you can combine multiple marks into one plot. See the docs for Plot: https://observablehq.com/plot/features/plots



```julia
plot(
	lineY(data),
	dot(enumerate(data))
)
```

Or:

```julia
plot(
	(
		lineY(data .+ i)
		for i in 1:10
	)...,
)
```


## Options


You can also give options to Marks or Plots. The Julia kwargs get automatically converted to JS data structures with HypertextLiteral.jl, yay!

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



## JS in Julia – different ways!

The package ObservablePlotExperiments thus automatically takes care of converting Julia data structures to JavaScript so that it can be used by obsplots.

But what is totally awesome – you can also stick mini-JS-thingies into your Julia code, which then go JS-Julia-JS! And it just works!

Here is an example from `example.jl` where I make the same plot in different ways.


```julia
dates::Vector{Dates.Date}
vals::Vector{Float64}
```

First way:

```julia
cell(zip(dates[1:400], vals[1:400]); 
	x=@jsl("d => d[0].getUTCDate()"),
	y=@jsl("d => d[0].getUTCMonth()"),
	fy=@jsl("d => d[0].getUTCFullYear()"),
	fill=@jsl("d => d[1]"),	
)
```

Second way:

```julia
cell(tidyzip(
	CO₂=vals[1:400], 
	month=month.(dates[1:400]),
	day=dayofmonth.(dates[1:400]),
	year=year.(dates[1:400])
); fill="CO₂", x="day", y="month", fy="year")
```

Here I use the function `tidyzip` from this package. It works roughly like this:

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


