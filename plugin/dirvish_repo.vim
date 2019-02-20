if !exists('loaded_dirvish') || exists('loaded_dirvish_repo')
    finish
endif
let loaded_dirvish_repo = 1 

command! DirRepo call dirvish#repo#ls()
nnoremap <Plug>(dirvish-repo-ls) :<C-u>DirRepo<CR>
