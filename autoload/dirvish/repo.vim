
function! s:ChangeToSvnDirvish(directory)
    0,$delete _
    exec printf(".!svn ls '%s'", a:directory)
    let b:dirvish_repo_curpath = a:directory
endf

function! s:ChangeToParentSvnDirvish()
    let parent = fnamemodify(b:dirvish_repo_curpath, ':h')
    return s:ChangeToSvnDirvish(parent)
endf

function! s:SvnDirvishOpen(file)
    let file = a:file
    let is_directory = file =~# '/$'
    if is_directory
        call s:ChangeToSvnDirvish(file)
    else
        0,$delete _
        exec printf(".!svn cat '%s'", file)
        exec 'file svn://'. file
    endif
endf

function! s:SelectLineInSvnDirvish()
    let file = getline('.')
    let file = b:dirvish_repo_curpath .'/'. file
    return s:SvnDirvishOpen(file)
endf

function! dirvish#repo#ls()
    exec 'cd '. resolve(expand('%:p:h'))
    silent Scratch dirvish
    silent call s:ChangeToSvnDirvish(fnamemodify('.', ':p:h'))
    nnoremap <buffer> <Plug>(dirvish_repo_open) :<C-u>silent call <SID>SelectLineInSvnDirvish()<CR>
    nnoremap <buffer> <Plug>(dirvish_repo_up)   :<C-u>silent call <SID>ChangeToParentSvnDirvish()<CR>
    nmap <buffer> <CR> <Plug>(dirvish_repo_open)
    nmap <buffer> i <Plug>(dirvish_repo_open)
    nmap <buffer> - <Plug>(dirvish_repo_up)
endf
