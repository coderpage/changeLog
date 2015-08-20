# changeLog

**changeLog** 用于 **Git** 版本库生成更新记录的工具；可以通过读取每个 Tag 下的 commit 记录和更新记录，自动的生成一个 MarkDown 格式的 changeLog 文档。


### 使用方法
- 在 `log.sh` 同级目录下创建一个 `changelog.txt` 文件
> `changelog.txt` 文件用于记录每个版本的更新记录，需要手动编写</br>
> 格式要求：每个记录占一行，最后一行留空，例：

 	```
	添加xxx功能
	删除xxx功能
	(最后一行为空，为了便于读取)
	```

- 运行 `./log.sh` 生成 changelog.md 文件
> **注意：** 运行命令前，一定要 commit 当前所在分支的改动，否则会失败