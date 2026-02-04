#!/bin/bash

# 设置脚本的错误处理
set -e  # 如果发生错误，则退出

# 1. 确保当前目录为 Git 仓库根目录
if [ ! -d ".git" ]; then
    echo "Error: Not a git repository. Please run this script from the root of your Git repository."
    exit 1
fi

# 2. 检查 _site 目录是否存在，如果没有则构建 Jekyll 网站
if [ ! -d "_site" ]; then
    echo "Building the Jekyll site..."
    bundle exec jekyll build  # 生成静态文件
else
    echo "_site directory already exists. Skipping build..."
fi

# 3. 切换到 gh-pages 分支
echo "Switching to the gh-pages branch..."
git checkout gh-pages

# 4. 删除旧的 _site 内容，并将新的静态文件推送到 gh-pages 分支
echo "Updating gh-pages branch with the latest build..."
git rm -rf .  # 删除现有的文件
cp -r _site/* .  # 将构建的文件复制到当前目录

# 5. 提交更改
git add -A
git commit -m "Deploy latest build to gh-pages"

# 6. 推送到远程仓库的 gh-pages 分支
git push origin gh-pages

# 7. 提示完成
echo "Deployment to GitHub Pages successful!"

# 8. 回到主分支（可选）
git checkout main
