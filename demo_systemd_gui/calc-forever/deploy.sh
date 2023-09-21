#! /usr/bin/env bash

mkdir -p ~/.config/systemd/user
cp ./calc-forever.service ~/.config/systemd/user/
cp ./xsession.target ~/.config/systemd/user/
cp ./xsessionrc ~/.xsessionrc
systemctl --user enable calc-forever.service
systemctl --user start calc-forever.service
