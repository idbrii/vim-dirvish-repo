function! dirvish#repo#git#find_repo()
    let dotfile = findfile('.git', '.;/') " must be somewhere above us
    if filereadable(dotfile)
        let b:dirvish_repo_root = fnamemodify(dotfile, ':p:h')
        return 'git'
    else
        return v:false
    endif
endf

function! dirvish#repo#git#open_directory(file)
    exec printf(".!git ls-files -- '%s'", a:file)
endf

function! dirvish#repo#git#open_file(file)
    let regex = ':s?'.b:dirvish_repo_root.'?.?'
    exec printf(".!git show HEAD:'%s'", fnamemodify(a:file, regex))
    exec 'file git://'. a:file
endf

