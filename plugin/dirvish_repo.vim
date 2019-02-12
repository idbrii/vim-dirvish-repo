if !exists('loaded_dirvish') || exists('loaded_dirvish_repo')
    finish
endif
let loaded_dirvish_repo = 1 

if !exists("g:dirvish_repo_no_mappings") || !g:dirvish_repo_no_mappings
    nnoremap \\ :<C-u>call dirvish#repo#ls()<CR>
endif
