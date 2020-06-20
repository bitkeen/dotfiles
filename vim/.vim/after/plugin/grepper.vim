if &runtimepath =~# 'bundle/opt/vim-grepper'
  " Initialize g:grepper with default values.
  runtime plugin/grepper.vim

  " Specify the tools that are available to use. First in the list is
  " the default tool.
  let g:grepper.tools = ['rg', 'git', 'grep']
  " Global config for rg is in .dotfiles/rg/.config/rg/rgconfig.
  " Don't forget to stow it and export RIPGREP_CONFIG_PATH.
  " -i - ignore case.
  " --no-index - search files in the current directory that is not
  " managed by Git.
  let g:grepper.git.grepprg .= ' -i --no-index'
  let g:grepper.grep.grepprg .= ' -i'
  " Populate the prompt with double quotes and put cursor in between.
  let g:grepper.prompt_quote = 3
  " let g:grepper.highlight = 1
  let g:grepper.simple_prompt = 1

  nnoremap <Leader>gr :Grepper<CR>
  " Switch between searching tools.
  let g:grepper.prompt_mapping_tool = '<Leader>gr'
  " Take any motion and start searching for the selected query right away.
  nmap gs <Plug>(GrepperOperator)
  xmap gs <Plug>(GrepperOperator)
endif
