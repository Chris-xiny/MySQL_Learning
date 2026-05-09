

#-----------------------------DDL语句演示(数据定义语言，用于定义或修改数据库结构)-------------------------------------------
-- 1.数据库操作------------------------------
-- 2.create database 数据库名;  #创建数据库
-- 3.show databases;    #显示所有数据库
-- 4.use 数据库名;  #切换指定数据库
-- 5.select database(); #查询当前数据库
-- 6.drop database 数据库名;    #删除指定数据库

#表操作---------------------------------
create table emp(
                    id int,
                    workno varchar(10),
                    name varchar(10),
                    gender char(1),
                    age tinyint unsigned,
                    idcard char(18),
                    entrydate date
)comment '员工表';

show tables;    #显示所有表
desc emp;   #显示表结构
desc employee;

drop table if exists tb_user;  #删除该表
drop table employee;
truncate table employee;   #删除该表并重新创建该表

alter table emp add nickname varchar(20);   #添加新字段
alter table emp change nickname username varchar(30);   #更改指定字段名与数据类型(可选)
alter table emp drop username;  #删除字段
alter table emp rename to employee; #重命名表
#-----------------------------------------------------------------------------


#-----------------------------DML(数据操作语言，用于操作表中的数据)语句演示-------------------------------------------
    /*  增删改操作
        添加数据(INSERT)
        修改数据(UPDATE)
        删除数据(DELETE)
    */
#给指定字段添加数据
INSERT INTO employee (id, workno, name, gender, age, idcard, entrydate)
VALUES (1,'1','张三','男',18,'123456789012345678','2026-05-01');
#给所有字段添加数据(注意字段顺序)
INSERT INTO employee VALUES (2,'2','李四','男',19,'123456789012345679','2026-05-02');
#批量添加数据
INSERT INTO employee VALUES
    (3,'3','王五','男',19,'123456789012345680','2026-05-03'),
    (4,'4','赵六','男',19,'123456789012345681','2026-05-04'),
    (5,'5','哈哈','女',19,'123456789012345682','2026-05-05');
-- 1.查询指定表的所有数据
SELECT * FROM employee;
-- 2.修改数据
UPDATE employee SET name='嘻嘻',gender='男' WHERE id=005;
-- 3.不加WHERE就是对所有数据操作
UPDATE employee SET entrydate='2026-05-08';
-- 4.删除数据
DELETE FROM employee WHERE id=2;
DELETE FROM employee;


#-----------------------------DQL(数据查询语言，数据查询)语句演示-------------------------------------------
    #注意      !!!!!!!!以下顺序!!!!!!!!
# 编写顺序：SELECT FROM WHERE GROUP BY HAVING ORDER BY LIMIT
# 执行顺序：FROM WHERE GROUP BY HAVING SELECT ORDER BY LIMIT
create table emp(
                    id              int                 comment '编号',
                    workno          varchar(10)         comment '工号',
                    name            varchar(10)         comment '姓名',
                    gender          char(1)             comment '性别',
                    age             tinyint unsigned    comment '年龄',
                    idcard          char(18)            comment '身份证号',
                    workaddress     varchar(50)         comment '工作地址',
                    entrydate       date                comment '入职时间'
) comment '员工表';

drop table emp;

