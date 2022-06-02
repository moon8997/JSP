
---- **** JSPServletBegin/chap05.oracle 에서 작업한 것 *** -----

show user;
-- USER이(가) "SYS"입니다.
create user jspbegin_user identified by cclass default tablespace users;
-- User JSPBEGIN_USER이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to jspbegin_user;
-- Grant을(를) 성공했습니다.

show user;
-- USER이(가) "JSPBEGIN_USER"입니다.

-- drop table tbl_person_interest purge;

create table tbl_person_interest
(seq          number
,name         varchar2(20) not null 
,school       varchar2(20) not null
,color        varchar2(20) not null
,food         varchar2(80) 
,registerday  date default sysdate
,constraint PK_tbl_person_interest primary key(seq)
);
-- Table TBL_PERSON_INTEREST이(가) 생성되었습니다.


create sequence person_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle;
-- Sequence PERSON_SEQ이(가) 생성되었습니다.

select seq, name, school, color, food, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday
from tbl_person_interest
order by seq;
