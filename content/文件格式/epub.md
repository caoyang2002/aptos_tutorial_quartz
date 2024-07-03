---
title: epub 格式解析
---


@charset "utf-8";
/* Styles for Move-Aptos */
html {overflow-x: initial !important;}:root { --bg-color: #ffffff; --text-color: #333333; --select-text-bg-color: #B5D6FC; --select-text-font-color: auto; --monospace: "Lucida Console",Consolas,"Courier",monospace; --title-bar-height: 20px; }
.mac-os-11 { --title-bar-height: 28px; }
html { font-size: 14px; background-color: var(--bg-color); color: var(--text-color); font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; -webkit-font-smoothing: antialiased; }
h1, h2, h3, h4, h5 { white-space: pre-wrap; }
body { margin: 0px; padding: 0px; height: auto; inset: 0px; font-size: 1rem; line-height: 1.428571; overflow-x: hidden; background: inherit; }
iframe { margin: auto; }
a.url { word-break: break-all; }
a:active, a:hover { outline: 0px; }
.in-text-selection, ::selection { text-shadow: none; background: var(--select-text-bg-color); color: var(--select-text-font-color); }
#write { margin: 0px auto; height: auto; width: inherit; word-break: normal; overflow-wrap: break-word; position: relative; white-space: normal; overflow-x: visible; padding-top: 36px; }
#write.first-line-indent p { text-indent: 2em; }
#write.first-line-indent li p, #write.first-line-indent p * { text-indent: 0px; }
#write.first-line-indent li { margin-left: 2em; }
.for-image #write { padding-left: 8px; padding-right: 8px; }
body.typora-export { padding-left: 30px; padding-right: 30px; }
.typora-export .footnote-line, .typora-export li, .typora-export p { white-space: pre-wrap; }
.typora-export .task-list-item input { pointer-events: none; }
@media screen and (max-width: 500px) {
  body.typora-export { padding-left: 0px; padding-right: 0px; }
  #write { padding-left: 20px; padding-right: 20px; }
}
#write li > figure:last-child { margin-bottom: 0.5rem; }
#write ol, #write ul { position: relative; }
img { max-width: 100%; vertical-align: middle; image-orientation: from-image; }
button, input, select, textarea { color: inherit; font-style: inherit; font-variant-caps: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; font-size-adjust: inherit; font-kerning: inherit; font-variant-alternates: inherit; font-variant-ligatures: inherit; font-variant-numeric: inherit; font-variant-east-asian: inherit; font-variant-position: inherit; font-variant-emoji: inherit; font-feature-settings: inherit; font-optical-sizing: inherit; font-variation-settings: inherit; }
input[type="checkbox"], input[type="radio"] { line-height: normal; padding: 0px; }
*, ::after, ::before { box-sizing: border-box; }
#write h1, #write h2, #write h3, #write h4, #write h5, #write h6, #write p, #write pre { width: inherit; }
#write h1, #write h2, #write h3, #write h4, #write h5, #write h6, #write p { position: relative; }
p { line-height: inherit; }
h1, h2, h3, h4, h5, h6 { break-after: avoid-page; break-inside: avoid; orphans: 4; }
p { orphans: 4; }
h1 { font-size: 2rem; }
h2 { font-size: 1.8rem; }
h3 { font-size: 1.6rem; }
h4 { font-size: 1.4rem; }
h5 { font-size: 1.2rem; }
h6 { font-size: 1rem; }
.md-math-block, .md-rawblock, h1, h2, h3, h4, h5, h6, p { margin-top: 1rem; margin-bottom: 1rem; }
.hidden { display: none; }
.md-blockmeta { color: rgb(204, 204, 204); font-weight: 700; font-style: italic; }
a { cursor: pointer; }
sup.md-footnote { padding: 2px 4px; background-color: rgba(238, 238, 238, 0.7); color: rgb(85, 85, 85); border-radius: 4px; cursor: pointer; }
sup.md-footnote a, sup.md-footnote a:hover { color: inherit; text-transform: inherit; text-decoration: inherit; }
#write input[type="checkbox"] { cursor: pointer; width: inherit; height: inherit; }
figure { overflow-x: auto; margin: 1.2em 0px; max-width: calc(100% + 16px); padding: 0px; }
figure > table { margin: 0px; }
thead, tr { break-inside: avoid; break-after: auto; }
thead { display: table-header-group; }
table { border-collapse: collapse; border-spacing: 0px; width: 100%; overflow: auto; break-inside: auto; text-align: left; }
table.md-table td { min-width: 32px; }
.CodeMirror-gutters { border-right-width: 0px; border-right-style: none; border-right-color: currentcolor; background-color: inherit; }
.CodeMirror-linenumber { -webkit-user-select: none; }
.CodeMirror { text-align: left; }
.CodeMirror-placeholder { opacity: 0.3; }
.CodeMirror pre { padding: 0px 4px; }
.CodeMirror-lines { padding: 0px; }
div.hr:focus { cursor: none; }
#write pre { white-space: pre-wrap; }
#write.fences-no-line-wrapping pre { white-space: pre; }
#write pre.ty-contain-cm { white-space: normal; }
.CodeMirror-gutters { margin-right: 4px; }
.md-fences { font-size: 0.9rem; display: block; break-inside: avoid; text-align: left; overflow: visible; white-space: pre; background: inherit; position: relative !important; }
.md-fences-adv-panel { width: 100%; margin-top: 10px; text-align: center; padding-top: 0px; padding-bottom: 8px; overflow-x: auto; }
#write .md-fences.mock-cm { white-space: pre-wrap; }
.md-fences.md-fences-with-lineno { padding-left: 0px; }
#write.fences-no-line-wrapping .md-fences.mock-cm { white-space: pre; overflow-x: auto; }
.md-fences.mock-cm.md-fences-with-lineno { padding-left: 8px; }
.CodeMirror-line, twitterwidget { break-inside: avoid; }
svg { break-inside: avoid; }
.footnotes { opacity: 0.8; font-size: 0.9rem; margin-top: 1em; margin-bottom: 1em; }
.footnotes + .footnotes { margin-top: 0px; }
.md-reset { margin: 0px; padding: 0px; border: 0px; outline: 0px; vertical-align: top; background: 0px 0px; text-decoration: none; text-shadow: none; float: none; position: static; width: auto; height: auto; white-space: nowrap; cursor: inherit; line-height: normal; font-weight: 400; text-align: left; box-sizing: content-box; direction: ltr; }
li div { padding-top: 0px; }
blockquote { margin: 1rem 0px; }
li .mathjax-block, li p { margin: 0.5rem 0px; }
li blockquote { margin: 1rem 0px; }
li { margin: 0px; position: relative; }
blockquote > :last-child { margin-bottom: 0px; }
blockquote > :first-child, li > :first-child { margin-top: 0px; }
.footnotes-area { color: rgb(136, 136, 136); margin-top: 0.714rem; padding-bottom: 0.143rem; white-space: normal; }
#write .footnote-line { white-space: pre-wrap; }
@media print {
  body, html { border: 1px solid transparent; height: 99%; break-after: avoid; break-before: avoid; font-variant-ligatures: no-common-ligatures; }
  #write { margin-top: 0px; border-color: transparent !important; padding-top: 0px !important; padding-bottom: 0px !important; }
  .typora-export * { print-color-adjust: exact; }
  .typora-export #write { break-after: avoid; }
  .typora-export #write::after { height: 0px; }
  .is-mac table { break-inside: avoid; }
  #write > p:nth-child(1) { margin-top: 0px; }
  .typora-export-show-outline .typora-export-sidebar { display: none; }
  figure { overflow-x: visible; }
}
.footnote-line { margin-top: 0.714em; font-size: 0.7em; }
a img, img a { cursor: pointer; }
pre.md-meta-block { font-size: 0.8rem; min-height: 0.8rem; white-space: pre-wrap; background: rgb(204, 204, 204); display: block; overflow-x: hidden; }
p > .md-image:only-child:not(.md-img-error) img, p > img:only-child { display: block; margin: auto; }
#write.first-line-indent p > .md-image:only-child:not(.md-img-error) img { left: -2em; position: relative; }
p > .md-image:only-child { display: inline-block; width: 100%; }
#write .MathJax_Display { margin: 0.8em 0px 0px; }
.md-math-block { width: 100%; }
.md-math-block:not(:empty)::after { display: none; }
.MathJax_ref { fill: currentcolor; }
[contenteditable="true"]:active, [contenteditable="true"]:focus, [contenteditable="false"]:active, [contenteditable="false"]:focus { outline: 0px; box-shadow: none; }
.md-task-list-item { position: relative; list-style-type: none; }
.task-list-item.md-task-list-item { padding-left: 0px; }
.md-task-list-item > input { position: absolute; top: 0px; left: 0px; margin-left: -1.2em; margin-top: calc(1em - 10px); border: medium; }
.math { font-size: 1rem; }
.md-toc { min-height: 3.58rem; position: relative; font-size: 0.9rem; border-radius: 10px; }
.md-toc-content { position: relative; margin-left: 0px; }
.md-toc-content::after, .md-toc::after { display: none; }
.md-toc-item { display: block; color: rgb(65, 131, 196); }
.md-toc-item a { text-decoration: none; }
.md-toc-inner:hover { text-decoration: underline; }
.md-toc-inner { display: inline-block; cursor: pointer; }
.md-toc-h1 .md-toc-inner { margin-left: 0px; font-weight: 700; }
.md-toc-h2 .md-toc-inner { margin-left: 2em; }
.md-toc-h3 .md-toc-inner { margin-left: 4em; }
.md-toc-h4 .md-toc-inner { margin-left: 6em; }
.md-toc-h5 .md-toc-inner { margin-left: 8em; }
.md-toc-h6 .md-toc-inner { margin-left: 10em; }
@media screen and (max-width: 48em) {
  .md-toc-h3 .md-toc-inner { margin-left: 3.5em; }
  .md-toc-h4 .md-toc-inner { margin-left: 5em; }
  .md-toc-h5 .md-toc-inner { margin-left: 6.5em; }
  .md-toc-h6 .md-toc-inner { margin-left: 8em; }
}
a.md-toc-inner { font-size: inherit; font-style: inherit; font-weight: inherit; line-height: inherit; }
.footnote-line a:not(.reversefootnote) { color: inherit; }
.reversefootnote { font-family: ui-monospace, sans-serif; }
.md-attr { display: none; }
.md-fn-count::after { content: "."; }
code, pre, samp, tt { font-family: var(--monospace); }
kbd { margin: 0px 0.1em; padding: 0.1em 0.6em; font-size: 0.8em; color: rgb(36, 39, 41); background: rgb(255, 255, 255); border: 1px solid rgb(173, 179, 185); border-radius: 3px; box-shadow: rgba(12, 13, 14, 0.2) 0px 1px 0px, rgb(255, 255, 255) 0px 0px 0px 2px inset; white-space: nowrap; vertical-align: middle; }
.md-comment { color: rgb(162, 127, 3); opacity: 0.6; font-family: var(--monospace); }
code { text-align: left; vertical-align: initial; }
a.md-print-anchor { white-space: pre !important; border-width: medium !important; border-style: none !important; border-color: currentcolor !important; display: inline-block !important; position: absolute !important; width: 1px !important; right: 0px !important; outline: 0px !important; background: 0px 0px !important; text-decoration: initial !important; text-shadow: initial !important; }
.os-windows.monocolor-emoji .md-emoji { font-family: "Segoe UI Symbol", sans-serif; }
.md-diagram-panel > svg { max-width: 100%; }
[lang="flow"] svg, [lang="mermaid"] svg { max-width: 100%; height: auto; }
[lang="mermaid"] .node text { font-size: 1rem; }
table tr th { border-bottom-width: 0px; border-bottom-style: none; border-bottom-color: currentcolor; }
video { max-width: 100%; display: block; margin: 0px auto; }
iframe { max-width: 100%; width: 100%; border: medium; }
.highlight td, .highlight tr { border: 0px; }
mark { background: rgb(255, 255, 0); color: rgb(0, 0, 0); }
.md-html-inline .md-plain, .md-html-inline strong, mark .md-inline-math, mark strong { color: inherit; }
.md-expand mark .md-meta { opacity: 0.3 !important; }
mark .md-meta { color: rgb(0, 0, 0); }
@media print {
  .typora-export h1, .typora-export h2, .typora-export h3, .typora-export h4, .typora-export h5, .typora-export h6 { break-inside: avoid; }
}
.md-diagram-panel .messageText { stroke: none !important; }
.md-diagram-panel .start-state { fill: var(--node-fill); }
.md-diagram-panel .edgeLabel rect { opacity: 1 !important; }
.md-fences.md-fences-math { font-size: 1em; }
.md-fences-advanced:not(.md-focus) { padding: 0px; white-space: nowrap; border: 0px; }
.md-fences-advanced:not(.md-focus) { background: inherit; }
.typora-export-show-outline .typora-export-content { max-width: 1440px; margin: auto; display: flex; flex-direction: row; }
.typora-export-sidebar { width: 300px; font-size: 0.8rem; margin-top: 80px; margin-right: 18px; }
.typora-export-show-outline #write { --webkit-flex: 2; flex: 2 1 0%; }
.typora-export-sidebar .outline-content { position: fixed; top: 0px; max-height: 100%; overflow: hidden auto; padding-bottom: 30px; padding-top: 60px; width: 300px; }
@media screen and (max-width: 1024px) {
  .typora-export-sidebar, .typora-export-sidebar .outline-content { width: 240px; }
}
@media screen and (max-width: 800px) {
  .typora-export-sidebar { display: none; }
}
.outline-content li, .outline-content ul { margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px; list-style: none; overflow-wrap: anywhere; }
.outline-content ul { margin-top: 0px; margin-bottom: 0px; }
.outline-content strong { font-weight: 400; }
.outline-expander { width: 1rem; height: 1.428571rem; position: relative; display: table-cell; vertical-align: middle; cursor: pointer; padding-left: 4px; }
.outline-expander::before { content: ""; position: relative; font-family: Ionicons; display: inline-block; font-size: 8px; vertical-align: middle; }
.outline-item { padding-top: 3px; padding-bottom: 3px; cursor: pointer; }
.outline-expander:hover::before { content: ""; }
.outline-h1 > .outline-item { padding-left: 0px; }
.outline-h2 > .outline-item { padding-left: 1em; }
.outline-h3 > .outline-item { padding-left: 2em; }
.outline-h4 > .outline-item { padding-left: 3em; }
.outline-h5 > .outline-item { padding-left: 4em; }
.outline-h6 > .outline-item { padding-left: 5em; }
.outline-label { cursor: pointer; display: table-cell; vertical-align: middle; text-decoration: none; color: inherit; }
.outline-label:hover { text-decoration: underline; }
.outline-item:hover { border-color: rgb(245, 245, 245); background-color: var(--item-hover-bg-color); }
.outline-item:hover { margin-left: -28px; margin-right: -28px; border-left-width: 28px; border-left-style: solid; border-left-color: transparent; border-right-width: 28px; border-right-style: solid; border-right-color: transparent; }
.outline-item-single .outline-expander::before, .outline-item-single .outline-expander:hover::before { display: none; }
.outline-item-open > .outline-item > .outline-expander::before { content: ""; }
.outline-children { display: none; }
.info-panel-tab-wrapper { display: none; }
.outline-item-open > .outline-children { display: block; }
.typora-export .outline-item { padding-top: 1px; padding-bottom: 1px; }
.typora-export .outline-item:hover { margin-right: -8px; border-right-width: 8px; border-right-style: solid; border-right-color: transparent; }
.typora-export .outline-expander::before { content: "+"; font-family: inherit; top: -1px; }
.typora-export .outline-expander:hover::before, .typora-export .outline-item-open > .outline-item > .outline-expander::before { content: "−"; }
.typora-export-collapse-outline .outline-children { display: none; }
.typora-export-collapse-outline .outline-item-open > .outline-children, .typora-export-no-collapse-outline .outline-children { display: block; }
.typora-export-no-collapse-outline .outline-expander::before { content: "" !important; }
.typora-export-show-outline .outline-item-active > .outline-item .outline-label { font-weight: 700; }
.md-inline-math-container mjx-container { zoom: 0.95; }
mjx-container { break-inside: avoid; }
.md-alert.md-alert-note { border-left-color: rgb(9, 105, 218); }
.md-alert.md-alert-important { border-left-color: rgb(130, 80, 223); }
.md-alert.md-alert-warning { border-left-color: rgb(154, 103, 0); }
.md-alert.md-alert-tip { border-left-color: rgb(31, 136, 61); }
.md-alert.md-alert-caution { border-left-color: rgb(207, 34, 46); }
.md-alert { padding: 0px 1em; margin-bottom: 16px; color: inherit; border-left-width: 0.25em; border-left-style: solid; border-left-color: rgb(0, 0, 0); }
.md-alert-text-note { color: rgb(9, 105, 218); }
.md-alert-text-important { color: rgb(130, 80, 223); }
.md-alert-text-warning { color: rgb(154, 103, 0); }
.md-alert-text-tip { color: rgb(31, 136, 61); }
.md-alert-text-caution { color: rgb(207, 34, 46); }
.md-alert-text { font-size: 0.9rem; font-weight: 700; }
.md-alert-text svg { fill: currentcolor; position: relative; top: 0.125em; margin-right: 1ch; overflow: visible; }
.md-alert-text-container::after { content: attr(data-text); text-transform: capitalize; pointer-events: none; margin-right: 1ch; }


.CodeMirror { height: auto; }
.CodeMirror.cm-s-inner { background: inherit; }
.CodeMirror-scroll { overflow: auto hidden; z-index: 3; }
.CodeMirror-gutter-filler, .CodeMirror-scrollbar-filler { background-color: rgb(255, 255, 255); }
.CodeMirror-gutters { border-right-width: 1px; border-right-style: solid; border-right-color: rgb(221, 221, 221); background: inherit; white-space: nowrap; }
.CodeMirror-linenumber { padding: 0px 3px 0px 5px; text-align: right; color: rgb(153, 153, 153); }
.cm-s-inner .cm-keyword { color: rgb(119, 0, 136); }
.cm-s-inner .cm-atom, .cm-s-inner.cm-atom { color: rgb(34, 17, 153); }
.cm-s-inner .cm-number { color: rgb(17, 102, 68); }
.cm-s-inner .cm-def { color: rgb(0, 0, 255); }
.cm-s-inner .cm-variable { color: rgb(0, 0, 0); }
.cm-s-inner .cm-variable-2 { color: rgb(0, 85, 170); }
.cm-s-inner .cm-variable-3 { color: rgb(0, 136, 85); }
.cm-s-inner .cm-string { color: rgb(170, 17, 17); }
.cm-s-inner .cm-property { color: rgb(0, 0, 0); }
.cm-s-inner .cm-operator { color: rgb(152, 26, 26); }
.cm-s-inner .cm-comment, .cm-s-inner.cm-comment { color: rgb(170, 85, 0); }
.cm-s-inner .cm-string-2 { color: rgb(255, 85, 0); }
.cm-s-inner .cm-meta { color: rgb(85, 85, 85); }
.cm-s-inner .cm-qualifier { color: rgb(85, 85, 85); }
.cm-s-inner .cm-builtin { color: rgb(51, 0, 170); }
.cm-s-inner .cm-bracket { color: rgb(153, 153, 119); }
.cm-s-inner .cm-tag { color: rgb(17, 119, 0); }
.cm-s-inner .cm-attribute { color: rgb(0, 0, 204); }
.cm-s-inner .cm-header, .cm-s-inner.cm-header { color: rgb(0, 0, 255); }
.cm-s-inner .cm-quote, .cm-s-inner.cm-quote { color: rgb(0, 153, 0); }
.cm-s-inner .cm-hr, .cm-s-inner.cm-hr { color: rgb(153, 153, 153); }
.cm-s-inner .cm-link, .cm-s-inner.cm-link { color: rgb(0, 0, 204); }
.cm-negative { color: rgb(221, 68, 68); }
.cm-positive { color: rgb(34, 153, 34); }
.cm-header, .cm-strong { font-weight: 700; }
.cm-del { text-decoration: line-through; }
.cm-em { font-style: italic; }
.cm-link { text-decoration: underline; }
.cm-error { color: red; }
.cm-invalidchar { color: red; }
.cm-constant { color: rgb(38, 139, 210); }
.cm-defined { color: rgb(181, 137, 0); }
div.CodeMirror span.CodeMirror-matchingbracket { color: rgb(0, 255, 0); }
div.CodeMirror span.CodeMirror-nonmatchingbracket { color: rgb(255, 34, 34); }
.cm-s-inner .CodeMirror-activeline-background { background: inherit; }
.CodeMirror { position: relative; overflow: hidden; }
.CodeMirror-scroll { height: 100%; outline: 0px; position: relative; box-sizing: content-box; background: inherit; }
.CodeMirror-sizer { position: relative; }
.CodeMirror-gutter-filler, .CodeMirror-hscrollbar, .CodeMirror-scrollbar-filler, .CodeMirror-vscrollbar { position: absolute; z-index: 6; display: none; outline: 0px; }
.CodeMirror-vscrollbar { right: 0px; top: 0px; overflow: hidden; }
.CodeMirror-hscrollbar { bottom: 0px; left: 0px; overflow: auto hidden; }
.CodeMirror-scrollbar-filler { right: 0px; bottom: 0px; }
.CodeMirror-gutter-filler { left: 0px; bottom: 0px; }
.CodeMirror-gutters { position: absolute; left: 0px; top: 0px; padding-bottom: 10px; z-index: 3; overflow-y: hidden; }
.CodeMirror-gutter { white-space: normal; height: 100%; box-sizing: content-box; padding-bottom: 30px; margin-bottom: -32px; display: inline-block; }
.CodeMirror-gutter-wrapper { position: absolute; z-index: 4; background: 0px 0px !important; border: medium !important; }
.CodeMirror-gutter-background { position: absolute; top: 0px; bottom: 0px; z-index: 4; }
.CodeMirror-gutter-elt { position: absolute; cursor: default; z-index: 4; }
.CodeMirror-lines { cursor: text; }
.CodeMirror pre { border-radius: 0px; border-width: 0px; background: 0px 0px; font-family: inherit; font-size: inherit; margin: 0px; white-space: pre; overflow-wrap: normal; color: inherit; z-index: 2; position: relative; overflow: visible; }
.CodeMirror-wrap pre { overflow-wrap: break-word; white-space: pre-wrap; word-break: normal; }
.CodeMirror-code pre { border-right-width: 30px; border-right-style: solid; border-right-color: transparent; width: fit-content; }
.CodeMirror-wrap .CodeMirror-code pre { border-right-width: medium; border-right-style: none; border-right-color: currentcolor; width: auto; }
.CodeMirror-linebackground { position: absolute; inset: 0px; z-index: 0; }
.CodeMirror-linewidget { position: relative; z-index: 2; overflow: auto; }
.CodeMirror-wrap .CodeMirror-scroll { overflow-x: hidden; }
.CodeMirror-measure { position: absolute; width: 100%; height: 0px; overflow: hidden; visibility: hidden; }
.CodeMirror-measure pre { position: static; }
.CodeMirror div.CodeMirror-cursor { position: absolute; visibility: hidden; border-right-width: medium; border-right-style: none; border-right-color: currentcolor; width: 0px; }
.CodeMirror div.CodeMirror-cursor { visibility: hidden; }
.CodeMirror-focused div.CodeMirror-cursor { visibility: inherit; }
.cm-searching { background: rgba(255, 255, 0, 0.4); }
span.cm-underlined { text-decoration: underline; }
span.cm-strikethrough { text-decoration: line-through; }
.cm-tw-syntaxerror { color: rgb(255, 255, 255); background-color: rgb(153, 0, 0); }
.cm-tw-deleted { text-decoration: line-through; }
.cm-tw-header5 { font-weight: 700; }
.cm-tw-listitem:first-child { padding-left: 10px; }
.cm-tw-box { border-style: solid; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-color: inherit; border-top-width: 0px !important; }
.cm-tw-underline { text-decoration: underline; }
@media print {
  .CodeMirror div.CodeMirror-cursor { visibility: hidden; }
}


/* 使用外部字体 */
/* @include-when-export url(https://fonts.loli.net/css?family=Open+Sans:400italic,700italic,700,400&subset=latin,latin-ext); */

/*
Typora关键词说明：
font-face：字体初始化设置（导入及配置基本信息）
:root：根信息
content：内容区域
#write：页面区域
#typora-source：源码模式
*/

/*
========================css说明=========================

-----------------------margin--------------------------
margin：外边距，最多有四个参数，依次是 上、右、下、左
- margin-top，margin-right，margin-bottom，和 margin-left 四个外边距属性设置的简写。
- 参数：像素px、rem相对HTML根元素字体大小、em相对当前对象内文本的字体尺寸、%百分比、

应用于所有边 
margin: 1em;
margin: -3px;

上边下边 | 左边右边 
margin: 5% auto;

上边 | 左边右边 | 下边 
margin: 1em auto 2em;

上边 | 右边 | 下边 | 左边 
margin: 2px 1em 0 auto;

全局值 
margin: inherit;
margin: initial;
margin: unset;







--------------------------------box-shadow------------------------------

x 偏移量 | y 偏移量 | 阴影颜色 
box-shadow: 60px -16px teal;

x 偏移量 | y 偏移量 | 阴影模糊半径 | 阴影颜色 
box-shadow: 10px 5px 5px black;

x 偏移量 | y 偏移量 | 阴影模糊半径 | 阴影扩散半径 | 阴影颜色 
box-shadow: 2px 2px 2px 1px rgba(0, 0, 0, 0.2);

插页 (阴影向内) | x 偏移量 | y 偏移量 | 阴影颜色 
box-shadow: inset 5em 1em gold;

任意数量的阴影，以逗号分隔 
box-shadow: 3px 3px red, -1em 0 0.4em olive;

/* 全局关键字 
box-shadow: inherit;
box-shadow: initial;
box-shadow: unset;


-----------------------padding--------------------------
padding：内边距。控制元素所有四条边的内边距区域
参数和使用同margin 但是不能使用负数

应用于所有边 
padding: 1em;

上边下边 | 左边右边 
padding: 5% 10%;

上边 | 左边右边 | 下边 
padding: 1em 2em 2em;

上边 | 右边 | 下边 | 左边 
padding: 5px 1em 0 2em;

全局值
padding: inherit;
padding: initial;
padding: unset;




-----------------------min-height-----------------------
CSS 属性 min-height 能够设置元素的最小高度。这样能够防止 height 属性的应用值小于 min-height 的值
当 min-height 大于 max-height 或 height 时，元素的高度会设置为 min-height 的值。
<长度> 数值
min-height: 3.5em;

<百分比> 数值
min-height: 10%;

关键词
min-height: max-content;
min-height: min-content;
min-height: fit-content(20em);

全局数值
min-height: inherit;
min-height: initial;
min-height: unset;

-----------------------!important-----------------------
增加样式的权重
与优先级无关，但它与最终的结果直接相关，使用一个 !important 规则时，此声明将覆盖任何其他声明。



------------------------webkit-font-smoothing-----------------------

Webkit 实现了名为 -webkit-font-smoothing 的相似属性。该属性仅适用于 macOS。
auto——由浏览器决定（如果可用，则使用亚像素抗锯齿；这是默认值）。
none——关闭字体平滑；显示带有锯齿边缘的文本。
antialiased——在像素（而不是亚像素）级别平滑字体。对于深色背景上的浅色文本，从亚像素渲染切换为抗锯齿渲染可以使其看起来更清晰。
subpixel-antialiased——在大多数非视网膜显示器上，这将会提供最清晰的文本。


------------------------渐变-----------------------
CSS 渐变 <image> 类型的一种特殊类型 <gradient> 表示，由两种或多种颜色之间的渐进过渡组成。
您可以选择三种类型的渐变：
线性 (由 linear-gradient() (en-US) 函数创建)，
径向 (由 radial-gradient() (en-US) 函数创建) 
圆锥 (由 conic-gradient() (en-US) 函数创建)。
您还可以使用 repeating-linear-gradient() (en-US) 和 repeating-radial-gradient() (en-US) 函数创建重复渐变。

默认上至下
.simple-linear {
  background: linear-gradient(blue, pink);
}
改为左至右
.horizontal-gradient {
  background: linear-gradient(to right, blue, pink);
}
设置角度
.angled-gradient {
  background: linear-gradient(70deg, blue, pink);
}
多颜色
.auto-spaced-linear-gradient {
  background: linear-gradient(red, yellow, blue, orange);
}
颜色范围（渐变长度）
.multicolor-linear {
   background: linear-gradient(to left, lime 28px, red 77%, cyan);
}
实线分割
.striped {
   background: linear-gradient(to bottom left, cyan 50%, palegoldenrod 50%);
}


------------------------border-radius------------------------
border-radius: 1-4 length|% / 1-4 length|%;
注意: 每个半径的四个值的顺序是：左上角，右上角，右下角，左下角。如果省略左下角，右上角是相同的。如果省略右下角，左上角是相同的。如果省略右上角，左上角是相同的。

椭圆边框
border-radius: 15px 50px 30px 5px
第一个值适用于左上角，第二个值适用于右上角，第三个值适用于右下角，第四个值适用于左下角

椭圆边框
border-radius: 15px 50px 30px
第一个值适用于左上角，第二个值适用于右上角和左下角，第三个值适用于右下角：

椭圆边框
border-radius: 15px 50px
第一个值适用于左上角和右下角，第二个值适用于右上角和左下角

椭圆边框
border-radius: 15px
该值适用于所有四个角，均等圆角

border-radius: 2em 1em 4em / 0.5em 3em;
border-radius: 50% 20% / 10% 40%;

border: dashed;
border-width: 2px 4px;
border-radius: 40px;



------------------------@media------------------------
@media 规则在媒体查询中用于为不同的媒体类型/设备应用不同的样式。
媒体类型（Media type）描述设备的一般类别。除非使用 not 或 only 逻辑操作符，媒体类型是可选的，并且会（隐式地）应用 all 类型。
all
适用于所有设备。
print
适用于在打印预览模式下在屏幕上查看的分页材料和文档。（有关特定于这些格式的格式问题的信息，请参阅分页媒体。）
screen
主要用于屏幕。

如果浏览器窗口的宽度为 600px 或更小时，把 <body> 元素的背景颜色更改为“浅蓝色”：
@media only screen and (max-width: 600px) {
  body {
    background-color: lightblue;
  }
}


------------------------鼠标形状------------------------
大家在访问网页时是不是发现鼠标形状有时候是箭头形状、有时候又是手势形状、或者Ⅰ字形，这些效果都是通过css中的cursor属性设置的各式各样的鼠标指针样式。cursor属性可以在任何选择器中使用，来改变各种页面元素的鼠标指针效果。

default：默认光标，箭头形；
pointer：超链接光标，手指形；
wait：指示程序正忙，通常是一只表或沙漏；
help：指示可用的帮助，通常是一个问号或一个气球；
text：指示文本；
crosshair：鼠标呈现十字状；

*/

/* 颜色配置 方便后面直接调用 */
:root {
    /* dy color */
    --select-text-bg-color: #d6d8b6;
    /* 文本选中背景色 */
    /*--primary-color: red;/*
    /*--bg-color: #262626; /* 整体背景色 */
    /*--sidebarbg-color: #1a1a1a; /* 侧边栏背景色 */
    --focus-color: #ff5d52;
    /* 点击某些元素（如标题）显示的颜色 */
    --titlebefore-color: #00c4b6;
    /* 各级标题点缀颜色 */

    /* ------------------------------------------------------------------------------代码块 */
    --codeblockbg-color: rgb(251, 246, 235);
    /* 代码块背景色 */
    --codeblockbg-color-mini: rgba(245, 241, 232, 1);
    /* 代码块背景色,小窗模式 */
    --codeblockfont-color: #a9a9a9;
    /* 代码块默认字体颜色 */
    --codeblockline-color: #e1efb7;
    /* 代码块选中行颜色（鼠标悬浮、选中） */
    --codeblocknum-color: rgba(128, 128, 255, 0.8);
    /* 代码块行编号颜色 */


    /* -----------------------------------------------------------------------------引用块 */
    --blockquoteicon-color: #a0a0a0;
    /* blockquote提示图标色 */
    --blockquotebg-color: #eaeaea;
    /* blockquote背景色 */
    --blockquotedangericon-color: #ea3c39;
    /* 危险型blockquote提示图标色 */
    --blockquotedangerbg-color: #f5848e;
    /* 危险型blockquote背景色 */
    --blockquotesuccessicon-color: #5cb85c;
    /* 成功型blockquote提示图标色 */
    --blockquotesuccessbg-color: #e2ffd9;
    /* 成功型blockquote背景色 */
    --blockquotewarnicon-color: #faa226;
    /* 警告型blockquote提示图标色 */
    --blockquotewarnbg-color: #e9d197;
    /* 警告型blockquote背景色 */
    --blockquotequestionicon-color: #f7ff0c;
    /* 问题型blockquote提示图标色 */
    --blockquotequestionbg-color: #f8fba9;
    /* 问题型blockquote背景色 */


    /* -----------------------------------------------------------------------------列表 */
    --ulol-color: #8b8b8b;
    /* 有序无序列表前缀颜色 */
    --olfore-color: white;
    /* 有序列表字体颜色 */

    /* -----------------------------------------------------------------------------表格 */
    --tableevenrow-color: #1a1a1a;
    /* 表格偶数行颜色 */
    --tablefocusrow-color: #263238;
    /* 表格鼠标悬停行颜色 */
    --tableborder-color: #2f642e;
    /* 表格边框色 */
    --tablethbg-color: #2f845e;
    /* 表格表头背景色 */

    /* -----------------------------------------------------------------------------滚动条 */
    --scrollbar-color: #2f845e;
    /* 滚动条颜色 */

    /* -----------------------------------------------------------------------------目录 */
    --toc-color: #00a0a0;
    /* 目录颜色 */

    /* -----------------------------------------------------------------------------超链接 */
    --atext-color: #a9a9a9;
    /* 超链接文本颜色 */
    --ahover-color: black;
    /* 超链接悬停文本颜色 */
    --abottom-color: #81d8cf;
    /* 超链接下划线颜色 */

    /* -----------------------------------------------------------------------------行内代码 */
    --code-color: #2e1c05;
    /* 行内代码字体色 */
    --codebg-color: #feffec;
    /* 行内代码背景色 */

    /* -----------------------------------------------------------------------------脚注 */
    --footnote-color: #e96900;
    /* 脚注上标前景色 */
    --footnotebg-color: #f8f8f8;
    /* 脚注上标背景色 */

    /* ----------------------------------------------------------------------------- 高亮文本 */
    --highlight-color: rgb(71, 4, 4);
    /* 高亮文本前景色 */
    --highlightbg-color: rgb(255, 255, 0);
    /* 高亮文本背景色 */

    /* -----------------------------------------------------------------------------分割线 */
    --split-color: #7e7e7e;
    /* 分割线颜色 */



    /* -----------------------------------------------------------------------------任务列表 */
    --taskborder-color: rgb(235, 127, 127);
    /* 任务列表边框色 */
    --taskfocus-color: #7bd7d1;
    /* 任务列表选中填充色 */
    --taskftext-color: rgb(112, 112, 112);
    /* 任务完成字体色*/

    /* -----------------------------------------------------------------------------小标签 */
    --spannote-color: #e91e64;
    /* 小标签背景色 */
    /* -----------------------------------------------------------------------------强调文本 */
    --emptext-color: #fe5f58;
    /* 几款强调型文本的颜色 */
    --hidetextcover-color: #a1a1a1;
    /* 隐藏文本遮罩颜色 */
    --hidetext-color: #a9a9a9;
    /* 隐藏文本颜色 */

    --spanbtn-color: #44d7b6;
    /* 文本按钮颜色 */
    --detailstxt-color: black;
    /* 折叠框summary文字颜色 */
    --detailsbg-color: #fbffe7;
    /* 折叠框summary背景色 */
    --detailsborder-color: #5fa7e4;
    /* 折叠框边框色 */

    --body-color: #e6e6e6;
    /* 文本颜色 */
    --para-color: #a9a9a9;
    /* 段落文本颜色 */
    --commonstr-color: #a9a9a9;
    /* 常规字符串颜色 */
    --commonstrbg-color: #263238;
    /* 常规字符串背景色 */
    --timebodybg-color: #a0a0a0;
    /* 时间轴主体部分背景色 */

    /* -----------------------------------------------------------------------------侧边栏 */
    --sidelist-selected-color: #263238;
    /* 侧边栏条目选中背景色 */

    /* -----------------------------------------------------------------------------YAML */
    --yamlbg-color: #1a1a1a;
    /* 头部YAML背景色 */
    --yaml-color: #7f9bb7;
    /* 头部YAML字体颜色 */

    /* -----------------------------------------------------------------------------编辑区域 */
    --page-color: rgba(225, 225, 225, 0);
    /* 透明 */
    --page-color-mini: #fffefc;
    /* 小窗 编辑区域（纸张）颜色 */

    /* dy font */
    --body-font: 'Source Sans Pro', '等距更纱黑体 SC', 'Helvetica Neue', Arial, sans-serif;
    /* 全局字体 */
    --code-font: 'JetBrains Mono';
    /* 代码块以及行内代码字体 */
    /* bg image */
    /* -----------------------------------------------------------------------------背景图片 */
    --bgimg-url: url(file:///Users/caoyang/Library/Application%20Support/abnerworks.Typora/themes/thompsgo/background_img.jpeg);
    /* -----------------------------------------------------------------------------文本颜色 */
    --text-color: #1f0909;
    --control-text-color: #777;
    /* --side-bar-bg-color: #fafafa;  */

    /* --------------------------------------------------------------------------------标题下划线颜色 */
    --border-bottom-h1: #160c01;
    --border-bottom-h2: #251504;
    --border-bottom-h3: #34220e;
    --border-bottom-h4: #473420;
    --border-bottom-h5: #5b4835;
    --border-bottom-h6: #6d5c4b;
    /* ----------------------------------------------------------------------------------标题文字颜色 */
    --font-h1: #130701;
    --font-h2: #190c01;
    --font-h3: #1f1303;
    --font-h4: #261305;
    --font-h5: #2d1a08;
    --font-h6: #34210a;

    /* -------------------------------------------------------------------------------------KBD按键颜色 */
    --kbdbg-color: #2f1d02;
    /* 背景颜色 */
    --kbd-color: #02081b;
    /* 字体颜色 */
    --kbd-shadow: #3928064e;
    /*投影颜色*/
}



/* ----------------------------------------字体初始化配置----------------------------------------- */
/* 普通字体 */
/* 斜体 */
/* 粗体 */
/* 斜粗体*/
/* 代码块字体 */
/* 源代码字体 */
/* 其它字体 */
/* ------------------------------------------------------------------------字体配置结束--------------------------------------------------------------------------- */


/* 设置文本输入区域的背景 */
content {
    background-image: var(--bgimg-url);
    /* 图片尺寸：第一个值指定图片的宽度，第二个值指定图片的高度 */
    background-size: 50% auto;
    /* 设置图片是否重复*/
    background-repeat: repeat;
}


/* -------------------------------------------------------------------区域及布局配置-------------------------------------------------------------------- */

/* 内容输入区域的设置 */
#write {
    /* 最大宽度 */
    max-width: 96%;
    /*auto or 100% or 1000px*/
    /* 外边距 */
    margin: 0 auto;
    /* 内边距 */
    padding: 66px 36px;
    /* 内边距区域中下方的高度 */
    /* padding-bottom: 36px; */
    /* 左边增加120像素 */

}

/** 透明页面 **/
#write,
#typora-source {
    /* 位置：相对定位 */
    position: relative;
    /* 外边距 */
    /* margin: auto 1rem; */
    margin: auto 10px auto 15px;
    /* 设置宽度 */
    width: 100%;
    /* 设置元素的最小高度。这样能够防止 height 属性的应用值小于 min-height 的值 */
    min-height: 100vh;

    /* 背景颜色    一个bug：即便设置了颜色也不会显示 */
    background-color: var(--page-color);

    /* 控制元素所有四条边的内边距区域 */
    /* padding: 1cm 0; */

    /* 定义应该如何计算一个元素的总宽度和总高度 */
    /*box-sizing: border-box;/* 要设置的边框和内边距的值是包含在 width 内的 */

    /* 当内容溢出块级元素的上下两侧时所显示的内容。可以不显示，或者显示滚动条或溢出内容。 */
    overflow-y: hide;

    /* 用于在元素的框架上添加阴影效果 */
    /* box-shadow: inset 0cm -0cm 0.1cm 0.05cm rgba(0, 0, 0, 0.1); */

    /* 设置元素的子元素是位于 3D 空间中还是平面中 */
    transform-style: preserve-3d;
}

