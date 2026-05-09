-- MySQL 字符串函数笔记
-- CONCAT(S1,S2,...Sn)    字符串拼接，将S1, S2, ... Sn拼接成一个字符串
    select concat('HELLO',' ','WORLD','!');
-- LOWER(str)             将字符串str全部转为小写
    select  lower('HELLO');
-- UPPER(str)             将字符串str全部转为大写
    select  upper('hello');
-- LPAD(str,n,pad)        左填充，用字符串pad对str的左边进行填充，达到n个字符串长度
    select lpad('01',5,'-');
-- RPAD(str,n,pad)        右填充，用字符串pad对str的右边进行填充，达到n个字符串长度
    select rpad('01',5,'-');
-- TRIM(str)              去掉字符串头部和尾部的空格
    select trim('   12  3    ');
-- SUBSTRING(str,start,len) 返回从字符串str从start位置起的len个长度的字符串
    select  substring('123456',1,3);

-- Practice:由于业务需求变更，企业员工的工号，统一为5位数，目前不足5位数的全部在前面补0。比如：员工的工号应该为00001。
 update emp set workno=lpad(workno,5,'0');

#----------------------------------------------------------------
-- MySQL 数值函数笔记
-- CEIL(x)       向上取整
    select ceil(1.1);
-- FLOOR(x)      向下取整
    select floor(1.7);
-- MOD(x,y)      返回x/y的模
    select mod(6,4);
-- RAND()        返回0~1内的随机数
    select rand();
-- ROUND(x,y)    求参数x的四舍五入的值，保留y位小数
    select  round(2.255,2);

-- Practice:通过数据库函数，生成一个六位验证码
    select lpad(round(rand()*1000000,0),6,'0');

#----------------------------------------------------------------
-- MySQL 日期函数笔记
-- CURDATE()                 返回当前日期
    select curdate();
-- CURTIME()                 返回当前时间
    select  curtime();
-- NOW()                     返回当前日期和时间
    select now();
-- YEAR(date)                获取指定date的年份
    select YEAR(now());
-- MONTH(date)               获取指定date的月份
    select MONTH(now());
-- DAY(date)                 获取指定date的日期
    select DAY(now());
-- DATE_ADD(date, INTERVAL expr type)  返回一个日期/时间值加上一个时间间隔expr后的时间值
    select date_add(now(),INTERVAL 20 DAY);
    select date_add(now(),INTERVAL 20 MONTH);
    select date_add(now(),INTERVAL 20 YEAR);
-- DATEDIFF(date1,date2)     返回起始时间date1 和 结束时间date2之间的天数
    select datediff('2005-10-13','2025-5-9');

-- Practice:查询所有员工的入职天数，并根据日期倒序排序
    select name,datediff(curdate(),entrydate) as entrydays from emp order by entrydays desc;