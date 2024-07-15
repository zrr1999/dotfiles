# My dotfiles


## install
```sh
curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
&& chmod a+x /tmp/yadm \
&& /tmp/yadm clone https://github.com/zrr1999/dotfiles.git \
&& /tmp/yadm bootstrap \
&& rm /tmp/yadm
```

### arch
```sh
echo "Setting up pacman mirrorlist"
pacman -S --noconfirm --needed reflector
reflector --save /etc/pacman.d/mirrorlist --country China --protocol https --latest 5
```


## zsh config

## bootstrap

## ssh config