/* -------------------------------------------------------------------区域及布局配置结束-------------------------------------------------------------------- */


/* ------------------------------------------源代码模式配置------------------------------------------ */
/* 源代码模式的宽度 */
#typora-source .CodeMirror-lines {
    width: 100%;
    max-width: 95%;
    /*auto or 100% or 1000px*/
}

/* 源代码字体 */
#typora-source {
    font-family: "Chill G Sans";
    font-size: inherit;
}

/* typora源代码模式 */
#typora-source {
    width: 100%;
    /* 设置内部左边边距 */
    padding-left: 4px;
    padding-right: 60px;
    /* 字体族 */
    font-family: "Chill G Sans";
}

/* ----------------------------------------------------------源代码配置结束----------------------------------------------------------- */


/* -----------------------------------------------------------html（全局）内字体--------------------------------------------------------------- */
/* 由于html标签在最外层，所以有修改全局的效果*/
/* 不建议修改 */
html {
    /* 字体大小 */
    font-size: 16px;
    /*  Webkit 实现了名为 -webkit-font-smoothing 的相似属性。该属性仅适用于 macOS */
    -webkit-font-smoothing: antialiased;
    /* 像素级 */

}


/* ------------------------------------------------------侧边栏配置------------------------------------------------------ */
/* 设置大纲区域样式（背景、字体） */
body {
    /* 编辑区以外的样式 */
    /* background-color: #8F9D9A;  */
    /* 更改输入的字体  系统字体可以直接输入， */
    font-family: '975 朦胧黑体', Courier, sans-serif;
    /* sans-serif是无衬线字体，是一种通用字体族。大多数计算机都有这种字体，如果特定的字体不存在将会调用此字体显示 */
    /* color: rgb(51, 51, 51); */
    line-height: 1.6;
    background-image: var(--bgimg-url);
    /* 背景尺寸 */
    background-size: 50%;
    background-repeat: repeat;
    /* 所有代码块、内联代码和源代码模式的字体 */
    --monospace: 'Hack'
    /* #md-fences {
        code block only 
      } */
}

