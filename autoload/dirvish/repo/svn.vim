function! dirvish#repo#svn#find_repo()
    let dotfile = findfile('.svn', '.;/') " must be somewhere above us
    if filereadable(dotfile)
        return 'svn'
    else
        return v:false
    endif
endf

function! dirvish#repo#svn#open_directory(file)
    exec printf(".!svn ls '%s'", a:file)
endf

function! dirvish#repo#svn#open_file(file)
    exec printf(".!svn cat '%s'", a:file)
    exec 'file svn://'. a:file
endf

