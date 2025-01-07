


function tidyzip(; kwargs...)
    @jsl """(() => {
    	const flat = $(Dict(k => smart_embed_data.(v) for (k,v) in kwargs))
           const keys = Object.keys(flat)
           const values = Object.values(flat)
           
    	return _.map(_.zip(...values), (zipped) => _.zipObject(keys, zipped))
    })()"""
end