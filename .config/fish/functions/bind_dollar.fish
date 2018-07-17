# Defined in /var/folders/p2/80wzrx0s5yvds_chp6qsxn_r0000gn/T//fish.mRu2t5/fish_user_key_bindings.fish @ line 28
function bind_dollar
	switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end