insert into emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
values
    (1, '1', '柳岩', '女', 20, '123456789012345678', '北京', '2000-01-01'),
    (2, '2', '张无忌', '男', 18, '123456789012345670', '北京', '2005-09-01'),
    (3, '3', '韦一笑', '男', 38, '123456789712345670', '上海', '2005-08-01'),
    (4, '4', '赵敏', '女', 18, '123456757123845670', '北京', '2009-12-01'),
    (5, '5', '小昭', '女', 16, '123456769012345678', '上海', '2007-07-01'),
    (6, '6', '杨逍', '男', 28, '12345678931234567X', '北京', '2006-01-01'),
    (7, '7', '范瑶', '男', 40, '123456789212345670', '北京', '2005-05-01'),
    (8, '8', '黛绮丝', '女', 38, '123456157123645670', '天津', '2015-05-01'),
    (9, '9', '范凉凉', '女', 45, '123156789012345678', '北京', '2010-04-01'),
    (10, '10', '陈友谅', '男', 53, '123456789012345670', '上海', '2011-01-01'),
    (11, '11', '张士诚', '男', 55, '123567897123465670', '江苏', '2015-05-01'),
    (12, '12', '常遇春', '男', 32, '123446757152345670', '北京', '2004-02-01'),
    (13, '13', '张三丰', '男', 88, '123656789012345678', '江苏', '2020-11-01'),
    (14, '14', '灭绝', '女', 65, '123456719012345670', '西安', '2019-05-01'),
    (15, '15', '胡青牛', '男', 70, '12345674971234567X', '西安', '2018-04-01'),
    (16, '16', '周芷若', '女', 18, null, '北京', '2012-06-01');

#--基本查询--#
    #1.查询多个字段 select 字段1,字段2... from 表名;  或查询全部字段 select * from 表名;
    select name,workno,age from emp;
    select * from emp;
    #2.设置别名 select 字段1[AS 别名1],字段2[AS 别名2]... from 表名;
    select name as '姓名' ,workno as '工号',age as '年龄' from emp;
    #3.如果想把查询结果去重复可以加上DISTINCT 如:select DISTINCT 字段列表 from 表名;
    select distinct  workaddress from emp;

#--条件查询(WHERE)--#
-- 1. 查询年龄等于 88 的员工
    select * from emp where age=88;
-- 2. 查询年龄小于 20 的员工信息
    select * from emp where age<20;
-- 3. 查询年龄小于等于 20 的员工信息
    select * from emp where age<=20;
-- 4. 查询没有身份证号的员工信息
    select * from emp where idcard is null;
-- 5. 查询有身份证号的员工信息
    select * from emp where idcard is not null;
-- 6. 查询年龄不等于 88 的员工信息
    select *from emp where age!=88;
-- 7. 查询年龄在15岁(包含) 到 20岁(包含)之间的员工信息
    select *from emp where age between 15 and 20;
-- 8. 查询性别为 女 且年龄小于 25岁的员工信息
    select *from emp where gender='女' and age<25;
-- 9. 查询年龄等于18 或 20 或 40 的员工信息
    select *from emp where age in(18,20,40);
-- 10. 查询姓名为两个字的员工信息
    select *from emp where name like '__';
-- 11. 查询身份证号最后一位是X的员工信息
    select * from emp where idcard like '%X';

#--聚合函数(count、max、min、avg、sum)--#
-- 聚合函数:将一列数据作为一个整体，进行纵向计算(null值不参与聚合计算)
-- 语法: select 聚合函数(字段列表) from 表名;

-- 1. 统计该企业员工数量
    select count(*) from emp;
-- 2. 统计该企业员工的平均年龄
    select avg(age) from emp;
-- 3. 统计该企业员工的最大年龄
    select max(age) from emp;
-- 4. 统计该企业员工的最小年龄
    select min(age) from emp;
-- 5. 统计西安地区员工的年龄之和
    select sum(age) from emp where workaddress = '西安';

#--分组查询(GROUP BY)--#
-- 语法: select 字段列表 from 表名 [where 条件] GROUP BY 分组字段名 [HAVING 分组后过滤条件]
#       where与having有何不同:
#     1.执行时机不同，where是分组前过滤，不满足条件的不参与分组；having是分组之后对结果进行过滤
#     2.判断条件不同:where不能对聚合函数进行判断,而having可以
#   注意:
#     执行顺序:where>聚合函数>having
#     分组之后,查询的字段一般为聚合函数和分组字段，查询其他字段无意义
-- 1. 根据性别分组 , 统计男性员工 和 女性员工的数量
    select gender,count(*) as gender from emp group by emp.gender;
