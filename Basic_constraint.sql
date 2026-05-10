/*
   MySQL 约束 笔记
   约束：作用于表中字段上的规则，用于限制存储在表中的数据
   目的：保证数据库中数据的正确、有效性和完整性
*/

-- 非空约束：限制该字段的数据不能为null 关键字：NOT NULL
-- 唯一约束：保证该字段的所有数据都是唯一、不重复的 关键字：UNIQUE
-- 主键约束：主键是一行数据的唯一标识，要求非空且唯一 关键字：PRIMARY KEY
-- 默认约束：保存数据时，如果未指定该字段的值，则采用默认值 关键字：DEFAULT
-- 检查约束(8.0.16版本之后)：保证字段值满足某一个条件 关键字：CHECK
-- 外键约束：用来让两张表的数据之间建立连接，保证数据的一致性和完整性 关键字：FOREIGN KEY


-- id：ID唯一标识，类型int，主键且自动增长          -- 关键字：PRIMARY KEY, AUTO_INCREMENT
-- name：姓名，类型varchar(10)，不为空且唯一         -- 关键字：NOT NULL, UNIQUE
-- age：年龄，类型int，大于0且小于等于120         -- 关键字：CHECK
-- status：状态，类型char(1)，无指定值时默认1         -- 关键字：DEFAULT
-- gender：性别，类型char(1)，无约束

create table user(
    id int primary key auto_increment,
    name varchar(10) not null unique ,
    age int check(age>0 and age <=120),
    status char(1) default '1',
    gender char(1)
) comment '用户表';

-- 插入数据
-- 插入数据（约束测试示例）
insert into user(name,age,status,gender) values ('Tom1',19,'1','男'),('Tom2',25,'0','男');
insert into user(name,age,status,gender) values ('Tom3',19,'1','男');
-- 违反非空约束（name 为 null）
insert into user(name,age,status,gender) values (null,19,'1','男');
-- 违反唯一约束（name 重复）
insert into user(name,age,status,gender) values ('Tom3',19,'1','男');
insert into user(name,age,status,gender) values ('Tom4',80,'1','男');
-- 违反检查约束（age < 0）
insert into user(name,age,status,gender) values ('Tom5',-1,'1','男');
-- 违反检查约束（age > 120）
insert into user(name,age,status,gender) values ('Tom5',121,'1','男');
-- 正确数据（age=120，status 用默认值）
insert into user(name,age,gender) values ('Tom5',120,'男');

-- ------------------------------ 约束（外键）------------------------------
/*
MySQL 外键约束笔记
概念：外键用来让两张表的数据之间建立连接，从而保证数据的一致性和完整性。
*/
-- MySQL 外键语法笔记

-- 1. 创建表时添加外键
/*
CREATE TABLE 表名(
    字段名 数据类型,
    ...
    [CONSTRAINT] [外键名称] FOREIGN KEY(外键字段名) REFERENCES 主表(主表列名)
    );

-- 2. 已有表添加外键
ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY(外键字段名) REFERENCES 主表(主表列名);
  */


-- 准备数据：创建部门表
drop table emp;
create table dept(
                     id   int auto_increment comment 'ID' primary key,
                     name varchar(50) not null comment '部门名称'
) comment '部门表';

-- 向部门表插入数据
INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'), (3, '财务部'), (4, '销售部'), (5, '总经办');

-- 创建员工表（与部门表关联）
create table emp(
                    id         int auto_increment comment 'ID' primary key,
                    name       varchar(50) not null comment '姓名',
                    age        int comment '年龄',
                    job        varchar(20) comment '职位',
                    salary     int comment '薪资',
                    entrydate  date comment '入职时间',
                    managerid  int comment '直属领导ID',
                    dept_id    int comment '部门ID'
) comment '员工表';

-- 向员工表插入完整数据
INSERT INTO emp (id, name, age, job, salary, entrydate, managerid, dept_id) VALUES
        (1, '金庸', 66, '总裁', 20000, '2000-01-01', null, 5),
        (2, '张无忌', 20, '项目经理', 12500, '2005-12-05', 1, 1),
        (3, '杨逍', 33, '开发', 8400, '2000-11-03', 2, 1),
        (4, '韦一笑', 48, '开发', 11000, '2002-02-05', 2, 1),
        (5, '常遇春', 43, '开发', 10500, '2004-09-07', 3, 1),
        (6, '小昭', 19, '程序员鼓励师', 6600, '2004-10-12', 2, 1);

-- 添加外键
alter table emp add constraint fk_dept_id foreign key (dept_id) references dept(id);
-- 删除外键
alter table emp drop foreign key fk_dept_id;

/*
   MySQL 外键删除/更新行为笔记
*/
-- NO ACTION-- 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除/更新。(与 RESTRICT 一致)
-- RESTRICT-- 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除/更新。(与 NO ACTION 一致)
-- CASCADE-- 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有，则也删除/更新外键在子表中的记录。
-- SET NULL-- 当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则设置子表中该外键值为null（这就要求该外键允许取null）。
-- SET DEFAULT-- 父表有变更时，子表将外键列设置成一个默认的值 (Innodb不支持)

-- MySQL 外键删除/更新行为添加语法笔记
#ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY (外键字段) REFERENCES 主表名(主表字段名) ON UPDATE CASCADE ON DELETE CASCADE;
alter table emp add constraint fk_dept_id foreign key (dept_id) references dept(id) on update cascade on delete cascade ;
alter table emp add constraint fk_dept_id foreign key (dept_id) references dept(id) on update set null on delete set null ;

