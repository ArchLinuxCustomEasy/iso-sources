#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -lh --color=auto'
alias ll='ls -lha --color=auto'
alias mirror='reflector --save /etc/pacman.d/mirrorlist --protocol https --country France --protocol https --latest 10'

PS1='[\u@\h \W]\$ '
