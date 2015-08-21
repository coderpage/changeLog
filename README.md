# changeLog

**changeLog** 用于 **Git** 版本库生成更新记录的工具；可以通过读取每个 Tag 下的 commit 记录和更新记录，自动的生成一个 MarkDown 格式的 changeLog 文档。


### 使用方法
- 拷贝 `lib` 文件夹到项目中

- `log.properties` 文件中配置git仓库地址

- 在 `tag_log` 文件夹中创建各个tag的更新记录文件
> tag更新记录文件用于记录每个版本的更新记录，需要手动编写，文件名称必须与tag名称相同</br>
> 当前工作的分支下的更新记录，写在 `current` 文件中</br>
> 格式要求：每个记录占一行，最后一行留空，例：</br>
	当前有两个版本：v1.0、v2.0</br>
	为v1.0版本编写更新记录，tag_log目录下创建名称为 v1.0 的文件，添加内容：
	
 	```
	添加xxx功能
	删除xxx功能
	(最后一行为空，为了便于读取)
	```

- 运行 `./log.sh` 生成 changelog.md 文件
