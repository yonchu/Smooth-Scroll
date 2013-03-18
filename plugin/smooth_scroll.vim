" Smooth Scroll
"
" Remamps
"  <C-U>
"  <C-D>
"  <C-F>
"  <C-B>
"
" to allow smooth scrolling of the window. I find that quick changes of
" context don't allow my eyes to follow the action properly.
"
" Global variables:
"   g:smooth_scroll_latency
"     Change ths scroll speed.
"     (default: 50000)
"
"   g:scroll_skip_line_size
"     Skip redraw the display.
"     (default: 0)
"
"   g:smooth_scroll_no_default_key_mappings
"     Disable default key mappings.
"
"
" Written by Brad Phelan 2006
" http://xtargets.com

if exists('g:loaded_smooth_scroll')
  finish
endif
let g:loaded_smooth_scroll = 1

let s:save_cpo = &cpo
set cpo&vim


let g:smooth_scroll_latency = get(g:, 'smooth_scroll_latency', 5000)
let g:scroll_skip_line_size = get(g:, 'scroll_skip_line_size', 0)

function! SmoothScroll(dir, windiv, scale)
  " Disable highlight the screen line of the cursor,
  " because will make screen redrawing slower.
  let save_cul = &cul
  if save_cul
    set nocul
  endif

  let scrdown = a:dir == 'd'
  let wlcount = winheight(0) / a:windiv
  let latency = (g:smooth_scroll_latency * a:scale) / 1000

  if scrdown
    let pos = 'j'.(line('.') != line('w$') ? "\<C-E>" : '')
    let vbl = 'w$'
    let tob = line('$')
  else
    let pos = 'k'.(line('.') != line('w0') ? "\<C-Y>" : '')
    let vbl = 'w0'
    let tob = 1
  endif
  let cmd = 'normal! '.pos
  let slp = 'sleep '.latency.'m'

  let i = 0
  let j = 0
  while i < wlcount
    let i += 1
    if line(vbl) == tob
      execute 'normal '.(wlcount - i).pos
      break
    endif

    execute cmd

    if j >= g:scroll_skip_line_size
      let j = 0
      redraw
    else
      let j = j + 1
    endif

    execute slp
  endwhile

  if save_cul | set cul | endif
endfunction


" Interfaces.
nnoremap <silent> <script> <Plug>smooth-scroll-c-d :call SmoothScroll('d', 2, 2)<cr>
nnoremap <silent> <script> <Plug>smooth-scroll-c-u :call SmoothScroll('u', 2, 2)<cr>

nnoremap <silent> <script> <Plug>smooth-scroll-c-f :call SmoothScroll('d', 1, 1)<cr>
nnoremap <silent> <script> <Plug>smooth-scroll-c-b :call SmoothScroll('u', 1, 1)<cr>

" Default mappings.
if !get(g:, 'g:smooth_scroll_no_default_key_mappings', 0)
  if !hasmapto('<Plug>smooth-scroll-c-d')
    nmap <silent> <unique> <C-D> <Plug>smooth-scroll-c-d
  endif
  if !hasmapto('<Plug>smooth-scroll-c-u')
    nmap <silent> <unique> <C-U> <Plug>smooth-scroll-c-u
  endif

  if !hasmapto('<Plug>smooth-scroll-c-f')
    nmap <silent> <unique> <C-F> <Plug>smooth-scroll-c-f
  endif
  if !hasmapto('<Plug>smooth-scroll-c-b')
    nmap <silent> <unique> <C-B> <Plug>smooth-scroll-c-b
  endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