/* ------------------------------------------------------侧边栏结束------------------------------------------------------ */



/* ------------------------------------------------------------------------页面元素配置------------------------------------------------------------------------- */

/* 渐变水平线 */
hr {
    /* 宽度 */
    width: 100%;
    /* 外边距 */
    margin: 0 auto;
    /* 水平居中，水平方向的 auto，其计算值取决于可用空间（剩余空间）*/

    /* 设置单独的边界属性的简写属性 */
    /* border: 5rem outset pink;
    outline: 0.5rem solid khaki;
    box-shadow: 0 0 0 2rem skyblue;
    border-radius: 12px;
    margin: 2rem;
    padding: 1rem;
    outline-offset: 0.5rem; */

    /* 高度 */
    height: 2px;
    /* 水平线的颜色 */
    background-color: var(--split-color);
    /* 背景图片（作为渐变使用） */
    /* background-image: linear-gradient(to right, rgb(164, 164, 164), rgb(220, 220, 220)); */
}

/* ------------------------------------------------------------------------页面元素配置结束------------------------------------------------------------------------- */



/* -----------------------------------========================图片样式====================--------------------------------- */
img {
    filter: brightness(100%);
    /* 修改所有图片明度，100%为不修改 */
}

/* 图片导入的初始设置 */
.md-image img {
    /* 最大宽度 */
    max-width: 1000px;
    height: auto;
    width: 100%;
    margin: 40px auto;
}

