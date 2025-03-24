#!/bin/bash

wipe_commit_history() {
    FOLDER_NAME=$1
    BRANCH_NAME=$2

    cd $HOME/media/$FOLDER_NAME || exit
    git checkout --orphan new-branch
    git add .
    git commit -m "chore: wipe commit history"
    git push origin new-branch:"$BRANCH_NAME" --force
    git commit -m "chore: cleanup"
    git checkout $BRANCH_NAME
    git pull --rebase
    cd ..
}

wipe_commit_history "walls" "main"
wipe_commit_history "walls-catppuccin-mocha" "master"