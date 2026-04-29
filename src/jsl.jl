module JSL

export @jsl


using HypertextLiteral


macro jsl(str_expr)
    QuoteNode(str_expr)

    quote
        result = @htl($(
            if str_expr isa String
                Expr(:string, "<script>", str_expr, "</script>")
            else
                Expr(:string, "<script>", esc_if_needed.(str_expr.args)..., "</script>")
            end
        ))
        RenderWithoutScriptTags(result)
    end

end

esc_if_needed(x::String) = x
esc_if_needed(x) = esc(x)



"The same as `IOContext(io)` but this one actually works. The implementation from Base only keeps the `:color` field..."
function context_from_anything(io::IO)
    IOContext(io, (k => get(io, k, nothing) for k in keys(io))...)
end



struct RenderWithoutScriptTags
    x
end

function Base.show(io::IO, m::MIME"text/javascript", r::RenderWithoutScriptTags)
    full_result = repr(MIME"text/html"(), r.x; context=context_from_anything(io))
    write(io, full_result[1+length("<script>"):end-length("</script>")])
end

# function Base.show(io::IO, m::MIME"text/javascript", rs::AbstractVector{RenderWithoutScriptTags})
#     write(io, "[")
#     for r in rs
#         show(io, m, r)
#         write(io, ",")
#     end
#     write(io, "]")
# end



end