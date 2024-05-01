" Inserts an SP-grading comment, with the arrow pointing to the position of the
" cursor
function SPComment(print_arrow = 1)
	if &filetype ==# 'c' || expand('%') ==# 'machfile'
		let start = '/*'
		let middle = ''
		let end = '*/'
	elseif &filetype ==# 'make'
		let start = '##'
		let middle = '# '
		let end = '#/'
	else
		echoerr 'Unrecognized filetype'
		return
	endif

	" the correct amount of spaces (depending on the cursor ) follow by '^'
	let arrow = !a:print_arrow ? '' : repeat(' ', virtcol('.') - 4) . '^'
	" helper-'function' to clear a line
	let clear = "\<Esc>0\"_Di"

	execute 'normal! o' . clear . start . 'K' . arrow . "\<CR>"
				\ . clear . end . "\<Esc>O" . clear . middle
	startinsert!
endfunction

" \c inserts a comment with an arrow, \C without an arrow
nnoremap <silent> <Leader>cc :call SPComment()<CR>
nnoremap <silent> <Leader>CC :call SPComment(0)<CR>
