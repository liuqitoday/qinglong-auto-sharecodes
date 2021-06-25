#!/usr/bin/env bash

#dir_shell=/ql/config
dir_shell=/Users/liuqi/Downloads/temp
code_shell_path=$dir_shell/code.sh
task_before_shell_path=$dir_shell/task_before.sh

# 下载code.sh
curl -s --connect-timeout 3 https://raw.githubusercontent.com/liuqitoday/qinglong-auto-sharecodes/master/code.sh > $code_shell_path

# 判断是否下载成功
if [ ! -f "$code_shell_path" ]; then
    echo "code.sh 下载失败"
    exit 0
fi

# 授权
chmod 755 $code_shell_path

# 替换 code.sh 中的仓库名
sed -i '' 's/chinnkarahoi/JDHelloWorld/g' $code_shell_path

# 将 code.sh 添加到定时任务

# 下载 task_before.sh
curl -s --connect-timeout 3 https://raw.githubusercontent.com/liuqitoday/qinglong-auto-sharecodes/master/task_before.sh > $task_before_shell_path

# 判断是否下载成功
task_before_size=$(ls -l $task_before_shell_path | awk '{print $5}')
if (( $(echo "${task_before_size} < 100" | bc -l) )); then
    echo "task_before.sh 下载失败"
    exit 0
fi