-- ============================================================
-- 实体店经营诊断系统 - Supabase 数据库建表脚本
-- 使用方法：在 Supabase SQL Editor 中执行
-- ============================================================

-- 1. 客户自诊表提交记录表
create table if not exists submissions (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default now(),
  status text default 'new' check (status in ('new', 'read', 'processing', 'completed')),

  -- ---- 客户基本信息 ----
  store_name text not null,          -- 店铺名称
  owner_name text not null,          -- 老板姓名
  phone text not null,               -- 手机号
  category text,                     -- 品类：餐饮/零售/美业/服务/其他
  open_time text,                    -- 开业时长
  employees text,                    -- 员工人数
  monthly_revenue text,              -- 月均营业额
  rent text,                         -- 月租金
  location text,                     -- 店铺位置类型
  area text,                         -- 经营面积
  main_problem text,                 -- 最想解决的问题
  expected_gain text,                -- 期望每月多赚多少钱

  -- ---- 客流维度 (Q1-Q3) ----
  q1_flow_people text,               -- 每天进店人数
  q2_flow_reason text,               -- 客流少的原因
  q3_flow_tracking text,             -- 是否统计门前客流

  -- ---- 成交维度 (Q4-Q6) ----
  q4_conversion_rate text,           -- 成交率
  q5_loss_reason text,               -- 未成交原因
  q6_stay_time text,                 -- 是否关注停留时长

  -- ---- 利润维度 (Q7-Q9) ----
  q7_profit_clarity text,            -- 利润核算情况
  q8_cost_awareness text,            -- 成本了解程度
  q9_product_margin text,            -- 产品利润率

  -- ---- 推广维度 (Q10-Q12) ----
  q10_marketing_budget text,         -- 推广投入
  q11_marketing_effect text,         -- 效果判断方式
  q12_marketing_channels text,       -- 推广渠道（多选用逗号分隔）

  -- ---- 复购维度 (Q13-Q15) ----
  q13_return_rate text,              -- 回头客比例
  q14_retention_method text,         -- 老客户维护方式
  q15_churn_reason text,             -- 客户流失原因

  -- ---- 管理维度 (Q16-Q18) ----
  q16_owner_hours text,              -- 老板每天在店时长
  q17_operation_without_owner text,  -- 离店运转情况
  q18_sop_status text,               -- 标准化流程情况

  -- ---- 客户自诊结果 ----
  self_diagnosis text,               -- 自己认为问题最大的维度
  notes text                         -- 备注/补充说明
);

-- 2. 索引：按状态和创建时间查询
create index if not exists idx_submissions_status on submissions(status);
create index if not exists idx_submissions_created_at on submissions(created_at desc);
create index if not exists idx_submissions_phone on submissions(phone);

-- 3. 行级安全策略（RLS）
alter table submissions enable row level security;

-- 允许任何人提交（插入）
create policy "允许客户提交表单"
  on submissions for insert
  with check (true);

-- 只允许通过认证的管理员查看
create policy "仅管理员可查看"
  on submissions for select
  using (auth.role() = 'authenticated');

-- 只允许通过认证的管理员更新状态
create policy "仅管理员可更新"
  on submissions for update
  using (auth.role() = 'authenticated');

-- 4. 顾问管理表（可选扩展）
create table if not exists consultants (
  id uuid default gen_random_uuid() primary key,
  email text unique not null,
  name text not null,
  created_at timestamp with time zone default now()
);
