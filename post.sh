#确定当前目录为hexo工作根目录
echo  -e "\033[32;49;1m [正在提交新文章]"
git  add  .
git  commit  -am "Update Docs"
echo -e "\033[32;49;1m 提交成功，正在推送至远程仓库...\033[39;49;0m"
git  push origin blog-source
echo -e  "\033[32;49;1m 源文件推送成功...\033[39;49;0m"
echo  -e  "\033[32;49;1m 正在生成静态页面...\033[39;49;0m"
hexo g
echo -e "\033[32;49;1m 正在推送静态页面...\033[39;49;0m"
hexo d
echo  -e "\033[32;49;1m 全部搞定！！！\033[39;49;0m"