if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

runtime! ftplugin/all_snippets.vim

exec "Snippet req require '".st.et."';<CR>".st.et
exec "Snippet reqo require_once '".st.et."';<CR>".st.et
exec "Snippet ?req <? require '".st.et."'; ?><CR>".st.et
exec "Snippet ?reqo <? require_once '".st.et."'; ?><CR>".st.et
exec "Snippet ?: (".st."condition".et." ? ".st.et.":".st.et.");<CR>".st.et
exec "Snippet ? <?<CR>".st.et."<CR>?>".st.et
exec "Snippet <?= <?= ".st.et." ?>".st.et
exec "Snippet <? <? ".st.et." ?>".st.et
exec "Snippet switch switch ( ".st."variable".et." )<CR>{<CR>case '".st.et."':<CR>".st.et."<CR>break;<CR><CR>".st.et."<CR><CR>default:<CR>".st.et."<CR>break;<CR>}<CR>".st.et
exec "Snippet class #doc<CR>#classname:".st."ClassName".et."<CR>#scope:".st."PUBLIC".et."<CR>#<CR>#/doc<CR><CR>class ".st."ClassName".et." ".st."extendsAnotherClass".et."<CR>{<CR>#internal variables<CR><CR>#Constructor<CR>function __construct ( ".st."argument".et.")<CR>{<CR>".st.et."<CR>}<CR>###<CR><CR>}<CR>###".st.et
exec "Snippet inclo include_once( '".st.et."' );".st.et
exec "Snippet incl include( '".st.et."' );".st.et
exec "Snippet foreach foreach($".st.et." as $".st.et.") {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet ?if <? if(".st.et.") { ?><CR>".st.et."<CR><? } ?><CR>".st.et
exec "Snippet ?ife <? if(".st.et.") { ?><CR>".st.et."<CR><? } else { ?><CR>".st.et."<CR><? } ?><CR>".st.et
exec "Snippet $_ $_REQUEST['".st.et."'];<CR>".st.et
exec "Snippet case case '".st.et."':<CR>".st.et."<CR>break;<CR>".st.et
exec "Snippet pr print \"".st.et."\";<CR>".st.et
exec "Snippet ?pr <? print \"".st.et."\"; ?><CR>".st.et
exec "Snippet prr print_r($".st.et.");<CR>".st.et
exec "Snippet ?prr <? print_r($".st.et."); ?><CR>".st.et
exec "Snippet fn function ".st.et."(".st.et.") {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet if if(".st.et.") {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet ife if(".st.et.") {<CR>".st.et."<CR>} else {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet pif <? if (".st.et.") { ".st.et." } ?>".st.et
exec "Snippet for for($i = ".st.et."; $i < ".st.et."; $i++) {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet while while(".st.et.") {<CR>".st.et."<CR>}<CR>".st.et
