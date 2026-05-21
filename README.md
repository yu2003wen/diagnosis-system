# 实体店经营诊断系统 · 部署指南

## 系统架构

```
客户打开表单（form.html） → 填写 → 提交 → Supabase 数据库
                                               ↓
                顾问登录后台（admin.html） ← 读取数据
```

- **数据库**：Supabase（PostgreSQL，免费额度够用）
- **前端**：纯 HTML/CSS/JS，部署在 Vercel（免费）
- **无需自己写代码，无需服务器**

---

## 第一步：注册 Supabase 并创建数据库

Supabase 相当于在云端给你一个数据库，不需要自己搭建服务器。

### 1.1 注册账号

1. 打开 https://supabase.com
2. 点击右上角 **"Start your project"**
3. 用 GitHub 账号登录（没有就注册一个 GitHub 账号，免费）
4. 授权后进入控制台

### 1.2 创建项目

1. 点击 **"New project"**
2. 填写：
   - **Name**：输入 `diagnosis-system`（或任意名字）
   - **Database Password**：设置一个密码（**务必记下来**，后面用不到但丢了就找不回来了）
   - **Region**：选择 **Singapore**（亚太地区，国内访问速度最快）
   - **Pricing Plan**：选 **Free**（免费版足够）
3. 点击 **"Create new project"**
4. 等待 1-2 分钟，直到项目创建完成

### 1.3 获取配置信息

项目创建完成后：

1. 在左侧菜单点击 **Project Settings**（齿轮图标）→ **API**
2. 找到以下两个信息，**复制保存**，后面要用：

```
Project URL（项目地址）= https://xxxxxxx.supabase.co
anon public key（匿名密钥）= eyJhbGciOiJIUzI1NiIs...
```

3. 另外，记下你的 **Project Ref**（在 Project Settings 最上面的 URL 里，如 `https://supabase.com/project/abcdefg` 中的 `abcdefg`）

### 1.4 创建数据表

1. 在左侧菜单点击 **SQL Editor**
2. 点击 **"New query"** 或 **"+ New Query"**
3. 在弹出的编辑器中，**删除默认内容**
4. 打开当前文件夹里的 `schema.sql` 文件，全选复制里面的所有内容
5. 粘贴到 Supabase 的 SQL 编辑器中
6. 点击 **"Run"** 或 **"▶ Run"** 按钮（有个三角形播放图标）
7. 等待几秒，看到绿色提示 "Success. No rows returned" 表示成功

### 1.5 开启邮箱密码登录（用于管理后台）

1. 在左侧菜单点击 **Authentication** → **Providers**
2. 找到 **Email**，确保是 **Enabled** 状态（默认应该是开的）
3. 确保 **"Confirm email" 是关闭状态**（这样后台可以直接登录，不需要邮箱验证）
   - 点击 **Email** 进入设置
   - 找到 **"Confirm email"**，关掉它
   - 点击 **Save**

### 1.6 创建管理员账号

1. 在左侧菜单点击 **Authentication** → **Users**
2. 点击 **"Add user"** 按钮
3. 输入管理员的：
   - **Email**：你自己用的邮箱（如 `admin@你的店.com`）
   - **Password**：设置一个密码（比如 `admin123456`）
4. 点击 **"Create user"**
5. 完成！这个账号就是登录管理后台用的

---

## 第二步：部署表单页面到 Vercel

Vercel 相当于一个免费的网站托管服务，把你的网页放上去，客户就能通过网址访问。

### 2.1 注册 Vercel

1. 打开 https://vercel.com
2. 点击 **"Sign Up"** → **"Continue with GitHub"**
3. 授权登录后进入控制台

### 2.2 准备文件

在你电脑上：

1. 找到本项目的文件夹 `diagnosis-system`
2. 打开 `form.html` 和 `admin.html`，找到文件开头的这段代码：

```javascript
const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key-here';
```

3. 替换为你在第一步获取的实际值：

```javascript
const SUPABASE_URL = 'https://你项目的地址.supabase.co';
const SUPABASE_ANON_KEY = '你的匿名密钥';
```

