#!/bin/bash
#Author: Abner-L 2015-08-10

log_file_temp=log_temp.md
pipe_temp_file=temp.txt

log_file=changelog.md
log_file_tag=changelog.txt


rm -f ${log_file}
rm -f ${log_file_temp}

current_branch=`git branch | sed -e '/^[^*]/d' -e 's/^*//'`


function readLog
{
    echo "#### 更新记录" >> ${log_file_temp}
    echo '    ' >> ${log_file_temp}

    if [ ! -f ${log_file_tag} ];then

    echo '** 此版本没有设置 changelog.txt **' >> ${log_file_temp}

    else

    cat ${log_file_tag} | while read LINE
    do
        [ -z $LINE ] && continue
        echo "- $LINE" >> ${log_file_temp}
    done

    fi
    echo '    ' >> ${log_file_temp}
}


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
        GIT_PAGER=cat git log --no-merges --date=short  --pretty=format:'- %ad (%an) %s -> [view commit](https://github.com/RNTD/AndroidOpenSDK/commit/%H)' $TAG..$NEXT >> ${log_file_temp}
        echo '    ' >> ${log_file_temp}

    else

        echo "## 当前" >> ${log_file_temp}
        readLog
        echo '#### commit 记录' >> ${log_file_temp}
        echo '    ' >> ${log_file_temp}
        GIT_PAGER=cat git log --no-merges --date=short  --pretty=format:'- %ad (%an) %s -> [view commit](https://github.com/RNTD/AndroidOpenSDK/commit/%H)' $TAG.. >> ${log_file_temp}
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
    GIT_PAGER=cat git log --no-merges --date=short  --pretty=format:'- %ad (%an) %s -> [view commit](https://github.com/RNTD/AndroidOpenSDK/commit/%H)' $current_tag >> ${log_file_temp}
    echo '    ' >> ${log_file_temp}


git checkout $current_branch

cp ${log_file_temp} ${log_file}
rm -f ${log_file_temp}
rm -f ${pipe_temp_file}

echo "DONE."

