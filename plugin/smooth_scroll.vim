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
"   g:smooth_scroll_du_sleep_time_msec
"     This valus is to change the scroll speed for <C-D> and <C-U>.
"     (default: 10 msec)
"
"   g:smooth_scroll_fb_sleep_time_msec
"     This valus is to change the scroll speed for <C-F> and <C-B>.
"     (default: 5 msec)
"
"   g:smooth_scroll_skip_redraw_line_size
"     This value is to skip redraw the display.
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


let g:smooth_scroll_du_sleep_time_msec = get(g:, 'smooth_scroll_du_sleep_time_msec', 10)
let g:smooth_scroll_fb_sleep_time_msec = get(g:, 'smooth_scroll_fb_sleep_time_msec', 5)
let g:smooth_scroll_skip_redraw_line_size = get(g:, 'smooth_scroll_skip_redraw_line_size', 0)

function! SmoothScroll(cmd, windiv, sleep_time_msec)
  " Disable highlight the screen line of the cursor,
  " because will make screen redrawing slower.
  let save_cul = &cul
  if save_cul
    set nocul
  endif

  let wlcount = winheight(0) / a:windiv

  let cmd = 'normal! '.a:cmd
  if a:cmd == 'j'
    " Scroll down.
    let tob = line('$')
    let vbl = 'w$'
    let cmd = cmd."\<C-E>"
  else
    " Scroll up.
    let tob = 1
    let vbl = 'w0'
    let cmd = cmd."\<C-Y>"
  endif

  let slp = 'sleep '.a:sleep_time_msec.'m'

  let i = 0
  let j = 0
  while i < wlcount
    let i += 1
    if line(vbl) == tob
      execute 'normal! '.(wlcount - i).a:cmd
      break
    endif

    execute cmd

    if j >= g:smooth_scroll_skip_redraw_line_size
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
nnoremap <silent> <script> <Plug>smooth-scroll-c-d
      \ :call SmoothScroll('j', 2, g:smooth_scroll_du_sleep_time_msec)<cr>
nnoremap <silent> <script> <Plug>smooth-scroll-c-u
      \ :call SmoothScroll('k', 2, g:smooth_scroll_du_sleep_time_msec)<cr>

nnoremap <silent> <script> <Plug>smooth-scroll-c-f
      \ :call SmoothScroll('j', 1, g:smooth_scroll_fb_sleep_time_msec)<cr>
nnoremap <silent> <script> <Plug>smooth-scroll-c-b
      \ :call SmoothScroll('k', 1, g:smooth_scroll_fb_sleep_time_msec)<cr>

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
