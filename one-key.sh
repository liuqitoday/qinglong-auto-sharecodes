#!/usr/bin/env bash

dir_shell=/ql/config
dir_script=/ql/scripts
code_shell_path=$dir_script/code.sh
task_before_shell_path=$dir_shell/task_before.sh

# 下载code.sh
if [ ! -a "$code_shell_path" ]; then
    touch $code_shell_path
fi
curl -s --connect-timeout 3 https://raw.githubusercontent.com/liuqitoday/qinglong-auto-sharecodes/master/code.sh > $code_shell_path

# 判断是否下载成功
code_size=$(ls -l $code_shell_path | awk '{print $5}')
if (( $(echo "${code_size} < 100" | bc -l) )); then
    echo "code.sh 下载失败"
    exit 0
fi

# 授权
chmod 755 $code_shell_path

# 替换 code.sh 中的仓库作者名
echo -n "输入你的jd_scripts仓库作者名(默认为JDHelloWorld):"
read -r repoAuthor
repoAuthor=${repoAuthor:-'JDHelloWorld'}
sed -i "s/chinnkarahoi/$repoAuthor/g" $code_shell_path

# 将 code.sh 添加到定时任务
if [ "$(grep -c code.sh /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task code.sh"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"生成内部互助码","command":"task code.sh","schedule":"6 7 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi

# 下载 task_before.sh
curl -s --connect-timeout 3 https://raw.githubusercontent.com/liuqitoday/qinglong-auto-sharecodes/master/task_before.sh > $task_before_shell_path

# 判断是否下载成功
task_before_size=$(ls -l $task_before_shell_path | awk '{print $5}')
if (( $(echo "${task_before_size} < 100" | bc -l) )); then
    echo "task_before.sh 下载失败"
    exit 0
fi