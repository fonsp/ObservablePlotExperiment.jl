# heyyyy lets also make a wrapper for https://github.com/observablehq/inspector why not :)


using HypertextLiteral

export inspect_js_value

function inspect_js_value(something_to_debug)
	@htl """
	$inspector_style
	<script id="insp">
	const { Inspector } = this?.insplib ?? await import("https://unpkg.com/@observablehq/inspector@5.0.1/src/index.js?module")
	
	const elem = this ?? document.createElement("span")
	const insp = elem.insp ?? new Inspector(elem)

	try {
		insp.fulfilled($(smart_embed_data(something_to_debug)))
	} catch(e) {
		insp.rejected(e)
		console.error(e)
	}

	elem.insp = insp
	elem.insplib = Inspector
	return elem
	</script>
	"""
end



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