/* 圆 */
.md-image img[alt='circle'],
[alt='圆'] {
    border-radius: 50%;
    box-shadow: 0px 10px 20px 1px rgba(0, 0, 0, .3);
    border: 3px solid #e4e4e4;
}

/* 自适应缩放 */
.md-image img[alt='zoom'],
[alt='缩'] {
    zoom: 60%;
}

/* 阴影圆角 */
.md-image img[alt='shadow'],
[alt='阴影'] {
    border-radius: 12px;
    box-shadow: 0px 20px 40px 1px rgba(0, 0, 0, .3);
    border: 1px solid #e4e4e4;
}

/* 虚线 */
.md-image img[alt='dline'],
[alt='虚线'] {
    border-radius: 12px;
    box-shadow: 0px 20px 40px 1px rgba(0, 0, 0, .3);
    border: 1px solid #e4e4e4;
    border: dashed;
    border-width: 2px 4px;
    border-radius: 40px;
}

/* 线 */
.md-image img[alt='line'],
[alt='线'] {
    border-radius: 12px;
    box-shadow: 0px 20px 40px 1px rgba(0, 0, 0, .3);
    border: 0.2rem solid #e4e4e4;

}

/* 阴影圆角和自适应缩放 */
.md-image img[alt='zoom-shadow'],
img[alt='shadow-zoom'],
img[alt='圆角-阴影'],
img[alt='阴影-圆角'] {
    zoom: 60%;
    border-radius: 2rem;
    border: 1px solid #e4e4e4;
    box-shadow: 0px 20px 40px 1px rgba(0, 0, 0, .3);
}

