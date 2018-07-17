#!/usr/bin/bash
cat ~/bin/servers_to_init.txt | xargs -I{} ~/bin/init_ssh_machine_el6.sh {}
