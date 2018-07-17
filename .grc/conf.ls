# file
regexp=^[ld-]([r-][w-][xt-])([r-][w-][xt-])([r-][w-][xt-])\s+\d+\s+(\w+)\s+(\w+)\s+.+\w+\s+(.+)$
colours=unchanged, "\033[38;5;33m", "\033[38;5;197m", bold green, green, "\033[38;5;33m", white
======
# dirs
regexp=^d[r-][w-][xt-][r-][w-][xt-][r-][w-][xt-]\s+\d+\s+\w+\s+\w+\s+.+\w+\s+(.+)$
colours=unchanged,"\033[38;5;33m"
======
# executables
regexp=^[l-][r-][w-][xt-][r-][w-][xt-][r-][w-][x]\s+\d+\s+\w+\s+\w+\s+.+\w+\s+(.+)$
colours=unchanged,"\033[38;5;122m"
======
# SQL
regexp=\s[\s\w\.\?\-\_\d\+]+\.sql
colours=bold red
======
# rpm
regexp=\s[\s\w\.\?\-\_\d\+]+\.rpm
colours=bold blue
======
# doc
regexp=\s([\ \w\.\?\-\_\d\+]+\.doc)$
colours=unchanged, blue
======
# zip
regexp=\s[\s\w\.\?\-\_\d\+]+\.zip
colours=magenta
======
# jpg
regexp=\s[\s\w\.\?\-\_\d\+]+\.jpg
colours=cyan
======
# root user/group
regexp=root
colours=red
