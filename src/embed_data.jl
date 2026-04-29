import AbstractPlutoDingetjes
using Dates

smart_embed_data(x) = x

smart_embed_data(xs::Vector{<:TimeType}) = AbstractPlutoDingetjes.Display.published_to_js(convert.(DateTime, xs))

function smart_embed_data(xs::Vector{Float64})
    # TODO: find limit where this is faster
    if length(xs) > 10_000
        @jsl("Array.from($(AbstractPlutoDingetjes.Display.published_to_js(xs)))")
    else
        xs
    end
end

function smart_embed_data(z::Iterators.Zip)
    @jsl """_.zip(...$(smart_embed_data.(z.is)))"""
end

function smart_embed_data(z::Iterators.Enumerate)
    @jsl """$(smart_embed_data.(z.itr)).map((x, i) => [i, x])"""
end