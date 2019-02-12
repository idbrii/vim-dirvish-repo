function! dirvish#repo#git#get_root_marker()
    return '.git'
endf

function! s:get_repo_path(disk_path)
    let regex = ':s?'.b:dirvish_repo_root.'??'
    let path = fnamemodify(a:disk_path, regex)
    if path[0] == '/'
        let path = path[1:]
    endif
    return path
endf

function! dirvish#repo#git#open_directory(file)
    exec printf(".!git ls-files -- '%s'", a:file)
endf

function! dirvish#repo#git#open_file(file)
    exec printf(".!git show HEAD:'%s'", s:get_repo_path(a:file))
    exec 'file git://'. a:file
endf

