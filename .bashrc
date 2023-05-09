alias l='ls -al'

export PERL_LOCAL_LIB_ROOT="/home/essl/perl5";
export PERL_MB_OPT="--install_base /home/essl/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/essl/perl5";
export PERL5LIB="/home/essl/perl5/lib/perl5/x86_64-linux-thread-multi:/home/essl/perl5/lib/perl5";
export PATH="/home/essl/perl5/bin:$PATH";

export TERM=xterm-256color
export PATH=/home/devenv/jdk1.8.0_73/bin:/home/devenv/apache-maven-3.3.3/bin:/usr/local/heroku/bin:/home/devenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/home/devenv/apache-maven-3.3.3/bin/:$PATH
export JAVA_HOME=~/jdk1.8.0_73
export M2_HOME=~/apache-maven-3.3.9/


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source ~/.profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

