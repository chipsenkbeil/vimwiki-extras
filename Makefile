VIM = vim -N -u NORC -i NONE --cmd 'set rtp+=test/deps/vim-vader rtp+=test/deps/vimwiki rtp+=$$PWD'

help: ## Display help information
	@printf 'usage: make [target] ...\n\ntargets:\n'
	@egrep '^(.+)\:\ .*##\ (.+)' ${MAKEFILE_LIST} | sed 's/:.*##/#/' | column -t -c 2 -s '#'

test: ## Runs tests for vim and/or neovim, selecting based on what is available
	$(if $(shell command -v vim 2> /dev/null),$(MAKE) vtest,echo 'Skipping vim tests')
	$(if $(shell command -v nvim 2> /dev/null),$(MAKE) ntest,echo 'Skipping nvim tests')

vtest: test/deps ## Runs tests for vim
	$(VIM) '+Vader! test/*.vader'

ntest: test/deps ## Runs tests for neovim
	VADER_OUTPUT_FILE=/dev/stderr n$(VIM) --headless '+Vader! test/*.vader'

vtesti: test/deps ## Runs tests interactively for vim
	$(VIM) '+Vader test/*.vader'

ntesti: test/deps ## Runs tests interactively for neovim
	n$(VIM) '+Vader test/*.vader'

test/deps: test/deps/vimwiki test/deps/vim-vader

test/deps/vimwiki:
	git clone https://github.com/vimwiki/vimwiki test/deps/vimwiki || ( cd test/deps/vimwiki && git pull --rebase && git checkout dev; )

test/deps/vim-vader:
	git clone https://github.com/junegunn/vader.vim test/deps/vim-vader || ( cd test/deps/vim-vader && git pull --rebase; )

.PHONY: help test testnvim testinteractive
