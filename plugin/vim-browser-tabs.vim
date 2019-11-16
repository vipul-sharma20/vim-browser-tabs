" Copyright © 2019 Vipul Sharma
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the "Software"),
" to deal in the Software without restriction, including without limitation
" the rights to use, copy, modify, merge, publish, distribute, sublicense,
" and/or sell copies of the Software, and to permit persons to whom the
" Software is furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included
" in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
" OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
" DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
" OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


" Check if plugin properties set by user. Fallback to defaults if not.
let g:browser_tabs_default_browser = get(g:, 'browser_tabs_default_browser', 'Google Chrome')
let g:browser_tabs_window_layout = get(g:, 'browser_tabs_window_layout', 'default')

" Get plugin directory
let g:plugin_path = expand('<sfile>:p:h')

" Darwin command to list all browser tabs
let g:darwin_command = printf("bash " . g:plugin_path . "/darwin/fetch.sh %s", g:browser_tabs_default_browser)

" Get color utility function
function! s:get_color(attr, ...)
    let gui = has('termguicolors') && &termguicolors
    let fam = gui ? 'gui' : 'cterm'
    let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
    for group in a:000
        let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
        if code =~? pat
            return code
        endif
    endfor
    return ''
endfunction

let s:ansi = {'red': 31, 'yellow': 33, 'cyan': 36}

" Format to colored string
function! s:ansi(str, group, default, ...)
    let fg = s:get_color('fg', a:group)
    let bg = s:get_color('bg', a:group)
    let color = (empty(fg) ? s:ansi[a:default] : s:csi(fg, 1)) .
          \ (empty(bg) ? '' : ';'.s:csi(bg, 0))
    return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction

for s:color_name in keys(s:ansi)
  execute "function! s:".s:color_name."(str, ...)\n"
        \ "  return s:ansi(a:str, get(a:, 1, ''), '".s:color_name."')\n"
        \ "endfunction"
endfor

" Get system's OS
function! s:get_os()
    let command = ""

    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
   return g:os
endfunction

" Get all the browser tabs for Darwin
function! s:get_darwin_tabs()
    try
        let res = system(g:darwin_command)
    catch
        echoerr "Cannot contact browser for tabs"
    endtry

    let split_list = split(res, "\n")
    let tab_list = []
    let template = "%s %s %s"
    for item in split_list
        let tab_str = split(item, "\t")
        if len(tab_str) >= 4
            let new_tab_str = printf('%s %s  > %s | %s',
            \ s:yellow(printf('%3d', tab_str[0]), 'Window'),
            \ s:cyan(printf('%3d', tab_str[1]), 'Tab'),
            \ tab_str[2],
            \ s:red(printf('%s', tab_str[3]), 'URL'))
            call add(tab_list, new_tab_str)
        endif
    endfor
    return tab_list
endfunction

function! s:switch_darwin_tabs(e)
    let split_list = split(a:e)
    let switch_command = printf("bash " . g:plugin_path . "/darwin/switch.sh %d %d", split_list[0], split_list[1])
    echom switch_command
    let res = system(switch_command)
endfunction

" Fetch all browser tabs. This is the source function for FZF
function! Tabs()
    let os_type = s:get_os()
    if os_type == "Darwin"
        let tab_list = s:get_darwin_tabs()
    endif
    return tab_list
endfunction

" Switch to selected browser tab. This is the sink function for FZF
function! Browser(e)
    let os_type = s:get_os()
    if os_type == "Darwin"
        let result = s:switch_darwin_tabs(a:e)
    endif
endfunction

" Create floating window layout
" TODO: fix hardcoded window parameters
function! FloatingLayout()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = &lines - 7
    let width = float2nr(&columns - (&columns * 2 / 10)) - 30
    let col = float2nr((&columns - width) / 2)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': 8,
          \ 'col': 25,
          \ 'width': &columns - 50,
          \ 'height': &lines - 15
          \ }
    call nvim_open_win(buf, v:true, opts)
endfunction

" Driving FZF function
command! -bang -nargs=* GetBrowserTabs call fzf#run({
        \ 'window': g:browser_tabs_window_layout == 'floating' ? 'call FloatingLayout()' : '',
        \ 'source': extend(['Win Tab    Name'], Tabs()),
        \ 'sink': function('Browser'),
        \ 'options': '-x --preview-window="80%" --ansi --tiebreak=begin --header-lines=1',
        \ 'down': '30%'})