/* 色彩反转 */
.md-image img[alt='rev'],
[alt='反'] {
    border-radius: 12px;
    box-shadow: 0px 20px 40px 1px rgba(0, 0, 0, .3);
    border: 0.2rem solid #e4e4e4;
    filter: hue-rotate(90deg);
}

/* 透明度 */
.md-image img[alt='opa'],
[alt='半透'] {
    border-radius: 12px;
    box-shadow: 0px 20px 40px 1px rgba(0, 0, 0, .3);
    border: 0.2rem solid #e4e4e4;
    filter: opacity(50%)
}

/* 毛玻璃效果 */
.md-image img[alt='glazing'],
[alt='gla'],
[alt='毛玻璃'] {
    border-radius: 12px;
    box-shadow: 0px 20px 40px 1px rgba(0, 0, 0, .3);
    border: 0.2rem solid #e4e4e4;
    filter: blur(15px);
}

/* 模糊特效 */
.md-image img[alt='blur'] {
    filter: blur(6px);
    -webkit-filter: blur(6px);
    -moz-filter: blur(6px);
    -ms-filter: blur(6px);
    -o-filter: blur(6px);
    transition: all 0.2s linear;
}

.md-image img[alt='blur']:hover {
    filter: none;
    -webkit-filter: none;
    -moz-filter: none;
    -ms-filter: none;
    -o-filter: none;
}

/*图片单色特效*/
.md-image img[alt|='gray'] {
    filter: grayscale(100%);
}

.md-image img[alt|='gray']:hover {
    transition: 0.5s linear;
    filter: grayscale(0);
}

/* 图片自动编号 */
#write {
    counter-reset: imgNum;
}

#write p>.md-image:after {
    counter-increment: imgNum;
    content: "图" counter(imgNum) attr(alt) !important;
    text-align: center;
    width: 100%;
    display: inline-block;
    margin-top: 8px !important;
    font-size: small;
}

/* ----------------------------------------------------------------图片样式结束--------------------------------------------------------------------------- */


#write>ul:first-child,
#write>ol:first-child {
    margin-top: 30px;
}


/* ------------------------------------------------------------------超链接------------------------------------------------------------------------- */
a {
    color: #4183C4;
    /* 似乎无效，也不建议这样用 */
    /* text-decoration:none； */
}

a:link {
    /*默认状态*/
    color: #4183C4;
    text-decoration: none；
}

