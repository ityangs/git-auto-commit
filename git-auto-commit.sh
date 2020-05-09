#!/bin/bash
# git init
function initStart() {
  echo " ============================================================================="
  echo " ====================================START===================================="
  echo " ============================================================================="
  echo " ========================git-auto-commit【$projectName】======================"
  echo " ================================1、进入项目 =================================="
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
    read branch
    if [ ${branchArr[$branch]} ]; then
      selectBranch=${branchArr[$branch]}
    else
      selectBranch=$branch
    fi

    #验证分支是否存在
    if [ -n "$(git branch -r | grep $selectBranch)" ]; then
      #切换分支
      if [ -n "$(git branch | grep $selectBranch)" ]; then
        git checkout $selectBranch
      else
        echo "本地不存在该分支,自动创建新分支:$selectBranch"
        git checkout -b $selectBranch origin/$selectBranch
      fi
      return 1
    else
      echo "分支不存在:$selectBranch,请重新输入:"
    fi
  done
}

# git pull
function gitPull() {
  echo " ==================================3、gitPull ================================"
  git pull origin $selectBranch
  if [ $? == 0 ]; then
    istrue=0
    echo $istrue
  else
    echo "请输入正确的分支名称"
  fi
}

# git add
function gitAdd() {
  echo " =================================4、gitAdd ================================="
  git add --all
  if [ ! -n "$description" ]; then
    echo "请输入提交描述文字如果没有默认: fix:调整细节提交代码"
    read description
  fi
  if [ ! -n "$description" ]; then
    description="调整细节提交代码"
  fi
  echo "提交描述文字:$description"
  git commit -m $description
}

# git push
function gitPush() {
  echo " =================================5、gitPush ================================="
  git push origin $selectBranch
  if [ $? == 0 ]; then
    istruetwo=0
    echo $istruetwo
  else
    echo "请输入正确的分支名称"
  fi
}

function initEnd() {
  echo " ============================================================================="
  echo " ====================================END===================================="
  echo " ============================================================================="
}

#--------------------------------------------
declare projectName=$1
declare projectPath=$2
declare selectBranch=$3
declare description=$4
#声明分支
declare branchArr=(
  [0]=master
  [1]=develop
  [2]=test
  [3]=testing
)

#1、进入项目
initStart $projectName $projectPath

#2、选择分支
if [ ! -n "$selectBranch" ]; then
  selectBranch $branchArr
fi
echo "操作的分支是:$selectBranch"

#3、拉取最新的代码
gitPull $selectBranch

#4、添加改动文件
gitAdd

#5、提交改动文件
#gitPush $selectBranch

#6、结束
initEnd