-- 2. 根据性别分组 , 统计男性员工 和 女性员工的平均年龄
    select gender,avg(age) as gender from emp group by emp.gender;
-- 3. 查询年龄小于45的员工 , 并根据工作地址分组 , 获取员工数量大于等于3的工作地址
    select emp.workaddress,count(*) from emp where age<45 group by workaddress having count(*)>=3;

#--排序查询(ORDER BY)--#
-- 语法: select 字段列表 from 表名 ORDER BY 字段1 排序方式1,字段2 排序方式2...; #如果是多字段排序,当第一个字段相同时才根据第二个字段排序
-- 排序方式:  ASC:升序    DESC:降序        不写默认升序

-- 1. 根据年龄对公司的员工进行升序排序
    select * from emp order by age ;
-- 2. 根据入职时间，对员工进行降序排序
    select * from emp order by entrydate desc;
-- 3. 根据年龄对公司的员工进行升序排序 ， 年龄相同 ， 再按照入职时间进行降序排序
    select * from emp order by age ,entrydate desc;

#--分页查询(LIMIT)--#
-- 语法: select 字段列表 from 表名 LIMIT 起始索引,查询记录数;
# 注意
# - 起始索引从0开始，起始索引 = （查询页码 - 1）* 每页显示记录数。
# - 分页查询是数据库的方言，不同的数据库有不同的实现，MySQL中是LIMIT。
# - 如果查询的是第一页数据，起始索引可以省略，直接简写为 limit 10。

-- 1. 查询第1页员工数据，每页展示10条记录
    select * from emp limit 10;
-- 2. 查询第2页员工数据，每页展示10条记录
    select * from emp limit 10,10;

#-Practices:
# -查询年龄为 20,21,22,23 岁的女性员工信息。
    select * from emp where age in(20,21,22,23) and gender='女';
# -查询性别为 男 ，并且年龄在 20-40 岁 (含) 以内的姓名为三个字的员工。
    select * from emp where gender='男' and (age between 20 and 40) and name like '___';
# -统计员工表中，年龄小于 60 岁的，男性员工和女性员工的人数。
    select gender,count(*) from emp where age<60 group by gender;
# -查询所有年龄小于等于 35 岁员工的姓名和年龄，并对查询结果按年龄升序排序，如果年龄相同按入职时间降序排序。
    select name,age from emp where age<=35 order by age,entrydate desc;
# -查询性别为男，且年龄在 20-40 岁 (含) 以内的前 5 个员工信息，对查询的结果按年龄升序排序，年龄相同按入职时间升序排序。
    select * from emp where gender='男' and (age between 20 and 40) order by age,entrydate limit 5;

#最后演示DQL的执行顺序,案例:查询年龄大于15的员工的姓名、年龄,并根据年龄进行升序排序
    select e.name ,e.age eage from emp e where e.age>15 order by eage;#tips:注意别名以及字段名的产生顺序不同所带来的作用域不同

#-----------------------------------------------------------------------------


#-----------------------------DCL(数据控制语言，管理数据库用户、控制数据库的访问)语句演示-------------------------------------------
-- 创建用户 itcast，只能够在当前主机localhost访问，密码123456;
    create user 'itcast'@'localhost' identified by '123456';
-- 创建用户 heima，可以在任意主机访问该数据库，密码123456 ;
    create user 'heima'@'%' identified by '123456';
-- 修改用户 heima 的访问密码为 1234 ;
    alter user 'heima'@'%' identified with mysql_native_password by '1234';
-- 删除itcast@localhost用户
    drop user 'itcast'@'localhost';
-- 查询权限 show grants for '用户名'@'主机名'
    show grants for 'heima'@'%';
-- 授予权限 grant 权限列表 on 数据库.表名 to '用户名'@'主机名'
    grant all on itcast.* to 'heima'@'%';
-- 撤销权限
    revoke all on itcast.* from 'heima'@'%';
#-----------------------------------------------------------------------------












