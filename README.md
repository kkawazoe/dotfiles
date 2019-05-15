# dotfiles

# initialize

```bash
$ git clone https://github.com/kkawazoe/dotfiles.git
$ bash -c "$(curl -fsSL raw.github.com/kkawazoe/dotfiles/master/setup.sh)" -- initialize
```

# deploy

```bash
$ bash -c "$(curl -fsSL raw.github.com/kkawazoe/dotfiles/master/setup.sh)" -- -f -s deploy
$ sudo vi /etc/shells
Password:
/usr/local/bin/zsh # 追記
$ chsh -s /usr/local/bin/zsh
Changing shell for test_user.
Password for test_user:
```
