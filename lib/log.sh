#!/bin/bash
#Author: Abner-L 2015-08-10

log_file_temp=log_temp.md
pipe_temp_file=temp.txt

log_file=changelog.md
log_file_tag=changelog.txt

repos_url=


rm -f ${log_file}
rm -f ${log_file_temp}

# 获取当前分支名称
current_branch=`git branch | sed -e '/^[^*]/d' -e 's/^*//'`

# 获取 log.properties 配置文件内容
while read properties
    do
        if [ "x${properties}" == "x" ]; then
            continue
        fi

        name=`echo ${properties} | cut -d = -f 1`
        value=`echo ${properties} | cut -d = -f 2`

        case "${name}" in

        "repository" ) repos_url=${value};;

        esac

    done < log.properties

# 读取当前 tag 下的 changelog.txt 内容，并写入 changelog.md
function readLog
{
    echo "#### 更新记录" >> ${log_file_temp}
    echo '    ' >> ${log_file_temp}

    if [ ! -f ${log_file_tag} ];then

    echo '*此版本没有设置 changelog.txt*' >> ${log_file_temp}

    else

    cat ${log_file_tag} | while read LINE
    do
        if [ "x${LINE}" == "x" ]
            then
            continue
        fi

        echo "- $LINE" >> ${log_file_temp}
    done

    fi
    echo '    ' >> ${log_file_temp}
}

# 遍历所有 tag，获取 commit 信息
git for-each-ref --sort='*authordate' --format='%(tag)' refs/tags | grep -v '^$' | tail -r > ${pipe_temp_file}
while read TAG ; do

    if [ $NEXT ];then

        echo '    ' >> ${log_file_temp}
        echo '---' >> ${log_file_temp}
        echo "## ${NEXT}"  >> ${log_file_temp}
        readLog
        echo '    ' >> ${log_file_temp}
        echo '#### commit 记录' >> ${log_file_temp}
        echo '    ' >> ${log_file_temp}
        GIT_PAGER=cat git log --no-merges --date=short  --pretty=format:'- %ad (%an) %s -> [view commit](${repos_url}/commit/%H)' $TAG..$NEXT >> ${log_file_temp}
        echo '    ' >> ${log_file_temp}

    else

        echo "## 当前" >> ${log_file_temp}
        readLog
        echo '#### commit 记录' >> ${log_file_temp}
        echo '    ' >> ${log_file_temp}
        GIT_PAGER=cat git log --no-merges --date=short  --pretty=format:'- %ad (%an) %s -> [view commit](${repos_url}/commit/%H)' $TAG.. >> ${log_file_temp}
        echo '    ' >> ${log_file_temp}

    fi

    git checkout ${TAG}
    NEXT=${TAG}
    current_tag=$TAG
done<${pipe_temp_file}

    echo $current_tag
    echo '    ' >> ${log_file_temp}
    echo '---' >> ${log_file_temp}
    echo "## "$current_tag  >> ${log_file_temp}
    readLog
    echo '    ' >> ${log_file_temp}
    echo '#### commit 记录' >> ${log_file_temp}
    echo '    ' >> ${log_file_temp}
    GIT_PAGER=cat git log --no-merges --date=short  --pretty=format:'- %ad (%an) %s -> [view commit](${repos_url}/%H)' $current_tag >> ${log_file_temp}
    echo '    ' >> ${log_file_temp}

# 切换回工作分支
git checkout $current_branch

# 将 temp 文件内容拷贝到 changelog.md
cp ${log_file_temp} ${log_file}

# 删除临时文件
rm -f ${log_file_temp}
rm -f ${pipe_temp_file}

echo "DONE."

