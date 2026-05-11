/*
   MySQL 多表关系笔记
   概述：项目开发中，数据库表结构会根据业务模块间的关系进行设计，表之间的联系主要分为三种：
   1. 一对多（多对一）
       案例：部门与员工的关系
       关系：一个部门对应多个员工，一个员工对应一个部门
       实现：在多的一方建立外键，指向一的一方的主键
   2. 多对多
       案例：学生与课程的关系
       关系：一个学生可以选修多门课程，一门课程也可以供多个学生选择
       实现：建立第三张中间表，中间表至少包含两个外键，分别关联两方主键
   3. 一对一
 */

-- ------------------------------ 多表关系 演示 ------------------------------
-- 多对多：学生表与课程表示例

-- 创建学生表
create table student(
                        id int auto_increment primary key comment '主键ID',
                        name varchar(10) comment '姓名',
                        no varchar(10) comment '学号'
) comment '学生表';

-- 向学生表插入数据
insert into student values(null, '黛绮丝', '2000100101'),(null, '谢逊', '2000100102'),(null, '殷天正', '2000100103'),(null, '韦一笑', '2000100104');

-- 创建课程表
create table course(
                       id int auto_increment primary key comment '主键ID',
                       name varchar(10) comment '课程名称'
) comment '课程表';

-- 向课程表插入数据
insert into course values(null, 'Java'),(null, 'PHP'),(null, 'MySQL'),(null, 'Hadoop');

-- 创建学生课程中间表（多对多关系）
create table student_course(
                               id int auto_increment comment '主键' primary key,
                               studentid int not null comment '学生ID',
                               courseid int not null comment '课程ID',
                               constraint fk_courseid foreign key (courseid) references course (id),
                               constraint fk_studentid foreign key (studentid) references student (id)
) comment '学生课程中间表';

-- 向中间表插入关联数据
insert into student_course values(null,1,1),(null,1,2),(null,1,3),(null,2,2),(null,2,3),(null,3,4);

-- ------------------------------ 多表关系 演示 ------------------------------
-- 一对一关系：用户基本信息表
create table tb_user(
                        id int auto_increment primary key comment '主键ID',
                        name varchar(10) comment '姓名',
                        age int comment '年龄',
                        gender char(1) comment '1: 男 , 2: 女',
                        phone char(11) comment '手机号'
) comment '用户基本信息表';

-- 一对一关系：用户教育信息表（与用户表关联）
create table tb_user_edu(
                            id int auto_increment primary key comment '主键ID',
                            degree varchar(20) comment '学历',
                            major varchar(50) comment '专业',
                            primaryschool varchar(50) comment '小学',
                            middleschool varchar(50) comment '中学',
                            university varchar(50) comment '大学',
                            userid int unique comment '用户ID',
                            constraint fk_userid foreign key (userid) references tb_user(id)
) comment '用户教育信息表';

-- 向用户基本信息表插入数据
insert into tb_user(id, name, age, gender, phone) values
(null, '黄渤', 45, '1', '18800001111'),
(null, '冰冰', 35, '2', '18800002222'),
(null, '码云', 55, '1', '18800008888'),
(null, '李彦宏', 50, '1', '18800009999');

-- 向用户教育信息表插入数据
insert into tb_user_edu(id, degree, major, primaryschool, middleschool, university, userid) values
(null, '本科', '舞蹈', '静安区第一小学', '静安区第一中学', '北京舞蹈学院', 1),
(null, '硕士', '表演', '朝阳区第一小学', '朝阳区第一中学', '北京电影学院', 2),
(null, '本科', '英语', '杭州市第一小学', '杭州市第一中学', '杭州师范大学', 3),
(null, '本科', '应用数学', '阳泉第一小学', '阳泉区第一中学', '清华大学', 4);


#---------------------------------多表查询--------------------------------------------------------#
#多表查询概述：指从多张表中查询数据

#笛卡尔积:在数学中，两个集合A集合和B集合的所有组合情况。 说明：在多表查询时，需要消除无效的笛卡尔积。

/*
MySQL 多表查询分类笔记
多表查询分类：
    一、连接查询
      1. 内连接：相当于查询A、B交集部分数据
      2. 外连接：
         - 左外连接：查询左表所有数据，以及两张表交集部分数据
         - 右外连接：查询右表所有数据，以及两张表交集部分数据
      3. 自连接：当前表与自身的连接查询，自连接必须使用表别名
    二、子查询
*/

-- ------------------------------ 多表查询 演示 ------------------------------
-- 部门表 dept 的插入语句
INSERT INTO dept (id, name)
VALUES
    (1, '研发部'),
    (2, '市场部'),
    (3, '财务部'),
    (4, '销售部'),
    (5, '总经办'),
    (6, '人事部');
