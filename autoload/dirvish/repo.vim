let g:dirvish_repo_scm = get(g:, 'dirvish_repo_scm', ['git', 'svn'])

function! s:ChangeToSvnDirvish(directory)
    0,$delete _
    call dirvish#repo#{b:dirvish_repo_scm}#open_directory(a:directory)
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
        " :h will just remove a trailing /, so strip that now so - jumps
        " straight to parent instead of us and then parent.
        call s:ChangeToSvnDirvish(fnamemodify(file, ':h'))
    else
        0,$delete _
        call dirvish#repo#{b:dirvish_repo_scm}#open_file(file)
        filetype detect
        setlocal bufhidden=delete
    endif
endf

function! s:SelectLineInSvnDirvish()
    let file = getline('.')
    let file = b:dirvish_repo_curpath .'/'. file
    return s:SvnDirvishOpen(file)
endf

function! s:FindScm()
    for scm in g:dirvish_repo_scm
        let marker = dirvish#repo#{scm}#get_root_marker()
        let root = dirvish#repo#find_repo_root(marker)
        if root != v:false
            let b:dirvish_repo_root = root
            return scm
        endif
    endfor
    return v:false
endf

function! dirvish#repo#ls()
    exec 'cd '. resolve(expand('%:p:h'))
    silent Scratch dirvish
    let b:dirvish_repo_scm = s:FindScm()
    if b:dirvish_repo_scm == v:false
        echoerr 'Failed to find scm.'
        return
    endif
    silent call s:ChangeToSvnDirvish(fnamemodify('.', ':p:h'))
    nnoremap <buffer> <Plug>(dirvish_repo_open) :<C-u>silent call <SID>SelectLineInSvnDirvish()<CR>
    nnoremap <buffer> <Plug>(dirvish_repo_up)   :<C-u>silent call <SID>ChangeToParentSvnDirvish()<CR>
    nmap <buffer> <CR> <Plug>(dirvish_repo_open)
    nmap <buffer> i <Plug>(dirvish_repo_open)
    nmap <buffer> - <Plug>(dirvish_repo_up)
endf

function! dirvish#repo#find_repo_root(marker)
    let dotfile = findfile(a:marker, '.;/') " must be somewhere above us
    if filereadable(dotfile)
        return fnamemodify(dotfile, ':p:h')
    else
        return v:false
    endif
endf