a:visited {
    /*浏览过的*/
    color: rgb(125, 125, 125);
    /* 似乎无效 */
}

a:hover {
    /*悬浮状态*/
    color: rgb(162, 162, 38);
}

a:active {
    /*激活过的*/
    color: red;
}

/* ------------------------------------------------------------------超链接结束------------------------------------------------------------------------- */


/* -----------------------------------------------------------------------标题配置----------------------------------------------------------------------- */

/* h1 {
    text-transform: uppercase;
  } 大写*/
/* h4 {
  font-variant: small-caps;
    }小写 */
h1,
h2,
h3,
h4,
h5,
h6 {
    position: relative;
    margin-top: 1rem;
    margin-bottom: 1rem;
    font-weight: bold;
    line-height: 1.4;
    cursor: text;
    /* 中心对其 */
    /* text-align:center; */
}

/* ------------------------------------------------未知----------------------------------------------------------- */
h1:hover a.anchor,
h2:hover a.anchor,
h3:hover a.anchor,
h4:hover a.anchor,
h5:hover a.anchor,
h6:hover a.anchor {
    text-decoration: none;
}

h1 tt,
h1 code {
    font-size: inherit;
}

h2 tt,
h2 code {
    font-size: inherit;
}

h3 tt,
h3 code {
    font-size: inherit;
}

h4 tt,
h4 code {
    font-size: inherit;
}

h5 tt,
h5 code {
    font-size: inherit;
}

h6 tt,
h6 code {
    font-size: inherit;
}


/* ---------------------------------------------------------标题------------------------------------------------- */
h1 {
    font-size: 2.8em;
    /* 行高 */
    line-height: 1.3;
    color: var(--font-h1);
    border-bottom: thick double var(--border-bottom-h1);
}

h2 {
    font-size: 2.3em;
    line-height: 1.225;
    color: var(--font-h2);
    border-bottom: 4px double var(--border-bottom-h2);
}

/*@media print {
    .typora-export h1,
    .typora-export h2 {
        border-bottom: none;
        padding-bottom: initial;
    }

    .typora-export h1::after,
    .typora-export h2::after {
        content: "";
        display: block;
        height: 100px;
        margin-top: -96px;
        border-top: 1px solid #eee;
    }
}*/

h3 {
    font-size: 2em;
    line-height: 1.43;
    color: var(--font-h3);
    border-bottom: 3px solid var(--border-bottom-h3);
}

h4 {
    font-size: 1.7em;
    color: var(--font-h4);
    border-bottom: 2px solid var(--border-bottom-h4);
}

h5 {
    font-size: 1.4em;
    color: var(--font-h5);
    border-bottom: 2px dashed var(--border-bottom-h5);
}

h6 {
    font-size: 1.1em;
    color: var(--font-h6);
    border-bottom: 1px dashed var(--border-bottom-h6);
}

/* -----------------------------------------------------------------------标题配置结束----------------------------------------------------------------------- */


p,
blockquote,
ul,
ol,
dl,
table {
    margin: 0.8em 0;
}

/* 取消居中对齐 */
/* 
p .md-image:only-child{
    width: auto;
    text-align: inherit;
}

p > .md-image:only-child:not(.md-img-error) img {
    display: inline-block;
} */

li>ol,
li>ul {
    margin: 0 0;
}

/* --------------------------------------------------------水平线（分割线）-------------------------------------------------------------- */
/* hr {
    height: 2px;
    padding: 0;
    margin: 16px 0;
    background-color: #e1e1e1;
    border: 0 none;
    overflow: hidden;
    box-sizing: content-box;
} */

/* --------------------------------------------------------水平线（分割线）结束-------------------------------------------------------------- */



/* -------------------------------------------------------有/无序列表----------------------------------------------- */

li p.first {
    display: inline-block;
}

ul,
ol {
    padding-left: 30px;
}

ul:first-child,
ol:first-child {
    margin-top: 0;
}

ul:last-child,
ol:last-child {
    margin-bottom: 0;
}

/*
list-style-type: disc;  实心圆
list-style-type: circle;  空心圆
list-style-type: square;  矩形
list-style-type: decimal;  数字  1
list-style-type: decimal-leading-zero;  有零的数字  01
list-style-type: lower-alpha;  字母
list-style-type: lower-greek; 阿尔法
list-style-type: lower-latin; 小写字母
list-style-type: lower-roman; 小写罗马数字
list-style-type: upper-alpha; 大写字母
list-style-type: upper-latin; 大写字母
list-style-type: upper-roman; 大写罗马数字
list-style-type: none;  无
list-style-type: cjk-ideographic  一、
list-style-type: "😎" 自定义内容
*/


/* -------------------------------------------------------------------------有序列表------------------------------------------------------------------ */
ol {
    list-style-type: decimal;
    /* list-style-type:"(" counter(imgNum) ")" !important; */
    /* list-style-type:"(" attr(upper-alpha) ")"; */
    /* list-style-type: decimal; */
}

ol ol {
    list-style-type: lower-alpha;
}

ol ol ol {
    list-style-type: lower-roman;
}


/* ol::after{
    content: '\1f4a2';
    font-family: 'entypo', sans-serif;
} */
/*
ol ol::before{
    content: '\1f4a1';
    font-family: 'entypo', sans-serif;
} */

/* todo清单 */
.task-list-done {
    text-decoration: line-through;
    color: var(--taskftext-color);

}

.task-list-not-done {}

/** ---------------------------------------------任务列表小方框-------------------------------------------------- **/

/* 
.md-task-list-item>input {
    margin-left: -1.3em;
    margin-top: 0.4rem;
    /* -webkit-appearance: none; 
    text-decoration: line-through;
}
.md-task-list-item>input:before {
    content: '';
    display: inline-block;
    width: 0.875rem;
    height: 0.875rem;
    vertical-align: middle;
    text-align: center;
    font-size: 0.8rem;
    color: white;
    border-radius: 2px;
    /*background-color: white;
    border: 1px solid var(--taskborder-color);
    margin-top: -0.4rem;
    transition: all 0.2s linear;
}
.md-task-list-item>input:checked:before,
.md-task-list-item>input[checked]:before {
    content: '\2714';
    font-size: 0.625rem;
    color: white;
    border: 1px solid var(--taskfocus-color);
    background-color: var(--taskfocus-color);
    line-height: .8rem;
}
.md-task-list-item:before{
    content: none !important;
}

.md-task-list-item>input {
    margin-left: -1.3em;
    
} */

/* -------------------------------------------------------有/无序列表结束----------------------------------------------- */


/* ------------------------------------------------------引用块------------------------------------------------------ */
/* markdown中的“> ” */
/* html中是blockquote标签 */

blockquote {
    width: 100%;
    border-left: 4px solid #dfe2e5;
    padding: 0 15px;
    color: #777777;
}

blockquote blockquote {
    padding-right: 0;
}

blockquote:hover {
    border-left: 5px solid var(--blockquoteicon-color);
}

blockquote:hover:before {
    color: var(--blockquoteicon-color);
}

blockquote[alt="danger"] {
    border-left-color: var(--blockquotedangericon-color);
    background-color: var(--blockquotedangerbg-color);
}

/* blockquote[alt="danger"]::before {
    content: '\e695';
    font-family: "iconfont";
    color: var(--blockquotedangericon-color);
} */

blockquote[alt="success"] {
    border-left-color: var(--blockquotesuccessicon-color);
    background-color: var(--blockquotesuccessbg-color);
}

/* blockquote[alt="success"]::before {
    content: '\1FABF';
    font-family: "iconfont";
    color: var(--blockquotesuccessicon-color);
} */

blockquote[alt="warn"] {
    border-left-color: var(--blockquotewarnicon-color);
    background-color: var(--blockquotewarnbg-color);
}

/* blockquote[alt="warn"]::before {
    content: '\e8c7';
    font-family: "iconfont";
    color: var(--blockquotewarnicon-color);
} */

blockquote[alt="question"] {
    border-left-color: var(--blockquotequestionicon-color);
    background-color: var(--blockquotequestionbg-color);
}

/* blockquote[alt="question"]::before {
    content: '\eb81';
    font-family: "iconfont";
    color: var(--blockquotequestionicon-color);
} */
/* ------------------------------------------------------引用块结束------------------------------------------------------ */


/* ------------------------------------------------------表格--------------------------------------------------------- */
/* markdown中的“|---|---| ” */
table {
    padding: 0;
    word-break: initial;
}

table tr {
    border: 1px solid #dfe2e5;
    margin: 0;
    padding: 0;
}

table tr:nth-child(2n),
thead {
    background-color: #f8f8f8;
}

table th {
    font-weight: bold;
    border: 1px solid #dfe2e5;
    border-bottom: 0;
    margin: 0;
    padding: 6px 13px;
}

table td {
    border: 1px solid #dfe2e5;
    margin: 0;
    padding: 6px 13px;
}

table th:first-child,
table td:first-child {
    margin-top: 0;
}

table th:last-child,
table td:last-child {
    margin-bottom: 0;
}

/* -------------------------------------------------------表格结束----------------------------------------------------- */



.code-tooltip {
    box-shadow: 0 1px 1px 0 rgba(0, 28, 36, .3);
    border-top: 1px solid #eef2f2;
}



.md-fences,
code,
tt {
    border: 1px solid #e7eaed;
    background-color: #f8f8f8;
    border-radius: 3px;
    padding: 0;
    padding: 2px 4px 0px 4px;
    font-size: 0.9em;
}

/* ------------------------------------------------------------行内代码--------------------------------------------------------------- */
code {
    color: var(--code-color);
    background-color: var(--codebg-color);
    padding: 0 2px 0 2px;
}

.md-fences {
    margin-bottom: 15px;
    margin-top: 15px;
    padding-top: 8px;
    padding-bottom: 6px;

}


