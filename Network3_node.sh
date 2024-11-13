#!/bin/bash

INSTALLATION_PATH="$HOME/blockmesh"
USER_ACCOUNT="twopig168@gmail.com"  # 使用您的账号信息

show_message() {
    local color="$1"
    shift
    echo -e "\e[${color}m$*\e[0m"
}

exit_script() {
    show_message "31" "脚本已停止"
    exit 0
}

process_notification() {
    show_message "33" "$1"
    sleep 1
}

run_commands() {
    if eval "$*"; then
        sleep 1
        show_message "32" "成功"
    else
        sleep 1
        show_message "31" "失败"
    fi
}

run_node_command() {
    if eval "$*"; then
        sleep 1
        show_message "32" "节点已启动!"
    else
        show_message "31" "节点未启动!"
    fi
}

while true; do
    show_message "32" "----- 主菜单 -----"
    echo "1. 安装"
    echo "2. 日志"
    echo "3. 启动/停止"
    echo "4. 删除"
    echo "5. 节点数据"
    echo "6. 退出"
    echo -n "请选择一个选项: "
    read option

    case $option in
        1)
            process_notification "开始安装..."

            process_notification "更新包..."
            run_commands "sudo apt update && sudo apt upgrade -y && apt install tar net-tools -y"

            process_notification "创建文件夹..."
            run_commands "mkdir -p $HOME/network3 && cd $HOME/network3"

            process_notification "下载..."
            run_commands "wget -O ubuntu-node-latest.tar https://network3.io/ubuntu-node-v2.1.0.tar"

            process_notification "解压..."
            run_commands "tar -xvf ubuntu-node-latest.tar && rm ubuntu-node-latest.tar"

            show_message "32" "安装完成!"
            ;;
        2)
            # MY_IP=$(hostname -I | awk '{print $1}')
            process_notification "访问日志: https://account.network3.ai/main?o=119.28.49.84:8080"
            ;;
        3)
            echo "1. 启动"
            echo "2. 停止"
            echo -n "请选择一个选项: "
            read option
            case $option in
                1)
                    process_notification "启动中..."
                    run_node_command "cd $HOME/network3/ubuntu-node/ && ACCOUNT_EMAIL=$USER_ACCOUNT ./manager.sh up"
                    ;;
                2)
                    process_notification "停止中..."
                    run_commands "cd $HOME/network3/ubuntu-node/ && ./manager.sh down"
                    ;;
                *)
                    show_message "31" "无效选项"
                    ;;
            esac
            ;;
        4)
            process_notification "删除节点"
            process_notification "停止中..."
            run_commands "cd $HOME/network3/ubuntu-node/ && ./manager.sh down"
            process_notification "删除文件..."
            run_commands "rm -rvf $HOME/network3"
            show_message "32" "节点已删除"
            ;;
        5)
            process_notification "节点密钥"
            run_commands "cd $HOME/network3/ubuntu-node/ && ./manager.sh key"
            ;;
        6)
            exit_script
            ;;
        *)
            show_message "31" "无效选项，请重试"
            ;;
    esac
done
