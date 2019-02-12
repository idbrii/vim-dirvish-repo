function! dirvish#repo#git#get_root_marker()
    return '.git'
endf

function! dirvish#repo#git#open_directory(file)
    exec printf(".!git ls-files -- '%s'", a:file)
endf

function! dirvish#repo#git#open_file(file)
    let regex = ':s?'.b:dirvish_repo_root.'?.?'
    exec printf(".!git show HEAD:'%s'", fnamemodify(a:file, regex))
    exec 'file git://'. a:file
endf

