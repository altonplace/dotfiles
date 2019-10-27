#!/bin/sh

pip_packages=(
  'virtualenv'
  'requests'
  'gnupg'
  'pandas'
  'numpy'
)


install_pip_packages(){
  for packages in ${pip_packages[@]}; do
    pip3 install $packages
  done
}

install_pip_packages
