


function _call_Plot_funky(function_name::Symbol, data, options)
    ObservableMarkLiteral(@jsl("""
     Plot.$(function_name)(
     	$(smart_embed_data(data)),
     	$(options),
     )
     """))
end



export dot, dotX, dotY
export line, lineX, lineY
export cell, cellX, cellY
export text, textX, textY


dot(data; options...) = _call_Plot_funky(:dot, data, options)
dotX(data; options...) = _call_Plot_funky(:dotX, data, options)
dotY(data; options...) = _call_Plot_funky(:dotY, data, options)

line(data; options...) = _call_Plot_funky(:line, data, options)
lineX(data; options...) = _call_Plot_funky(:lineX, data, options)
lineY(data; options...) = _call_Plot_funky(:lineY, data, options)


cell(data; options...) = _call_Plot_funky(:cell, data, options)
cellX(data; options...) = _call_Plot_funky(:cellX, data, options)
cellY(data; options...) = _call_Plot_funky(:cellY, data, options)


text(data; options...) = _call_Plot_funky(:text, data, options)
textX(data; options...) = _call_Plot_funky(:textX, data, options)
textY(data; options...) = _call_Plot_funky(:textY, data, options)

