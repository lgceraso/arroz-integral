# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#export PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\ " #enable this for timestamps
export PS1="\[$(tput bold)\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
export EDITOR=vim
#history settings
HISTTIMEFORMAT="%F %T "
HISTSIZE=5000
#bash-completion
if [ -f /etc/bash_completion ]; then
     . /etc/bash_completion
fi
#alias
alias ls='ls --color=auto'
alias lsd='stat --format "%a %n"'
alias py='python'
alias xbox='ssh -oKexAlgorithms=+diffie-hellman-group1-sha1'
alias mp3='youtube-dl -f bestaudio --extract-audio --audio-format mp3 --output "%(title)s.%(ext)s"'
alias mp4='youtube-dl --output "%(title)s.%(ext)s"'
alias lofi='mpv --really-quiet=yes --ytdl-format=91 --no-video https://www.youtube.com/watch?v=5qap5aO4i9A'
alias deploy='~/Documents/IT/Scripts/deploy.sh'
alias check='sudo pacman -Syyu' # for a better experience: /etc/sudoers -> %wheel ALL=(ALL) NOPASSWD: /usr/bin/pacman -Syyu
alias watchlater='grep -o https://www.youtube.* Documents/Others/todo | awk "{print \$1}" | mpv --ytdl-format=22 --really-quiet=yes --playlist=-'
alias repo='wget -r --no-parent'
alias httpd-log='tail /var/log/httpd/access_log -f'
alias rss='~/Documents/IT/Scripts/rss.sh'
alias att='sudo reflector --protocol https --age 1 --sort rate --save /etc/pacman.d/mirrorlist '
alias rice='cd ~/ && cp -v .gitconfig .bashrc .vimrc .xprofile Documents/GitHub/arroz-integral && cp -v .sfeed/sfeedrc Documents/GitHub/arroz-integral/.sfeed/sfeedrc && cd Documents/GitHub/arroz-integral && echo "upgit arroz-integral" | xclip -selection c; cd - && echo "upgit arroz-integral"'
    
#funcs
vidgetinfo(){
    file=$*
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $file
    ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 $file
    ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate $file
}
aur(){
    file=$*
    git clone https://aur.archlinux.org/$file.git
    cd $file
    makepkg -si
    cd ..
    rm -rf $file
}
screencast(){
    file=$*
    pactl load-module module-loopback
    ffmpeg -hide_banner -f pulse -ac 2 -i alsa_output.pci-0000_00_1b.0.analog-stereo.monitor -f x11grab -s 1920x1080 -i :0.0 -c:v h264_nvenc -preset lossless -rc cbr_hq $file
    pactl unload-module module-loopback
}
gyf(){
    user=$*
    curl -s -L https://www.youtube.com/user/$user/videos/ | sfeed_web | cut -f 1
}
mktex(){
    file=$*
    vim $file.tex
    pdflatex $file.tex
    mupdf $file.pdf
}
mkms(){
    file=$*
    GTK_THEME=Adwaita:dark gedit $file.ms
    groff -ms $file.ms -T pdf > $file.pdf
    mupdf $file.pdf
}
mksh(){
    file=$*
    vim $file.sh
    if [ -x $file.sh ]; then
        shellcheck -s sh $file.sh && ./$file.sh
    else
        chmod +x $file.sh && shellcheck -s sh $file.sh && ./$file.sh
    fi
}
npatch(){
    file=$*
    patch -p1 < $file
    rm $file
}
#arroz(){
#    cd ~/ && cp -rf .src/ .dwm/ .sfeed/ .slstatus/ .bashrc .bash_profile .gitconfig .vimrc .xinitrc .xbindkeysrc .xsession ~/Documents/Git/arroz/
#    cp -rf ~/.config/picom.conf ~/.config/vifm ~/Documents/Git/arroz/.config/
#    echo "Now pls: upgit arroz"
#}
upgit(){
    repo=$*
    if [[ $repo == "imgs" ]]; then
        cd ~/Pictures
    else
        cd ~/Documents/GitHub/$repo
    fi
    git rm -r --cached .
    git add .
    git commit -m "update"
    git push origin master
    cd -
}
