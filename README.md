# vim-dirvish-repo

Browse a repository like a local filesystem using dirvish

Ever wish you could just peek at what's in source control, but don't want to
use a gui browser or figure out and keep typing the commands into a terminal?
With dirvish-repo, you can browse your repository from vim as if you had a
pristine checkout.

# Supported SCM

* git, svn

[New scm support goes here](https://github.com/idbrii/vim-dirvish-repo/tree/master/autoload/dirvish/repo).

# Recommended accompanying plugins

vim-dirvish-repo has no hard dependencies, but I'd recommend you use these plugins.

* [vim-dirvish](https://github.com/justinmk/vim-dirvish)
    * Not actually required, but provides syntax highlighting and some
      assistance maps. vim-dirvish-repo is intended to behave like dirvish but
      in repo-space.
* [itchy.vim](https://github.com/idbrii/itchy.vim)
    * Nicer scratch split for the browser window.


# License

Dual licensed under the MIT License and GNU General Public License v3
(for compatibility with dirvish).
