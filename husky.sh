
echo -n "\033[1;0H\033[2J"

if [[ ! -e ".git" ]]; then
  echo -e "\033[1m\033[31m❯\033[31m 初始化本地GIT仓库\033[0m"

  git init > /dev/null 2>&1

  if [ ! $? -eq 0 ]; then
    return 127
  fi

  echo -e "\033[1m\033[32m✔️\033[31m 本地GIT仓库初始化完成\033[0m"
fi

ping -c 1 114.114.114.114 > /dev/null 2>&1

if [ $? -eq 0 ];then
  echo -e "\033[33m❯ 开始安装依赖包... \033[0m"
else
  echo -e "\033[1m\033[31m❯\033[31m 无法链接到网络，请稍后重试。\033[0m"
  return 128
fi

npm install --save-dev husky commitizen lint-staged > /dev/null 2>&1

if [ ! $? -eq 0 ]; then
  echo -e "\033[1;0H\033[K\033[1m\033[31m× 依赖包安装出错，再见~ \033[0m"
  return 127
else
  echo -e "\033[1;0H\033[K\033[32m✔️ 完成依赖包安装 \033[0m"
fi

echo -e "\033[32m❯ 开始初始化 husky... \033[0m"
npx husky install > /dev/null 2>&1

if [ ! $? -eq 0 ]; then
  echo -e "\033[2;0H\033[K\033[1m\033[31m× 初始化失败，再见~ \033[0m"
  return 127
fi

npx husky set .husky/pre-commit "npx lint-staged"

if [ ! $? -eq 0 ]; then
  echo -e "\033[2;0H\033[K\033[1m\033[31m× 初始化失败，再见~ \033[0m"
  return 127
else
  echo -e "\033[2;0H\033[K\033[32m✔️ 完成初始化 \033[0m"
fi

git add .husky/pre-commit && git commit -m 'add husky' > /dev/null 2>&1