-- 员工表 emp 的插入语句
INSERT INTO emp (id, name, age, job, salary, entrydate, managerid, dept_id) VALUES
(1, '金庸', 66, '总裁', 20000, '2000-01-01', NULL, 5),
(2, '张无忌', 20, '项目经理', 12500, '2005-12-05', 1, 1),
(3, '杨逍', 33, '开发', 8400, '2000-11-03', 2, 1),
(4, '韦一笑', 48, '开发', 11000, '2002-02-05', 2, 1),
(5, '常遇春', 43, '开发', 10500, '2004-09-07', 3, 1),
(6, '小昭', 19, '程序员鼓励师', 6600, '2004-10-12', 2, 1),
(7, '灭绝', 60, '财务总监', 8500, '2002-09-12', 1, 3),
(8, '周芷若', 19, '会计', 48000, '2006-06-02', 7, 3),
(9, '丁敏君', 23, '出纳', 5250, '2009-05-13', 7, 3),
(10, '赵敏', 20, '市场部总监', 12500, '2004-10-12', 1, 2),
(11, '鹿杖客', 56, '职员', 3750, '2006-10-03', 10, 2),
(12, '鹤笔翁', 19, '职员', 3750, '2007-05-09', 10, 2),
(13, '方东白', 19, '职员', 5500, '2009-02-12', 10, 2),
(14, '张三丰', 88, '销售总监', 14000, '2004-10-12', 1, 4),
(15, '俞莲舟', 38, '销售', 4600, '2004-10-12', 14, 4),
(16, '宋远桥', 40, '销售', 4600, '2004-10-12', 14, 4),
(17, '陈友谅', 42, NULL, 2000, '2011-10-12', 1, NULL);
-- 增加外键关系关联
alter table emp add constraint fk_dept_id foreign key (dept_id) references dept(id);

-- 多表查询
select * from emp,dept; #笛卡尔积
select * from emp,dept where emp.dept_id=dept.id; #消除无用笛卡尔积

/*
   连接查询 - 内连接 笔记
   内连接查询语法：
   1. 隐式内连接
      SELECT 字段列表 FROM 表1, 表2 WHERE 条件 ... ;
   2. 显式内连接
      SELECT 字段列表 FROM 表1 [INNER] JOIN 表2 ON 连接条件 ... ;
*/
-- 内连接演示
-- 1. 查询每一个员工的姓名，及关联的部门的名称（隐式内连接实现）
    select e.name 姓名,d.name 部门 from emp e,dept d where e.dept_id=d.id;
-- 2. 查询每一个员工的姓名，及关联的部门的名称（显式内连接实现）
    select e.name 姓名,d.name from emp e join dept d on e.dept_id=d.id;

/*
   连接查询 - 外连接 笔记
   外连接查询语法：
   1. 左外连接
      SELECT 字段列表 FROM 表1 LEFT [OUTER] JOIN 表2 ON 条件 ... ;
      作用：查询表1(左表)的所有数据，包含表1和表2交集部分的数据。
   2. 右外连接
      SELECT 字段列表 FROM 表1 RIGHT [OUTER] JOIN 表2 ON 条件 ... ;
      作用：查询表2(右表)的所有数据，包含表1和表2交集部分的数据。
*/
-- 外连接演示
-- 1. 查询emp表的所有数据，和对应的部门信息（左外连接）
    select e.*,d.name from emp e left join dept d on e.dept_id = d.id;
-- 2. 查询dept表的所有数据，和对应的员工信息（右外连接）
    select * from emp e right join dept d on e.dept_id = d.id;

/*
   连接查询 - 自连接 笔记
   自连接查询语法：
   1. 自连接语法
      SELECT 字段列表 FROM 表A 别名A JOIN 表A 别名B ON 条件 ... ;
   2. 核心说明
      自连接查询，可以是内连接查询，也可以是外连接查询。
      必须给同一张表定义不同别名，用于区分两张逻辑表。
*/

-- 自连接演示
-- 1. 场景一：查询员工及其所属领导的名字
    select e1.name '员工',e2.name '领导' from emp e1,emp e2 where e1.managerid=e2.id;
    select e1.name '员工',e2.name '领导' from emp e1 join emp e2 on e1.managerid=e2.id;
-- 2. 场景二：查询所有员工及其领导的名字
    select e1.name '员工',e2.name '领导' from emp e1 left join emp e2 on e1.managerid=e2.id;

/*
   联合查询 - UNION / UNION ALL 笔记
   定义：
      联合查询（UNION），是把多次查询的结果合并起来，形成一个新的查询结果集。
   语法：
      SELECT 字段列表 FROM 表A ...
      UNION [ALL]
      SELECT 字段列表 FROM 表B ...;
   说明：
      - UNION：合并结果集，并自动去除重复记录
      - UNION ALL：合并结果集，不去除重复记录，性能通常更高
      - 注意：前后两个查询的字段列数、数据类型必须一致
*/
-- 联合查询演示
-- 1. 场景：将薪资低于 5000 的员工，和年龄大于 50 岁的员工全部查询出来
    -- 使用 UNION ALL：合并两个结果集，不去重（包含重复记录）
    select * from emp where salary<5000
    union all
    select * from emp where age>50;
    -- 使用 UNION：合并两个结果集，自动去除重复记录
    select * from emp where salary<5000
    union
    select * from emp where age>50;

