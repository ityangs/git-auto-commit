#!/bin/bash
function gitTag() {
    cd $projectPath
    git push
    git pull --tags
    local new_tag=$(echo ${prefix}-$(date +'%Y%m%d')-$(git tag -l "${prefix}-$(date +'%Y%m%d')-*" | wc -l | xargs printf '%02d'))
    echo ${new_tag}
    git tag ${new_tag}
    git push origin $new_tag
}

declare projectPath=$1
declare prefix=$2
gitTag $projectPath $prefix