/* ----------------------------------------------------------导出----------------------------------------------------------- */
@media print {
    html {
        font-size: 16px;
    }

    /* 设置表格、引用块、图片、代码块不可分割 */
    table,
    pre,
    blockquote,
    img,
    .md-fences {
        page-break-inside: avoid;
    }

    pre {
        word-wrap: break-word;
    }

    /* #write{
       
    } */

    /* 修改html标签可以改变全局的样式，html是最基础的标签 */
    html {
        background-image: var(--bgimg-url);
        /* 解决导出PDF时 图片放大模糊的问题 */
        background-size: 50%;
        /* margin: 100px 100px m !important;
        padding: 0px; */
    }

}


/* -----------------------------------------------------导出设置结束------------------------------------------------------- */


/* 图片 */
/*.md-image>.md-meta {
    border-radius: 3px;
    font-family: var(--monospace);
    padding: 2px 0 0 4px;
    font-size: 0.9em;
    color: inherit;
}*/
/* 图片靠左显示 */

/*p .md-image:only-child {
  width: auto;
  text-align: left;
  margin-left: 2rem;
} */


/* ----------------------------------------------------------代码块---------------------------------------------------------------- */
/* 代码块背景*/
.md-fences {
    background-color: var(--codeblockbg-color);
}

.CodeMirror-linenumber {
    font-size: 10px;
}

/* 代码块行号颜色 */
.cm-s-inner .CodeMirror-linenumber {
    width: 1px !important;
    color: var(--codeblocknum-color) !important;
}

/* CodeMirror是一个代码高亮的插件 */
.CodeMirror-lines {
    padding-left: 4px;
    font-size: 14px;
}


/* 行号左框线 */
#write .CodeMirror-gutters {
    border-right: 1px solid rgba(204, 51, 0) !important;
}


/* 代码块行号颜色 */
.cm-s-inner .CodeMirror-linenumber {
    /* width: 2ch !important; */
    color: var(--codeblocknum-color);
}

/* 代码块光标线条宽度、颜色 */
#write .CodeMirror-cursors .CodeMirror-cursor {
    border-left: 2px solid var(--focus-color);
}

/* 选中行高亮 */
.md-fences:not(.md-focus) .CodeMirror-code>*:hover {
    background-color: var(--codeblockline-color);
}

.md-fences.md-focus .CodeMirror-code>div.CodeMirror-activeline {
    background-color: var(--codeblockline-color);
}

/* ----------------------------------------------------------代码块结束---------------------------------------------------------------- */



/* ----------------------------------------元数据引用块-------------------------------------- */
#write pre.md-meta-block {
    width: 100%;
    padding: 1rem;
    font-size: 85%;
    line-height: 1.45;
    background-color: #f7f7f7;
    border: 0;
    border-radius: 3px;
    color: #777777;
    margin-top: 0 !important;
}


.mathjax-block>.code-tooltip {
    bottom: .375rem;
}

.md-mathjax-midline {
    background: #fafafa;
}

#write>h3.md-focus:before {
    left: -1.5625rem;
    top: .375rem;
}

#write>h4.md-focus:before {
    left: -1.5625rem;
    top: .285714286rem;
}

#write>h5.md-focus:before {
    left: -1.5625rem;
    top: .285714286rem;
}

#write>h6.md-focus:before {
    left: -1.5625rem;
    top: .285714286rem;
}

.md-image>.md-meta {
    /*border: 1px solid #ddd;*/
    border-radius: 3px;
    padding: 2px 0px 0px 4px;
    font-size: 0.9em;
    color: inherit;
}


/* html <span>标签内的代码的颜色 */
.md-tag {
    color: #c5c5c5;
    /* 不透明度 */
    opacity: 1;
}

/* 目录[top]标签 */
.md-toc {
    margin-top: 20px;
    padding-bottom: 20px;
}


/* -------------------------------------------------------------------typora软件界面配置---------------------------------------------------------------- */
/* 侧边栏顶部的文字和图标 */
.sidebar-tabs {
    border-bottom: none;
    color: #2f2f2f;
}

/* -------------------------------------------------------------------typora软件界面配置结束---------------------------------------------------------------- */



#typora-quick-open {
    border: 1px solid #ddd;
    background-color: #f8f8f8;
}

#typora-quick-open-item {
    background-color: #FAFAFA;
    border-color: #FEFEFE #e5e5e5 #e5e5e5 #eee;
    border-style: solid;
    border-width: 1px;
}


/* --------------------------------------------------------------------专注模式------------------------------------------------------------------- */
/** focus mode */
.on-focus-mode blockquote {
    border-left-color: rgba(85, 85, 85, 0.12);
}

header,
.context-menu,
.megamenu-content,
footer {
    font-family: "Segoe UI", "Arial", sans-serif;
}

/* 鼠标悬浮的时候的现实情况 */
.file-node-content:hover .file-node-icon,
.file-node-content:hover .file-node-open-state {
    /* 显示或隐藏元素而不更改文档的布局 */
    visibility: visible;
    color: rgb(0, 0, 0);
}

/* Mac无缝模式 （未测试）*/
.mac-seamless-mode #typora-sidebar {
    background-color: #fafafa;
    background-color: var(--side-bar-bg-color);
}

.md-lang {
    color: #b4654d;
}


/*.html-for-mac {
    --item-hover-bg-color: #E6F0FE;
}*/

#md-notification .btn {
    border: 0;
}

/* ? */
.dropdown-menu .divider {
    border-color: #e5e5e5;
    opacity: 0.4;
}

.ty-preferences .window-content {
    background-color: #fafafa;
}

.ty-preferences .nav-group-item.active {
    color: white;
    background: #999;
}

.menu-item-container a.menu-style-btn {
    background-color: #f5f8fa;
    background-image: linear-gradient(180deg, hsla(0, 0%, 100%, 0.8), hsla(0, 0%, 100%, 0));
}


/* 选中行高亮 */
.md-fences:not(.md-focus) .CodeMirror-code>*:hover {
    background-color: var(--codeblockline-color);
}

.md-fences.md-focus .CodeMirror-code>div.CodeMirror-activeline {
    background-color: var(--codeblockline-color);
}


/** 脚注（上标） **/
#write .md-footnote {
    background-color: var(--footnotebg-color);
    color: var(--footnote-color);
}

/* 脚注上标链接禁止显示下划线样式 */
#write sup.md-footnote a {
    color: inherit !important;
    /* 鼠标hover时禁止颜色发生变化 */
    border-bottom: none;
    padding: 1px;
    background-color: inherit;
}

/** 文本高亮 **/
#write span[md-inline="highlight"] mark {
    background-color: var(--highlightbg-color);
    border-radius: 2px;
    padding: 2px 4px;
    margin: 0 2px;
    color: var(--highlight-color);
    font-weight: 500;
}


/** 隐藏型文本 **/
span[alt="hide"] {
    color: transparent;
    background: var(--hidetextcover-color);
    border-radius: 2px;
    -webkit-transition: all .28s ease;
    -moz-transition: all .28s ease;
    -o-transition: all .28s ease;
    -ms-transition: all .28s ease;
    transition: all .28s ease;
    -moz-transition: all .28s ease;
    -webkit-transition: all .28s ease;
    -o-transition: all .28s ease;
}

span[alt="hide"]:hover {
    color: var(--hidetext-color);
    background: 0 0
}


/** 彩虹变换字体特效（来自黑石博客） **/
@-webkit-keyframes rainbowan {
    to {
        background-position: -2000vw;
    }
}

@keyframes rainbowan {
    to {
        background-position: -2000vw;
    }
}

span[alt="rainbow"],
span[alt="rainbow"] * {
    padding-top: 3px;
    background-image: linear-gradient(to left, orangered, orange, gold, lightgreen, cyan, dodgerblue, mediumpurple, hotpink, orangered);
    background-size: 110vw;
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
    -webkit-animation: rainbowan 60s linear infinite;
    animation: rainbowan 60s linear infinite;
}

/** 强调型文本 **/
span[alt='emp'] {
    border-bottom: 4px dotted var(--emptext-color);
}

span[alt='underline'] {
    border-bottom: 2px solid var(--emptext-color);
}

span[alt='wavy'] {
    text-decoration-style: wavy;
    text-decoration-line: underline;
    text-decoration-color: var(--emptext-color);
}


/** 一款时尚的span字体，来自QinXS **/
span[alt="modern"] {
    display: inline;
    padding: 5px 10px;
    border-radius: 20px;
    font-family: var(--body-font);
    font-size: 1em;
    letter-spacing: .2em;
    color: red;
    text-shadow: 0 8px 9px #c4b59d, 0 -2px 1px #fff;
    font-weight: 700;
    background: linear-gradient(to bottom, #ece4d9 0, #e9dfd1 100%);
}

/** volantis文本按钮样式 **/
span[alt="btn"] {
    color: var(--spanbtn-color);
    border: 1px solid var(--spanbtn-color);
    padding: 3px 4px 2px;
    margin: 4px;
    line-height: 1.1;
    border-radius: 2px;
}

#write span[alt="btn"] a {
    color: var(--spanbtn-color);
    border-bottom: none;
    background-color: inherit;
    transition: none;
}

span[alt="btn"]:hover {
    color: var(--focus-color);
    border: 1px solid var(--focus-color);
}

#write span[alt="btn"]:hover a {
    color: var(--focus-color) !important;
    background-color: inherit !important;
}


/** 抖音字效 **/
@-webkit-keyframes uk-text-shadow-glitch {
    0% {
        text-shadow: none
    }

    25% {
        text-shadow: -1px -1px 0 #ff0048, 1px 1px 0 #3234ff
    }

    50% {
        text-shadow: 1px -1px 0 #ff0048, -1px 1px 0 #3234ff
    }

    75% {
        text-shadow: -1px 1px 0 #ff0048, 1px -1px 0 #3234ff
    }

    to {
        text-shadow: 1px 1px 0 #ff0048, -1px -1px 0 #3234ff
    }
}

