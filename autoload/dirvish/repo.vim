let g:dirvish_repo_scm = get(g:, 'dirvish_repo_scm', ['git', 'svn'])

function! s:ChangeToRepoBrowser(directory)
    0,$delete _
    call dirvish#repo#{b:dirvish_repo_scm}#open_directory(a:directory)
    let b:dirvish_repo_curpath = a:directory
endf

function! s:ChangeToParentRepoBrowser()
    let parent = fnamemodify(b:dirvish_repo_curpath, ':h')
    return s:ChangeToRepoBrowser(parent)
endf

function! s:RepoBrowserOpen(file)
    let file = a:file
    let is_directory = file =~# '/$'
    if is_directory
        " :h will just remove a trailing /, so strip that now so - jumps
        " straight to parent instead of us and then parent.
        call s:ChangeToRepoBrowser(fnamemodify(file, ':h'))
    else
        0,$delete _
        call dirvish#repo#{b:dirvish_repo_scm}#open_file(file)
        filetype detect
        setlocal bufhidden=delete
    endif
endf

function! s:SelectLineInRepoBrowser()
    let file = getline('.')
    let file = b:dirvish_repo_curpath .'/'. file
    return s:RepoBrowserOpen(file)
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
    if exists(':Scratch') == 2
        silent Scratch dirvish
    else
        vnew
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal noswapfile
        setlocal buflisted
        setfiletype dirvish
    endif
    let b:dirvish_repo_scm = s:FindScm()
    if b:dirvish_repo_scm == v:false
        echoerr 'Failed to find scm.'
        return
    endif
    silent call s:ChangeToRepoBrowser(fnamemodify('.', ':p:h'))
    nnoremap <buffer> <Plug>(dirvish_repo_open) :<C-u>silent call <SID>SelectLineInRepoBrowser()<CR>
    nnoremap <buffer> <Plug>(dirvish_repo_up)   :<C-u>silent call <SID>ChangeToParentRepoBrowser()<CR>
    nmap <buffer> <CR> <Plug>(dirvish_repo_open)
    nmap <buffer> i <Plug>(dirvish_repo_open)
    nmap <buffer> - <Plug>(dirvish_repo_up)
endf

function! s:find_file_or_dir(query, path)
    let dotfile = findfile(a:query, a:path)
    if filereadable(dotfile)
        return dotfile
    endif
    let dotfile = finddir(a:query, a:path)
    if isdirectory(dotfile)
        return dotfile
    endif
    return ''
endf
function! dirvish#repo#find_repo_root(marker)
    let dotfile = s:find_file_or_dir(a:marker, '.;/') " must be somewhere above us
    if len(dotfile) > 0
        return fnamemodify(dotfile, ':p:h')
    else
        return v:false
    endif
endf

