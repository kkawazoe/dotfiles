#!/bin/bash
set -e
OS="$(uname -s)"
DOT_DIRECTORY="${HOME}/dotfiles"
REMOTE_URL="git@github.com:kkawazoe/dotfiles.git"

# 該当コマンドが存在するかどうか
has() {
  type "$1" > /dev/null 2>&1
}

# 使用方法
usage() {
  name=`basename $0`
  cat <<EOF
Usage:
  $name [arguments] [command]

Commands:
  deploy
  initialize

Arguments:
  -f $(tput setaf 1)** warning **$(tput sgr0) Overwrite dotfiles.
  -h Print help (this message)
EOF
  exit 1
}

while getopts :f:h opt; do
  case ${opt} in
    f)
      OVERWRITE=true
      ;;
    h)
      usage
      ;;
  esac
done
shift $((OPTIND - 1))

# dotfiles ディレクトリがない場合にリポジトリから取得して展開する
if [ ! -d ${DOT_DIRECTORY} ]; then
  echo "Downloading dotfiles..."
  mkdir ${DOT_DIRECTORY}

  if has "git"; then
    git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
  else
    echo $(tput setaf 1)Not Installed Git!!$(tput sgr0)
    exit 1
  fi

  echo $(tput setaf 2)Download dotfiles complete!. ✔︎$(tput sgr0)
fi

cd ${DOT_DIRECTORY}
source ./lib/brew

# シンボリックリンク作成
link_files() {
  for f in .??*
  do
    # 既にディレクトリが存在する場合は強制削除する
    [ -n "${OVERWRITE}" -a -e ${HOME}/${f} ] && rm -f ${HOME}/${f}
    if [ ! -e ${HOME}/${f} ]; then
      # skip 対象のディレクトリをここに追加
      [[ ${f} = ".git" ]] && continue
      [[ ${f} = ".gitignore" ]] && continue
      ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
    fi
  done

  echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
}

# 初期化
initialize() {
  case ${OSTYPE} in
    darwin*)
      #run_brew

#       if [ ! -e ~/Library/Fonts/Cica-Regular.ttf ]; then
#         wget https://github.com/miiton/Cica/releases/download/v4.1.1/Cica-v4.1.1.zip
#         unar Cica-v4.1.1.zip
#         cp -f Cica-v4.1.1/Cica*.ttf ${HOME}/Library/Fonts/
#         rm -rf Cica-v4.1.1*
#       fi
      ;;
    *)
      echo $(tput setaf 1)Working only OSX!!$(tput sgr0)
      exit 1
      ;;
  esac

#   [ ${SHELL} != "/bin/zsh"  ] && chsh -s /bin/zsh

  if [ ! -d ${HOME}/.anyenv ]; then
    git clone https://github.com/anyenv/anyenv ~/.anyenv
    anyenv install rbenv
    anyenv install ndenv
    exec $SHELL -l
  fi

  set +e
  if has "rbenv"; then
    [ ! -d $(rbenv root)/plugins/rbenv-default-gems ] && git clone -q https://github.com/rbenv/rbenv-default-gems.git $(rbenv root)/plugins/rbenv-default-gems
    [ ! -e $(rbenv root)/default-gems ] && cp ${DOT_DIRECTORY}/default-gems $(rbenv root)/default-gems
  fi

  echo "$(tput setaf 2)Initialize complete!. ✔︎$(tput sgr0)"
}

command=$1
[ $# -gt 0 ] && shift

case $command in
  deploy)
    link_files
    ;;
  init*)
    initialize
    ;;
  *)
    usage
    ;;
esac

exit 0
