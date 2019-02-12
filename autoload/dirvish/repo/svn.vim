
function! dirvish#repo#svn#open_directory(file)
    exec printf(".!svn ls '%s'", a:file)
endf

function! dirvish#repo#svn#open_file(file)
    exec printf(".!svn cat '%s'", a:file)
    exec 'file svn://'. a:file
endf

