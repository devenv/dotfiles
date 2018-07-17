# Defined in /var/folders/p2/80wzrx0s5yvds_chp6qsxn_r0000gn/T//fish.mRu2t5/fish_user_key_bindings.fish @ line 19
function bind_bang
	switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end
