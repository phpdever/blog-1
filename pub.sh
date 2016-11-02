#!/bin/sh
#先提交自己
git add .
git commit -am "auto publish"
git push origin master
#然后编辑发布线上版本
cross-env NODE_ENV=production webpack --progress --hide-modules
mkdir publish
cp ./static ./publish/static -rf
cp ./index.html ./publish/index.html -rf
cp ./CNAME ./publish/CNAME -rf
# 开始计算js的新名字

cd publish
jsName=$(ls static|grep \.js)
jsName=$(date +%s)${jsName}
echo "重新修正js路径为:$jsName"
sed -i "s/\build\.js\/$jsName/g" ./index.html
echo "" > .gitignore
git init
git add .
git commit -am "publish"
git push --force --quiet https://github.com/Rozbo/blog.git master:gh-pages
cd ../
rm -rf ./publish
rm -rf ./static
echo "everything ok!"
