#!/bin/bash
# git init
function initStart() {
  echo " ================================ init 发布初始化 =================================="
  echo "projectPath=$projectPath"
  cd $projectPath
}

# selectBranch
function selectBranch() {
  echo " ==============================2、selectBranch ==============================="
  echo "请输入要选择的分支名称"
  for i in "${!branchArr[@]}"; do
    printf "%s->%s\n" "$i" "${branchArr[$i]}"
  done
  echo "请输入编号【如果是其他分支请直接输入分支名称】:"
  istrue=1
  while [ $istrue == 1 ]; do
    #选择分支
    if [ ! -n "$selectBranch" ]; then
      read branch
      if [ ${branchArr[$branch]} ]; then
        selectBranch=${branchArr[$branch]}
      else
        selectBranch=$branch
      fi
    fi

    #验证分支是否存在
    if [ -n "$(git branch -r | grep $selectBranch)" ]; then
      #切换分支
      if [ -n "$(git branch | grep $selectBranch)" ]; then
        echo "自动切换分支:$selectBranch"
        git checkout $selectBranch
      else
        echo "本地不存在该分支,自动创建新分支:$selectBranch"
        git checkout -b $selectBranch origin/$selectBranch
      fi
      istrue=0
      echo "操作的分支是:$selectBranch"
    else
      echo "分支不存在:$selectBranch,请重新输入:"
      selectBranch=""
    fi
  done
}

# git pull
function gitPull() {
  git pull origin $selectBranch
  if [ $? == 0 ]; then
    istrue=0
    echo $istrue
  else
   echo "No git pull data"
  fi
}

#--------------------------------------------
declare projectName=$1
declare projectPath=$2
declare selectBranch=$3
declare description=$4
#声明分支
declare branchArr=(
  [1]=master
  [2]=develop
  [3]=test
  [4]=testing
)

#1、进入项目
initStart $projectName $projectPath

#2、选择分支
selectBranch $branchArr

#3、拉取最新的代码
gitPull $selectBranch
