


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



dot(data; options...) = _call_Plot_funky(:dot, data, options)
dotX(data; options...) = _call_Plot_funky(:dotX, data, options)
dotY(data; options...) = _call_Plot_funky(:dotY, data, options)

line(data; options...) = _call_Plot_funky(:line, data, options)
lineX(data; options...) = _call_Plot_funky(:lineX, data, options)
lineY(data; options...) = _call_Plot_funky(:lineY, data, options)