/*
   子查询 笔记
   概念：
      SQL语句中嵌套SELECT语句，称为嵌套查询，又称子查询。
   示例语法：
      SELECT * FROM t1 WHERE column1 = (SELECT column1 FROM t2);
   说明：
      子查询外部的语句可以是 INSERT / UPDATE / DELETE / SELECT 中的任意一种。
   分类（按子查询结果）：
      1. 标量子查询：子查询结果为单个值
      2. 列子查询：子查询结果为一列
      3. 行子查询：子查询结果为一行
      4. 表子查询：子查询结果为多行多列
*/

-- 标量子查询示例
-- 1. 场景一：查询"销售部"的所有员工信息
    select * from emp where dept_id=(select id from dept where name='销售部');
-- 2. 场景二：查询在"方东白"入职之后的员工信息
    select * from emp where entrydate>(select emp.entrydate from emp where name ='方东白');
/*
   子查询 - 列子查询 笔记
   概念：
      子查询返回的结果是一列（可以是多行），这种子查询称为列子查询。
   常用操作符：
      IN       - 在指定的集合范围之内，多选一
      NOT IN   - 不在指定的集合范围之内
      ANY      - 子查询返回列表中，有任意一个满足即可
      SOME     - 与 ANY 等同，使用 SOME 的地方都可以使用 ANY
      ALL      - 子查询返回列表的所有值都必须满足
*/
-- 列子查询
-- 1. 查询 "销售部" 和 "市场部" 的所有员工信息
    select * from emp where dept_id in(select id from dept where name in ('市场部','销售部') );
-- 2. 查询比财务部所有人工资都高的员工信息
    select * from emp where salary>all(select salary from emp where dept_id=(select id from dept where name='财务部'));
-- 3. 查询比研发部其中任意一个人工资高的员工信息
    select * from emp where salary>any(select salary from emp where dept_id=(select id from dept where name='研发部'));

/*
   子查询 - 行子查询 笔记
   概念：
      子查询返回的结果是一行（可以是多列），这种子查询称为行子查询。
   常用操作符：
      = 、 <> 、 IN 、 NOT IN
*/
-- 行子查询
-- 1. 查询与 "张无忌" 的薪资及直属领导相同的员工信息 ;
    select * from emp where (salary,managerid)=(select salary,managerid from emp where name = '张无忌');

/*
   子查询 - 表子查询 笔记
   概念：
      子查询返回的结果是多行多列，这种子查询称为表子查询。
   常用操作符：
      IN
*/
-- 表子查询
-- 1. 查询与 "鹿杖客" , "宋远桥" 的职位和薪资相同的员工信息
    select * from emp where (job,salary) in(select job,salary from emp where name in('鹿杖客','宋远桥'));
-- 2. 查询入职日期是 "2006-01-01" 之后的员工信息 , 及其部门信息
    select e.*,dept.name from (select * from emp where entrydate>'2006-01-01') e left join dept on e.dept_id=dept.id;

-- SQL 练习题目：根据需求完成SQL语句的编写
-- -------------------------------> 多表查询案例 <-------------------------------
create table salgrade(
                         grade int,
                         losal int,
                         hisal int
) comment '薪资等级表';

insert into salgrade values (1, 0, 3000);
insert into salgrade values (2, 3001, 5000);
insert into salgrade values (3, 5001, 8000);
insert into salgrade values (4, 8001, 10000);
insert into salgrade values (5, 10001, 15000);
insert into salgrade values (6, 15001, 20000);
insert into salgrade values (7, 20001, 25000);
insert into salgrade values (8, 25001, 30000);
-- 1. 查询员工的姓名、年龄、职位、部门信息。
    select e.name,age,job,d.name from emp e left join dept d on e.dept_id=d.id;
-- 2. 查询年龄小于30岁的员工姓名、年龄、职位、部门信息。
    select e.name,age,job,d.name from emp e left join dept d on e.dept_id=d.id where e.age<30;
-- 3. 查询拥有员工的部门ID、部门名称。
    select id,name from dept where dept.id in(select distinct dept_id emp from emp where dept_id is not null) ;
    select distinct d.id,d.name from emp e,dept d where e.dept_id=d.id;
-- 4. 查询所有年龄大于40岁的员工, 及其归属的部门名称; 如果员工没有分配部门, 也需要展示出来。
    select e.name,d.name from emp e left join dept d on e.dept_id=d.id where age>40;
-- 5. 查询所有员工的工资等级。
    select name,grade from emp,salgrade where salary between losal and hisal;
-- 6. 查询 "研发部" 所有员工的信息及工资等级。
    select e.name,grade from (select emp.*from emp join dept on emp.dept_id = dept.id where dept.name='研发部' ) e,salgrade where salary between losal and hisal;
-- 7. 查询 "研发部" 员工的平均工资。
-- 8. 查询工资比 "灭绝" 高的员工信息。
-- 9. 查询比平均薪资高的员工信息。
-- 10. 查询低于本部门平均工资的员工信息。
-- 11. 查询所有的部门信息, 并统计部门的员工人数。
-- 12. 查询所有学生的选课情况, 展示出学生名称, 学号, 课程名称。




