function fish_user_key_bindings
    ### bang-bang ###
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
    bind \e. 'history-token-search-backward'
    bind \e/ 'history-token-search-forward'
    ### bang-bang ###
end