@keyframes uk-text-shadow-glitch {
    0% {
        text-shadow: none
    }

    25% {
        text-shadow: -1px -1px 0 #ff0048, 1px 1px 0 #3234ff
    }

    50% {
        text-shadow: 1px -1px 0 #ff0048, -1px 1px 0 #3234ff
    }

    75% {
        text-shadow: -1px 1px 0 #ff0048, 1px -1px 0 #3234ff
    }

    to {
        text-shadow: 1px 1px 0 #ff0048, -1px -1px 0 #3234ff
    }
}

span[alt="shake"] {
    -webkit-animation: uk-text-shadow-glitch .95s cubic-bezier(1, -1.91, 0, 2.79) 0s infinite normal both running;
    animation: uk-text-shadow-glitch .95s cubic-bezier(1, -1.91, 0, 2.79) 0s infinite normal both running;
}


/**------------------------------------------------------------- 小标签 ---------------------------------------------------------------**/
font {
    display: inline;
    padding: .2em .6em;
    font-size: 90%;
    font-weight: 400;
    line-height: 1;
    color: #fff;
    text-align: center;
    /*white-space: nowrap;*/
    vertical-align: baseline;
    border-radius: .1rem;
    border-radius: 6px;
    background-color: var(--spannote-color);
}

font[title="red"] {
    background-color: #e91e64;
}

font[title="blue"] {
    background-color: #02aaf4;
}

font[title="yellow"] {
    background-color: #ffc50a;
}

font[title="green"] {
    background-color: #8bc34a;
}

font[title="gray"] {
    background-color: #4c4c4c;
}


/* 空心字等文字特效 https://www.cnblogs.com/xiaohuochai/p/7521282.html */
span[alt="hollow"] {
    color: white;
    text-shadow: 1px 1px black, -1px -1px black, 1px -1px black, -1px 1px black;
}

@keyframes blink-smooth {
    50% {
        color: transparent;
    }
}

span[alt="blink"] {
    animation: .5s blink-smooth infinite alternate linear;
}

span[alt="str"] {
    padding: 2px 4px;
    color: var(--commonstr-color);
    background-color: var(--commonstrbg-color);
    border-radius: 3px;
    font-size: 15px;
    font-family: var(--body-font);
}


/* 时间轴（来自Volantis主题） */
div[alt="timeline"] {
    margin-top: 8px;
    margin-left: 8px;
}

div[alt="timenode"] {
    position: relative;
}

div[alt="timenode"]:after,
div[alt="timenode"]:before {
    content: "";
    z-index: 1;
    position: absolute;
    background: rgba(68, 215, 182, .5);
    width: 2px;
    left: 7px;
}

div[alt="timenode"]:before {
    top: 0px;
    height: 6px;
}

div[alt="timenode"] div[alt="body"],
div[alt="timenode"] div[alt="meta"] {
    max-width: calc(100% - 24px);
}

div[alt="timenode"] div[alt="meta"] {
    position: relative;
    color: var(--para-color);
    line-height: 32px;
    font-size: .8rem;
    font-weight: 700;
    margin: 0 0 0 24px;
}

div[alt="timenode"] div[alt="meta"]:after,
div[alt="timenode"] div[alt="meta"]:before {
    content: "";
    position: absolute;
    top: 8px;
    z-index: 2;
    left: -24px;
}

div[alt="timenode"] div[alt="meta"]:before {
    background: rgba(68, 215, 182, .5);
    width: 16px;
    height: 16px;
    border-radius: 8px;
}

div[alt="timenode"] div[alt="meta"]:after {
    background: #44d7b6;
    margin-left: 2px;
    margin-top: 2px;
    width: 12px;
    height: 12px;
    border-radius: 6px;
    -webkit-transform: scale(.5);
    -moz-transform: scale(.5);
    -o-transform: scale(.5);
    -ms-transform: scale(.5);
    transform: scale(.5);
}

div[alt="timenode"] div[alt="body"] {
    margin: 4px 0 10px 24px;
    padding: 10px;
    border-radius: 12px;
    background: var(--timebodybg-color);
    display: inline-block;
    font-size: .9rem;
}

div[alt="timenode"]:not(:last-child):after {
    top: 26px;
    height: calc(100% - 26px);
}

div[alt="timenode"]:last-child:after {
    top: 26px;
    height: calc(100% - 30px);
}

div[alt="timenode"]:hover div[alt="meta"] {
    color: var(--para-color);
}

div[alt="timenode"]:hover div[alt="meta"]:before {
    background: rgba(255, 87, 34, .5)
}

div[alt="timenode"]:hover div[alt="meta"]:after {
    background: #ff5722;
    -webkit-transform: scale(1);
    -moz-transform: scale(1);
    -o-transform: scale(1);
    -ms-transform: scale(1);
    transform: scale(1);
}


/* 参考链接样式修改（隐藏链接部分，只显示标题） */
.footnotes.md-def-link .md-def-split,
.footnotes .md-def-url {
    display: none;
}

.footnotes.md-def-link .md-def-name,
.footnotes .md-def-title {
    display: inline;
}

.footnotes {
    margin-top: 2px;
    margin-bottom: 2px;
}



/* KBD按键样式 */
kbd {
    font-family: 'Alibaba Sans';
    /* font: var(--kbdbg-color);代码字体颜色 */
    font-size: .8em;
    /* background: var(--kbdbg-color);文字背景 (按键颜色)*/
    color: var(--kbd-color);
    /* 文字颜色 */
    border-radius: 5px;
    border-color: var(--kbdbg-color);
    /* box-shadow: unset; */
    box-shadow: 2px 2px 4px 1px var(--kbd-shadow);

}

/* https://www.jq22.com/webqd4214（爱是一道光，绿到你发慌） */
span[alt="glow"] {
    font-family: 'Audiowide';
    text-align: center;
    /*color:black;*/
    -webkit-transition: all 1.5s ease;
    transition: all 1.5s ease;
}

span[alt="glow"]:hover {
    color: #00a67c;
    -webkit-animation: Glow 1.5s ease infinite alternate;
    animation: Glow 1.5s ease infinite alternate;
}

@-webkit-keyframes Glow {
    from {
        text-shadow: 0 0 10px #fff, 0 0 20px #fff, 0 0 30px #fff, 0 0 40px #00a67c, 0 0 70px #00a67c, 0 0 80px #00a67c, 0 0 100px #00a67c, 0 0 150px #00a67c;
    }

    to {
        text-shadow: 0 0 5px #fff, 0 0 10px #fff, 0 0 15px #fff, 0 0 20px #00a67c, 0 0 35px #00a67c, 0 0 40px #00a67c, 0 0 50px #00a67c, 0 0 75px #00a67c;
    }
}

@keyframes Glow {
    from {
        text-shadow: 0 0 10px #fff, 0 0 20px #fff, 0 0 30px #fff, 0 0 40px #00a67c, 0 0 70px #00a67c, 0 0 80px #00a67c, 0 0 100px #00a67c, 0 0 150px #00a67c;
    }

    to {
        text-shadow: 0 0 5px #fff, 0 0 10px #fff, 0 0 15px #fff, 0 0 20px #00a67c, 0 0 35px #00a67c, 0 0 40px #00a67c, 0 0 50px #00a67c, 0 0 75px #00a67c;
    }
}


/** 折叠标签 **/
details {
    display: block;
    padding: 16px;
    margin: 1em 0;
    border-radius: 4px;
    background: var(--bg-color);
    font-size: 14px;
    -webkit-transition: all .28s ease;
    -moz-transition: all .28s ease;
    -o-transition: all .28s ease;
    -ms-transition: all .28s ease;
    transition: all .28s ease;
    -moz-transition: all .28s ease;
    -webkit-transition: all .28s ease;
    -o-transition: all .28s ease;
    border: 1px solid var(--bg-color);
}

summary {
    display: list-item;
}

details summary {
    cursor: pointer;
    padding: 16px;
    margin: -16px;
    border-radius: 4px;
    color: var(--detailstxt-color);
    font-size: .875rem !important;
    font-weight: 700;
    position: relative;
    line-height: normal;
}

details>summary {
    background: var(--detailsbg-color);
}

details[open] {
    border-color: var(--detailsborder-color);
}

details[open]>summary {
    color: #444;
    margin-bottom: 0;
}

details[open]>summary {
    border-bottom: 1px solid var(--detailsborder-color);
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;
}


/* 折叠框、视频、音频标签点击时候会出现黑色边框，极不美观，去除 */
summary:focus {
    outline: none !important;
}

video:focus {
    outline: none !important;
}

audio:focus {
    outline: none !important;
}



/** 导出html文件，修复流程图在手机端高度太大的问题 **/
.md-diagram-panel svg {
    /*max-width: inherit !important;*/
    height: inherit !important;
}


/* ------------------------------------------------------------------媒体查询------------------------------------------------------------------------- */
/* 必须放在后面，否则会无法加载，建议放最后 */
/* 宽度为 1400px 或更小时 */
@media only screen and (max-width: 1400px) {

    /* 内容编辑区域（纸张） */
    #write {
        background-color: var(--page-color-mini);
    }

    .md-fences {
        background-color: var(--codeblockbg-color-mini);
    }
}

/* 代码块 
    .md-fences {
        background-color: var(--codeblockbg-color-mini);
    } */
/* ------------------------------------------------------------------媒体查询结束------------------------------------------------------------------------- */
:root {
  --sequence-theme: hand;/*手写风格*/
  --mermaid-sequence-numbers: on;/*自动编号*/
}；

 @media print { @page {margin: 0 0 0 0;} body.typora-export {padding-left: 0; padding-right: 0;} #write {padding:0;}}



