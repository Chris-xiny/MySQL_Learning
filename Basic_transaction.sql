/*
    事务简介
    事务是一组操作的集合,它是一个不可分割的工作单位,事务会把所有的操作作为一个整体-
                 一起向系统提交或撤销操作请求,即这些操作要么同时成功,要么同时失败。

    默认MySQL的事务是自动提交的，也就是说，当执行一条DML语句，MySQL会立即隐式的提交事务.
*/

/*
    事务四大特性
    原子性（Atomicity）：事务是不可分割的最小操作单元，要么全部成功，要么全部失败。
    一致性（Consistency）：事务完成时，必须使所有的数据都保持一致状态。
    隔离性（Isolation）：数据库系统提供的隔离机制，保证事务在不受外部并发操作影响的独立环境下运行。
    持久性（Durability）：事务一旦提交或回滚，它对数据库中的数据的改变就是永久的。
*/

/*
    不可重复读 vs 脏读 vs 幻读
    |-------------------------------------------------------------------
    |异常类型	     |描述	                    |事务B做了什么            |
    |-------------------------------------------------------------------
    |脏读	         |读到另一个未提交事务的数据	    |修改后未提交             |
    |不可重复读	     |两次读同一行数据结果不同	    |修改并提交               |
    |幻读	         |两次查询符合条件的行数不同	    |插入或删除了满足条件的行   |
    |-------------------------------------------------------------------
    重点：不可重复读强调“同一行的值变了”，而幻读强调“行数多了或少了”。
*/

/*
    -- 事务隔离级别（针对不可重复读）
    -- 隔离级别            脏读        不可重复读    幻读              典型使用
    -- Read Uncommitted  可能发生    可能发生      可能发生           几乎不用
    -- Read Committed    不会发生    可能发生      可能发生           Oracle、SQL Server 默认
    -- Repeatable Read   不会发生    不会发生      可能发生(除InnoDB)  MySQL InnoDB 默认
    -- Serializable      不会发生    不会发生      不会发生           所有事务串行执行
*/
-- 查看事务隔离级别
SELECT @@TRANSACTION_ISOLATION;

-- 设置事务隔离级别
-- SET [SESSION|GLOBAL] TRANSACTION ISOLATION LEVEL {READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE};
-- session:当前会话生效     global:全部客户端生效

-- 事务隔离级别越高，数据越安全，但效率越低，反之亦然

-- ----------------- ---------------
-- 事务操作
-- 查看/设置事务提交方式
SELECT @@autocommit;
SET @@autocommit = 0;
-- 提交事务
COMMIT;
-- 回滚事务
ROLLBACK;
-- --------------------------------


-- --------------------------------
-- 开启事务
START TRANSACTION; -- 或 BEGIN;

-- 提交事务
COMMIT;

-- 回滚事务
ROLLBACK;
-- ----------------- ---------------


-- ------------------------------ 事务操作演示 -------------------------------
-- 数据准备
create table account(
                        id int auto_increment primary key comment '主键ID',
                        name varchar(10) comment '姓名',
                        money int comment '余额'
) comment '账户表';

insert into account(id, name, money) values (null,'张三',2000),(null,'李四',2000);

-- 恢复数据
update account set money = 2000 where name = '张三' or name = '李四';


-- --------------方法一手动提交
select @@autocommit;
set @@autocommit = 0; -- 设置为手动提交

-- 转账操作（张三给李四转账1000）
-- 1. 查询张三账户余额
select * from account where name = '张三';

-- 2. 将张三账户余额-1000
update account set money = money - 1000 where name = '张三';
程序执行报错...
-- 3. 将李四账户余额+1000
update account set money = money + 1000 where name = '李四';

commit;
rollback;

-- --------------方法二自动提交
set @@autocommit = 1;

-- 转账操作（张三给李四转账1000）
start transaction;
-- 1. 查询张三账户余额
select * from account where name = '张三';

-- 2. 将张三账户余额-1000
update account set money = money - 1000 where name = '张三';
程序错误...
-- 3. 将李四账户余额+1000
update account set money = money + 1000 where name = '李四';
-- 4.提交事务
commit;

rollback;





