#!/bin/bash
#1、变量
declare projectRootPath="/xx/xx/xx/xx/xxxx" #必填 即将提交项目的绝对路径
declare projectName="demo" #选填，项目名称
declare branchName="" #选填，项目操作的分支  为空会在命令行输入
declare gitCommitDesc="" #选填，项目操作提交的描述 为空会在命令行输入
declare gitAutoCommitPath=$(pwd)

#2、shell自动化提交代码"
/bin/bash $gitAutoCommitPath/git-auto-commit.sh $projectName $projectRootPath $branchName $gitCommitDesc




