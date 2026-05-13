
/*
-- 索引概述
    概述:索引（index）是帮助MySQL高效获取数据的数据结构（有序）。
    优缺点：
        优势：
        1. 提高数据检索的效率，降低数据库的IO成本
        2. 通过索引列对数据进行排序，降低数据排序的成本，降低CPU的消耗
        劣势：
        1. 索引列会占用额外的存储空间
        2. 索引提高了查询效率，但会降低更新表的速度（如INSERT、UPDATE、DELETE操作效率会降低）
-- 索引结构
    MySQL的索引是在存储引擎层实现的，不同的存储引擎有不同的结构，主要包含以下几种：
        索引结构      | 描述
        ------------- | --------------------------------------------------
        B+Tree索引    | 最常见的索引类型，大部分引擎都支持 B+ 树索引
        Hash索引      | 底层数据结构是用哈希表实现的，只有精确匹配索引列的查询才有效，不支持范围查询
        R-tree(空间索引) | 空间索引是MyISAM引擎的一个特殊索引类型，主要用于地理空间数据类型，通常使用较少
        Full-text(全文索引) | 是一种通过建立倒排索引，快速匹配文档的方式，类似于Lucene,Solr,ES

    索引结构支持情况：
        索引          | InnoDB           | MyISAM | Memory
        ------------- | ---------------- | ------ | -------
        B+tree索引    | 支持              | 支持    | 支持
        Hash索引      | 不支持            | 不支持  | 支持    注:InnoDB具有自适应hash功能，在指定条件下存储引擎根据B+tree自动构建hash索引
        R-tree索引    | 不支持            | 支持    | 不支持
        Full-text     | 5.6版本之后支持   | 支持    | 不支持

//tips:B+tree与hash表结构可看黑马程序员MySQL入门到精通进阶索引篇https://www.bilibili.com/video/BV1Kr4y1i7ru
    B+Tree：
            MySQL索引数据结构对经典的B+Tree进行了优化。
            在原B+Tree的基础上，增加一个指向相邻叶子节点的链表指针，
            就形成了带有顺序指针的B+Tree，提高区间访问的性能。
    Hash索引：
        1. 实现原理：采用hash算法，将键值换算成新的hash值，映射到对应的槽位上，然后存储在hash表中。
        2. Hash冲突：如果两个(或多个)键值映射到同一个槽位上，就会产生hash冲突（也称为hash碰撞），可以通过链表来解决。
        3.特点：
            1. Hash索引只能用于对等比较（=，in），不支持范围查询（between, >, <, ...）
            2. 无法利用索引完成排序操作
            3. 查询效率高，通常只需要一次检索就可以了，效率通常要高于B+tree索引

-- 为什么InnoDB存储引擎选择使用B+tree索引结构？
        1. 相对于二叉树，层级更少，搜索效率高；
        2. 对于B-tree，无论是叶子节点还是非叶子节点，都会保存数据，这样导致一页中存储的键值减少，指针跟着减少，要同样保存大量数据，只能增加树的高度，导致性能降低；
        3. 相对Hash索引，B+tree支持范围匹配及排序操作；

-- 索引分类
    分类       | 含义                                                     | 特点                 | 关键字
    ---------- | -------------------------------------------------------- | -------------------- | ----------
    主键索引   | 针对于表中主键创建的索引                                 | 默认自动创建, 只能有一个 | PRIMARY
    唯一索引   | 避免同一个表中某数据列中的值重复                           | 可以有多个           | UNIQUE
    常规索引   | 快速定位特定数据                                         | 可以有多个           |
    全文索引   | 全文索引查找的是文本中的关键词，而不是比较索引中的值       | 可以有多个           | FULLTEXT

-- InnoDB存储引擎索引存储形式分类
    1.在InnoDB存储引擎中，根据索引的存储形式，分为以下两种：
    分类              | 含义                                                         | 特点
    ----------------- | ------------------------------------------------------------ | ------------
    聚集索引(Clustered Index) | 将数据存储与索引放到了一块，索引结构的叶子节点保存了行数据    | 必须有，而且只有一个
    二级索引(Secondary Index) | 将数据与索引分开存储，索引结构的叶子节点关联的是对应的主键    | 可以存在多个

    2.聚集索引选取规则:
    1. 如果存在主键，主键索引就是聚集索引。
    2. 如果不存在主键，将使用第一个唯一（UNIQUE）索引作为聚集索引。
    3. 如果表没有主键，或没有合适的唯一索引，则InnoDB会自动生成一个rowid作为隐藏的聚集索引。
*/
-- ==============================================================
-- 索引语法
-- ==============================================================
/*
1. 创建索引
CREATE [UNIQUE|FULLTEXT] INDEX index_name ON table_name (index_col_name,...);

2. 查看索引
SHOW INDEX FROM table_name;

3. 删除索引
DROP INDEX index_name ON table_name;
*/

-- ---------------索引演示
create table tb_user(
    id int primary key AUTO_INCREMENT,
    name varchar(20),
    phone bigint not null,
    profession varchar(20),
    age int,
    status varchar(10),
    email varchar(50)
);

show index from tb_user;

create index idx_user_name on tb_user(name);
create unique index idx_user_phone on tb_user(phone);
create index idx_user_pro_age_sta on tb_user(profession,age,status);
create index idx_user_email on tb_user(email);

drop index idx_user_email on tb_user;





















