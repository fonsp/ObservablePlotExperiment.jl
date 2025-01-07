using HypertextLiteral

abstract type ObservableMark end



struct ObservableMarkLiteral <: ObservableMark
    x
end

get_js_content(oml::ObservableMarkLiteral) = oml.x