4. 保存两个文件

### 2.3 上传到 GitHub

Vercel 需要从 GitHub 拉取文件，所以需要先把文件上传到 GitHub：

**如果还没有 GitHub 账号：**
1. 打开 https://github.com 注册一个账号

**如果已经有 GitHub 账号：**
1. 登录 GitHub，点击右上角 **+** → **New repository**
2. Repository name 填 `diagnosis-system`
3. 选 **Public**（公开）或 **Private**（私有）都可以
4. 点击 **"Create repository"**
5. 按照页面上的提示，把本地的文件上传：
   ```bash
   # 在电脑终端中执行（如果不会用终端，也可以用 GitHub 网页版上传）
   git init
   git add .
   git commit -m "first commit"
   git branch -M main
   git remote add origin https://github.com/你的用户名/diagnosis-system.git
   git push -u origin main
   ```

**如果不会用终端**，也可以在 GitHub 仓库页面点击 **"Add file"** → **"Upload files"**，然后把 `diagnosis-system` 文件夹里的所有文件拖进去上传。

### 2.4 在 Vercel 部署

1. 登录 Vercel 控制台
2. 点击 **"Add New"** → **"Project"**
3. 找到你刚创建的 GitHub 仓库 `diagnosis-system`，点击 **"Import"**
4. 在配置页面：
   - **Framework Preset**：选 **"Other"**
   - **Root Directory**：保持默认
   - 其他都不需要改
5. 点击 **"Deploy"**（部署）
6. 等待约 1-2 分钟，看到 **"Congratulations!"** 表示部署成功
7. 你会得到一个网址，类似：`https://diagnosis-system.vercel.app`

---

## 第三步：使用系统

### 客户填写表单

- **表单链接**：`https://你的域名.vercel.app/`
  - 发给客户，客户打开就能填写
  - 手机和电脑都适配
  - 提交后数据自动存入 Supabase 数据库

### 顾问查看数据

- **管理后台**：`https://你的域名.vercel.app/admin`
  - 用你在 Supabase 创建的管理员邮箱和密码登录
  - 登录后看到所有客户提交的数据
  - 可以筛选、搜索、查看详情
  - 可以标记处理状态（待处理→已读→处理中→已完成）

### 如果不想用 vercel.app 的域名

可以在 Vercel 项目设置中绑定你自己的域名：
1. 在 Vercel 项目页面点击 **Settings** → **Domains**
2. 输入你的域名，按提示配置 DNS 即可

---

## 常见问题

### Q: 客户数据安全吗？
A: 安全。表单只允许提交（插入）数据，其他人无法查看数据。只有用管理员账号登录后才能看到全部客户数据。所有数据通过 HTTPS 加密传输。

### Q: 免费额度够用吗？
A: 完全够用。Supabase 免费版提供 500MB 数据库空间、5GB 带宽、50,000 条月活记录——对于诊断服务来说，一年几千个客户都没问题。Vercel 免费版每月 100GB 带宽，完全够用。

### Q: 客户表单可以嵌入到我的网站里吗？
A: 可以。用 iframe 嵌入：
```html
<iframe src="https://你的域名.vercel.app/" width="100%" height="800" frameborder="0"></iframe>
```

### Q: 我想修改表单的问题怎么办？
A: 直接修改 `form.html` 文件，然后重新上传到 GitHub。Vercel 会自动重新部署（等待 1-2 分钟生效）。

### Q: 能导出数据到 Excel 吗？
A: 可以。在 Supabase 控制台：
1. 左侧菜单点击 **Table Editor**
2. 找到 `submissions` 表
3. 点击右上角的 **"Export"** → **"Export to CSV"**

---

## 后续可扩展的功能

这个系统搭好后，后续可以一步步升级：

1. **提交后自动发送确认短信**：对接短信 API
2. **自动生成诊断报告**：根据提交数据自动填充 Word 报告模板
3. **多顾问支持**：每个顾问只能看自己的客户
4. **客户看板**：客户登录后可以查看自己的报告历史
5. **一键导出**：在管理后台加一个导出 Excel 按钮
---
