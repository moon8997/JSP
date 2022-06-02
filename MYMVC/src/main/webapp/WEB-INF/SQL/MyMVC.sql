--------- *******MyMvc 에서 작업한것*****-----

show user;
--USER이(가) "SYS"입니다.

create user mymvc_user identified by cclass default tablespace users;
--User MYMVC_USER이(가) 생성되었습니다.

grant connect, resource, create view, unlimited tablespace to  mymvc_user;
--Grant을(를) 성공했습니다.

show user;
--USER이(가) "MYMVC_USER"입니다.

---------------------------------------------------------------------------------------------------

create table tbl_main_image
(imgno           number not null
,imgfilename     varchar2(100) not null
,constraint PK_tbl_main_image primary key(imgno)
);
--Table TBL_MAIN_IMAGE이(가) 생성되었습니다.

create sequence seq_main_image
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
--Sequence SEQ_MAIN_IMAGE이(가) 생성되었습니다.

insert into tbl_main_image(imgno, imgfilename) values(seq_main_image.nextval, '미샤.png');  
insert into tbl_main_image(imgno, imgfilename) values(seq_main_image.nextval, '원더플레이스.png'); 
insert into tbl_main_image(imgno, imgfilename) values(seq_main_image.nextval, '레노보.png'); 
insert into tbl_main_image(imgno, imgfilename) values(seq_main_image.nextval, '동원.png'); 

commit;

select imgno, imgfilename
from tbl_main_image 
order by imgno asc;

----- **** 회원 테이블 생성 **** ------      --회원가입 페이지 내가할거 참조
-- drop table tbl_member purge;
alter table tbl_member
modify userid varchar2(40);


create table tbl_member
(userid             varchar2(40)   not null  -- 회원아이디
,pwd                varchar2(200)  not null  -- 비밀번호 (SHA-256 암호화 대상)
,name               varchar2(30)   not null  -- 회원명
,email              varchar2(200)  not null  -- 이메일 (AES-256 암호화/복호화 대상)
,mobile             varchar2(200)            -- 연락처 (AES-256 암호화/복호화 대상) 
,postcode           varchar2(5)              -- 우편번호
,address            varchar2(200)            -- 주소
,detailaddress      varchar2(200)            -- 상세주소
,extraaddress       varchar2(200)            -- 참고항목
,gender             varchar2(1)              -- 성별   남자:1  / 여자:2
,birthday           varchar2(10)             -- 생년월일   
,coin               number default 0         -- 코인액
,point              number default 0         -- 포인트 
,registerday        date default sysdate     -- 가입일자 
,lastpwdchangedate  date default sysdate     -- 마지막으로 암호를 변경한 날짜  
,status             number(1) default 1 not null     -- 회원탈퇴유무   1: 사용가능(가입중) / 0:사용불능(탈퇴) 
,idle               number(1) default 0 not null     -- 휴면유무      0 : 활동중  /  1 : 휴면중 
,constraint PK_tbl_member_userid primary key(userid)
,constraint UQ_tbl_member_email  unique(email)
,constraint CK_tbl_member_gender check( gender in('1','2') )
,constraint CK_tbl_member_status check( status in(0,1) )
,constraint CK_tbl_member_idle check( idle in(0,1) )
);
--Table TBL_MEMBER이(가) 생성되었습니다.

select *
from tbl_member
order by registerday desc;

delete from tbl_member
where userid = 'leess';

commit;

----- **** 로그인 기록 테이블 생성 **** ------ 
create table tbl_loginhistory
(fk_userid   varchar2(40) not null 
,logindate   date default sysdate not null
,clientip    varchar2(20) not null
,constraint FK_tbl_loginhistory foreign key(fk_userid) references tbl_member(userid)  
);
--Table TBL_LOGINHISTORY이(가) 생성되었습니다.

select fk_userid, to_char(logindate, 'yyyy-mm-dd hh24:mi:ss') AS logindate, clientip
from tbl_loginhistory;

select *
from tbl_loginhistory;

--*** 로그인을 처리하기 위한 SQL문 작성하기 *** ----
desc tbl_member;

SELECT  userid, name, email, mobile, postcode, address, detailaddress, extraaddress, gender,
        birthyyyy, birthmm, birthdd, coin, point, registerday, pwdchangegap, 
        nvl(lastlogingap, trunc(months_between(sysdate, registerday) ) ) AS lastlogingap
FROM
(
select userid, name, email, mobile, postcode, address, detailaddress, extraaddress, gender
      , substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd
      , coin, point, to_char(registerday, 'yyyy-mm-dd') AS registerday 
      , trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap  
from tbl_member
where status = 1 and userid = 'leess' and pwd = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382'
) M
CROSS JOIN
(
select trunc(months_between(sysdate, max(logindate)) ) AS lastlogingap             --12개월지나면 후면처리할려고 마지막날짜와 현재날짜와 비교해서 
from tbl_loginhistory
where fk_userid = 'leess'
) H;


--마지막으로 로그인한지 12개월이 초과되었을 경우 테스트 할려고하는것임 --
update tbl_member set registerday = add_months(registerday, -13)
                        ,lastpwdchangedate = add_months(lastpwdchangedate, 13)
where userid = 'leess';
--1 행 이(가) 업데이트되었습니다.



update tbl_loginhistory set logindate = add_months(logindate, -13)
where fk_userid = 'leess';
--2개 행 이(가) 업데이트되었습니다.

commit;






--######원상복구하기

update tbl_member set registerday = add_months(registerday, 13)
                       ,lastpwdchangedate = add_months(lastpwdchangedate, 13)
                       , idle = 0    --내껀 안되서 안함
where userid = 'leess';
--1 행 이(가) 업데이트되었습니다.



update tbl_loginhistory set logindate = add_months(logindate, 13)
where fk_userid = 'leess';
--2개 행 이(가) 업데이트되었습니다.

commit;
--커밋 완료.

--비밀번호를 변경한지 3개월이 초과되었을 경우 테스트 하려고 하는 것임 --
update tbl_member set lastpwdchangedate = add_months(lastpwdchangedate, -5)
where userid = 'leess';
--1 행 이(가) 업데이트되었습니다.   --암호바꾼날짜를 5개월전으로 바꿈
commit;
--커밋 완료.



--####원상복구 --
update tbl_member set lastpwdchangedate = add_months(lastpwdchangedate, 5)
where userid = 'leess';
--1 행 이(가) 업데이트되었습니다.   --암호바꾼날짜를 5개월전으로 바꿈
commit;
--커밋 완료.

select *
from tbl_member
order by registerday desc;

------------------------------------------------

-- 오라클에서 프로시저를 사용하여 회원을 대량으로 입력(insert)하겟습니다. --

-- 이메일을 대량으로 넣기 위해서 어쩔수 없이 email 에 대한  unique 제약을 없앤다.
select *
from user_constraints
where table_name = 'TBL_MEMBER';

alter table tbl_member
drop constraint UQ_TBL_MEMBER_EMAIL;

create or replace procedure pcd_member_insert
(p_userid   IN   varchar2
,p_name     IN   varchar2
,p_gender   IN   varchar2)
is
begin
    for i in 1..100 loop
        insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday) 
        values(p_userid||i, '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382', p_name||i, 'spJAH36KpJ5aUfxHDWBlwGztQIGNJqmFxKKQ9AytWHc=', 'fDfbPBmC3i10ye5TvaKrGw==', '15864', '경기 군포시 오금로 15-17', '12호', ' (금정동)', p_gender, '1991-05-01');      
    end loop;
end pcd_member_insert;
-- Procedure PCD_MEMBER_INSERT이(가) 컴파일되었습니다.


exec pcd_member_insert('iyou','아이유','2');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

exec pcd_member_insert('chaew','차은우','1');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday) 
        values('kimys', '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382', '김유신', 'spJAH36KpJ5aUfxHDWBlwGztQIGNJqmFxKKQ9AytWHc=', 'fDfbPBmC3i10ye5TvaKrGw==', '15864', '경기 군포시 오금로 15-17', '12호', ' (금정동)', '1', '1991-05-01');    
-- 1 행 이(가) 삽입되었습니다.

insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday) 
        values('sungsk', '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382', '성시경', 'spJAH36KpJ5aUfxHDWBlwGztQIGNJqmFxKKQ9AytWHc=', 'fDfbPBmC3i10ye5TvaKrGw==', '15864', '경기 군포시 오금로 15-17', '12호', ' (금정동)', '1', '1991-05-01');    
-- 1 행 이(가) 삽입되었습니다.

commit;
-- 커밋 완료.

select *
from tbl_member
order by registerday desc;


--- === 페이지 처리를 위한 SQL 문 작성하기 === ---
select rownum, userid, name, email, gender
from tbl_member
where userid != 'admin'
and rownum between 1 and 10; -- 나온다.

select rownum, userid, name, email, gender
from tbl_member
where userid != 'admin'
and rownum between 11 and 20; -- 안나온다.

----------------------------------------

select rno, userid, name, email, gender
from
(
    select rownum AS rno, userid, name, email, gender
    from 
    (
        select userid, name, email, gender
        from tbl_member
        where userid != 'admin'
        order by registerday desc
    ) V
) T
where rno between 1 and 5;     -- 1 페이지 (한 페이지당 5개를 보여줄때)


select rno, userid, name, email, gender
from
(
    select rownum AS rno, userid, name, email, gender
    from 
    (
        select userid, name, email, gender
        from tbl_member
        where userid != 'admin'
        order by registerday desc
    ) V
) T
where rno between 6 and 10;     -- 2 페이지 (한 페이지당 5개를 보여줄때)


select rno, userid, name, email, gender
from
(
    select rownum AS rno, userid, name, email, gender
    from 
    (
        select userid, name, email, gender
        from tbl_member
        where userid != 'admin'
        order by registerday desc
    ) V
) T
where rno between 11 and 15;     -- 3 페이지 (한 페이지당 5개를 보여줄때)

  /*
      >>> where rno between A and B :
            A 와 B 를 구하는 공식 <<< 
            
       currentShowPageNo 은 보고자 하는 페이지 번호이다. 즉 1페이지, 2페이지, 3피이지 ... 를 말한다. 
       sizePerPage 는 한 페이지당 보여줄 행의 개수를 말한다. 즉, 3개, 5개, 10개를 보여줄때의 개수를 말한다.
       
      A 는 (currentShowPageNo * sizePerPage) - (sizePerPage - 1); 이다.
      B 는 (currentShowPageNo * sizePerPage);  이다.
      
      
      where rno between 1 and 5;     -- 1 페이지 (한 페이지당 5개를 보여줄때)    
      A 는 (1 * 5) - (5 - 1); 5 - 4 => 1
      B 는 (1 * 5) ==> 5
      
      
      where rno between 6 and 10;   -- 2 페이지 (한 페이지당 5개를 보여줄때)
      A 는 (2 * 5) - (5 - 1); 10 - 4 => 6
      B 는 (2 * 5) ==> 10
      
      
      where rno between 11 and 15;     -- 3 페이지 (한 페이지당 5개를 보여줄때)
      A 는 (3 * 5) - (5 - 1); 15 - 4 => 11
      B 는 (3 * 5) ==> 15
  */
  


where rno between 1 and 10;     -- 1 페이지 (한 페이지당 10개를 보여줄때)


select rno, userid, name, email, gender
from
(
    select rownum AS rno, userid, name, email, gender
    from 
    (
        select userid, name, email, gender
        from tbl_member
        where userid != 'admin'
        order by registerday desc
    ) V
) T
where rno between 11 and 20;     -- 2 페이지 (한 페이지당 10개를 보여줄때)


select rno, userid, name, email, gender
from
(
    select rownum AS rno, userid, name, email, gender
    from 
    (
        select userid, name, email, gender
        from tbl_member
        where userid != 'admin'
        order by registerday desc
    ) V
) T
where rno between 21 and 30;     -- 3 페이지 (한 페이지당 10개를 보여줄때)

  /*
      >>> where rno between A and B :
            A 와 B 를 구하는 공식 <<< 
            
       currentShowPageNo 은 보고자 하는 페이지 번호이다. 즉 1페이지, 2페이지, 3피이지 ... 를 말한다. 
       sizePerPage 는 한 페이지당 보여줄 행의 개수를 말한다. 즉, 3개, 5개, 10개를 보여줄때의 개수를 말한다.
       
      A 는 (currentShowPageNo * sizePerPage) - (sizePerPage - 1); 이다.
      B 는 (currentShowPageNo * sizePerPage);  이다.
      
      
      where rno between 1 and 10;     -- 1 페이지 (한 페이지당 10개를 보여줄때)    
      A 는 (1 * 10) - (10 - 1); 10 - 9 => 1
      B 는 (1 * 10) ==> 10
      
      
      where rno between 11 and 20;   -- 2 페이지 (한 페이지당 10개를 보여줄때)
      A 는 (2 * 10) - (10 - 1); 20 - 9 => 11
      B 는 (2 * 10) ==> 20
      
      
      where rno between 21 and 30;     -- 3 페이지 (한 페이지당 10개를 보여줄때)
      A 는 (3 * 10) - (10 - 1); 30 - 9 => 21
      B 는 (3 * 10) ==> 30 
  */
  
select *
from tbl_member
where name like '%'||'유'||'%'
order by registerday desc;


select *
from tbl_member
where userid like '%'||'you'||'%'
order by registerday desc;



----------------------------------------------------

-- 검색이 없는 총회원수 알아오기
select count(*) -- 206
from tbl_member
where userid != 'admin';

-- 검색이 있는 총회원수 알아오기
select *
from tbl_member
where userid != 'admin' and name like '%'||'유'||'%';

-- 검색이 없는 전체페이지 수 알아오기
select ceil(count(*)/10), ceil(count(*)/5), ceil(count(*)/3)
from tbl_member
where userid != 'admin';


-- 검색이 있는 전체페이지 수 알아오기
select ceil(count(*)/10), ceil(count(*)/5), ceil(count(*)/3)
from tbl_member
where userid != 'admin' and name like '%'||'유'||'%';

delete from tbl_member
where userid='iyou44'
-- 1 행 이(가) 삭제되었습니다.

commit;
-- 커밋 완료.


delete from tbl_member
where userid='iyou45'
-- 1 행 이(가) 삭제되었습니다.

commit;
-- 커밋 완료.

delete from tbl_member
where userid='iyou47'
-- 1 행 이(가) 삭제되었습니다.

commit;
-- 커밋 완료.


/*
   카테고리 테이블명 : tbl_category 

   컬럼정의 
     -- 카테고리 대분류 번호  : 시퀀스(seq_category_cnum)로 증가함.(Primary Key)
     -- 카테고리 코드(unique) : ex) 전자제품  '100000'
                                  의류      '200000'
                                  도서      '300000' 
     -- 카테고리명(not null)  : 전자제품, 의류, 도서           
  
*/ 
-- drop table tbl_category purge; 
create table tbl_category
(cnum    number(8)     not null  -- 카테고리 대분류 번호
,code    varchar2(20)  not null  -- 카테고리 코드
,cname   varchar2(100) not null  -- 카테고리명
,constraint PK_tbl_category_cnum primary key(cnum)
,constraint UQ_tbl_category_code unique(code)
);

-- drop sequence seq_category_cnum;
create sequence seq_category_cnum 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '100000', '전자제품');
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '200000', '의류');
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '300000', '도서');
commit;

-- 나중에 넣습니다.
--insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '400000', '식품');
--commit;

-- insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '500000', '신발');
-- commit;

/*
delete from tbl_category
where code = '500000';

commit;
*/

select cnum, code, cname
from tbl_category
order by cnum asc;


-- drop table tbl_spec purge;
create table tbl_spec
(snum    number(8)     not null  -- 스펙번호       
,sname   varchar2(100) not null  -- 스펙명         
,constraint PK_tbl_spec_snum primary key(snum)
,constraint UQ_tbl_spec_sname unique(sname)
);

-- drop sequence seq_spec_snum;
create sequence seq_spec_snum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'HIT');
insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'NEW');
insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'BEST');

commit;

select snum, sname
from tbl_spec
order by snum asc;


---- *** 제품 테이블 : tbl_product *** ----
-- drop table tbl_product purge; 
create table tbl_product
(pnum           number(8) not null       -- 제품번호(Primary Key)
,pname          varchar2(100) not null   -- 제품명
,fk_cnum        number(8)                -- 카테고리코드(Foreign Key)의 시퀀스번호 참조
,pcompany       varchar2(50)             -- 제조회사명
,pimage1        varchar2(100) default 'noimage.png' -- 제품이미지1   이미지파일명
,pimage2        varchar2(100) default 'noimage.png' -- 제품이미지2   이미지파일명 
,prdmanual_systemFileName varchar2(200)            -- 파일서버에 업로드되어지는 실제 제품설명서 파일명 (파일명이 중복되는 것을 피하기 위해서 중복된 파일명이 있으면 파일명뒤에 숫자가 자동적으로 붙어 생성됨)
,prdmanual_orginFileName  varchar2(200)            -- 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올리는 제품설명서 파일명 
,pqty           number(8) default 0      -- 제품 재고량
,price          number(8) default 0      -- 제품 정가
,saleprice      number(8) default 0      -- 제품 판매가(할인해서 팔 것이므로)
,fk_snum        number(8)                -- 'HIT', 'NEW', 'BEST' 에 대한 스펙번호인 시퀀스번호를 참조
,pcontent       varchar2(4000)           -- 제품설명  varchar2는 varchar2(4000) 최대값이므로
                                         --          4000 byte 를 초과하는 경우 clob 를 사용한다.
                                         --          clob 는 최대 4GB 까지 지원한다.
                                         
,point          number(8) default 0      -- 포인트 점수                                         
,pinputdate     date default sysdate     -- 제품입고일자
,constraint  PK_tbl_product_pnum primary key(pnum)
,constraint  FK_tbl_product_fk_cnum foreign key(fk_cnum) references tbl_category(cnum)
,constraint  FK_tbl_product_fk_snum foreign key(fk_snum) references tbl_spec(snum)
);

-- drop sequence seq_tbl_product_pnum;
create sequence seq_tbl_product_pnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 아래는 fk_snum 컬럼의 값이 1 인 'HIT' 상품만 입력한 것임. 
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '스마트TV', 1, '삼성', 'tv_samsung_h450_1.png','tv_samsung_h450_2.png', 100,1200000,800000, 1,'42인치 스마트 TV. 기능 짱!!', 50);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북', 1, '엘지', 'notebook_lg_gt50k_1.png','notebook_lg_gt50k_2.png', 150,900000,750000, 1,'노트북. 기능 짱!!', 30);  

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '바지', 2, 'S사', 'cloth_canmart_1.png','cloth_canmart_2.png', 20,12000,10000, 1,'예뻐요!!', 5);       

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '남방', 2, '버카루', 'cloth_buckaroo_1.png','cloth_buckaroo_2.png', 50,15000,13000, 1,'멋져요!!', 10);       
       
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '보물찾기시리즈', 3, '아이세움', 'book_bomul_1.png','book_bomul_2.png', 100,35000,33000, 1,'만화로 보는 세계여행', 20);       
       
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '만화한국사', 3, '녹색지팡이', 'book_koreahistory_1.png','book_koreahistory_2.png', 80,130000,120000, 1,'만화로 보는 이야기 한국사 전집', 60);
       
commit;

-- 아래는 fk_cnum 컬럼의 값이 1 인 '전자제품' 중 fk_snum 컬럼의 값이 1 인 'HIT' 상품만 입력한 것임. 
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북1', 1, 'DELL', '1.jpg','2.jpg', 100,1200000,1000000,1,'1번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북2', 1, '에이서','3.jpg','4.jpg',100,1200000,1000000,1,'2번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북3', 1, 'LG전자','5.jpg','6.jpg',100,1200000,1000000,1,'3번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북4', 1, '레노버','7.jpg','8.jpg',100,1200000,1000000,1,'4번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북5', 1, '삼성전자','9.jpg','10.jpg',100,1200000,1000000,1,'5번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북6', 1, 'HP','11.jpg','12.jpg',100,1200000,1000000,1,'6번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북7', 1, '레노버','13.jpg','14.jpg',100,1200000,1000000,1,'7번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북8', 1, 'LG전자','15.jpg','16.jpg',100,1200000,1000000,1,'8번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북9', 1, '한성컴퓨터','17.jpg','18.jpg',100,1200000,1000000,1,'9번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북10', 1, 'MSI','19.jpg','20.jpg',100,1200000,1000000,1,'10번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북11', 1, 'LG전자','21.jpg','22.jpg',100,1200000,1000000,1,'11번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북12', 1, 'HP','23.jpg','24.jpg',100,1200000,1000000,1,'12번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북13', 1, '레노버','25.jpg','26.jpg',100,1200000,1000000,1,'13번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북14', 1, '레노버','27.jpg','28.jpg',100,1200000,1000000,1,'14번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북15', 1, '한성컴퓨터','29.jpg','30.jpg',100,1200000,1000000,1,'15번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북16', 1, '한성컴퓨터','31.jpg','32.jpg',100,1200000,1000000,1,'16번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북17', 1, '레노버','33.jpg','34.jpg',100,1200000,1000000,1,'17번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북18', 1, '레노버','35.jpg','36.jpg',100,1200000,1000000,1,'18번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북19', 1, 'LG전자','37.jpg','38.jpg',100,1200000,1000000,1,'19번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북20', 1, 'LG전자','39.jpg','40.jpg',100,1200000,1000000,1,'20번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북21', 1, '한성컴퓨터','41.jpg','42.jpg',100,1200000,1000000,1,'21번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북22', 1, '에이서','43.jpg','44.jpg',100,1200000,1000000,1,'22번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북23', 1, 'DELL','45.jpg','46.jpg',100,1200000,1000000,1,'23번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북24', 1, '한성컴퓨터','47.jpg','48.jpg',100,1200000,1000000,1,'24번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북25', 1, '삼성전자','49.jpg','50.jpg',100,1200000,1000000,1,'25번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북26', 1, 'MSI','51.jpg','52.jpg',100,1200000,1000000,1,'26번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북27', 1, '애플','53.jpg','54.jpg',100,1200000,1000000,1,'27번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북28', 1, '아수스','55.jpg','56.jpg',100,1200000,1000000,1,'28번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북29', 1, '레노버','57.jpg','58.jpg',100,1200000,1000000,1,'29번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북30', 1, '삼성전자','59.jpg','60.jpg',100,1200000,1000000,1,'30번 노트북', 60);

commit;


-- 아래는 fk_cnum 컬럼의 값이 1 인 '전자제품' 중 fk_snum 컬럼의 값이 2 인 'NEW' 상품만 입력한 것임. 
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북31', 1, 'MSI','61.jpg','62.jpg',100,1200000,1000000,2,'31번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북32', 1, '삼성전자','63.jpg','64.jpg',100,1200000,1000000,2,'32번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북33', 1, '한성컴퓨터','65.jpg','66.jpg',100,1200000,1000000,2,'33번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북34', 1, 'HP','67.jpg','68.jpg',100,1200000,1000000,2,'34번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북35', 1, 'LG전자','69.jpg','70.jpg',100,1200000,1000000,2,'35번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북36', 1, '한성컴퓨터','71.jpg','72.jpg',100,1200000,1000000,2,'36번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북37', 1, '삼성전자','73.jpg','74.jpg',100,1200000,1000000,2,'37번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북38', 1, '레노버','75.jpg','76.jpg',100,1200000,1000000,2,'38번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북39', 1, 'MSI','77.jpg','78.jpg',100,1200000,1000000,2,'39번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북40', 1, '레노버','79.jpg','80.jpg',100,1200000,1000000,2,'40번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북41', 1, '레노버','81.jpg','82.jpg',100,1200000,1000000,2,'41번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북42', 1, '레노버','83.jpg','84.jpg',100,1200000,1000000,2,'42번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북43', 1, 'MSI','85.jpg','86.jpg',100,1200000,1000000,2,'43번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북44', 1, '한성컴퓨터','87.jpg','88.jpg',100,1200000,1000000,2,'44번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북45', 1, '애플','89.jpg','90.jpg',100,1200000,1000000,2,'45번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북46', 1, '아수스','91.jpg','92.jpg',100,1200000,1000000,2,'46번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북47', 1, '삼성전자','93.jpg','94.jpg',100,1200000,1000000,2,'47번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북48', 1, 'LG전자','95.jpg','96.jpg',100,1200000,1000000,2,'48번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북49', 1, '한성컴퓨터','97.jpg','98.jpg',100,1200000,1000000,2,'49번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북50', 1, '레노버','99.jpg','100.jpg',100,1200000,1000000,2,'50번 노트북', 60);

commit;        

select *
from tbl_product
order by pnum desc;


select count(*)
from tbl_product
where fk_snum = '1';

pnum, pname, code, pcompany, pimagel, pimage2, pqty, price, saleprice, sname, pcontent, point, pinputdate,


select pnum, pname, code, pcompany, pimagel, pimage2, pqty, price, saleprice, sname, pcontent, point, pinputdate
from
(
select row_number() over(order by P.pnum desc) AS RNO 
      , P.pnum, P.pname, C.code, P.pcompany, P.pimage1, P.pimage2, P.pqty, P.price, P.saleprice, S.sname, P.pcontent, P.point 
     , to_char(P.pinputdate, 'yyyy-mm-dd') AS pinputdate
from tbl_product P
JOIN tbl_category C
ON P.fk_cnum = C.cnum
JOIN tbl_spec s
ON P.fk_snum = S.snum
where S.sname = 'HIT'
) V
where V.RNO between 1 and 8 -- 1페이지


----- >>> 하나의 제품속에 여러개의 이미지 파일 넣어주기 <<< ------ 
select *
from tbl_product
order by pnum;  

create table tbl_product_imagefile
(imgfileno     number         not null   -- 시퀀스로 입력받음.
,fk_pnum       number(8)      not null   -- 제품번호(foreign key)
,imgfilename   varchar2(100)  not null   -- 제품이미지파일명
,constraint PK_tbl_product_imagefile primary key(imgfileno)
,constraint FK_tbl_product_imagefile foreign key(fk_pnum) references tbl_product(pnum) on delete cascade 
);


create sequence seqImgfileno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

select imgfileno, fk_pnum, imgfilename
from tbl_product_imagefile
order by imgfileno desc;

seq_tbl_product_pnum.nextval

-- *** 시퀀스 seq_tbl_product_pnum 이 다음번에 사용될 번호를 알아오고자 한다. *** --
select * 
from tbl_product;

select last_number
from user_sequences
where sequence_name = 'SEQ_TBL_PRODUCT_PNUM';

-- *** 시퀀스 seq_tbl_product_pnum 에서 채번 한다. *** --
select seq_tbl_product_pnum.nextval
from dual;

-- *** 시퀀스 seq_tbl_product_pnum 이 현재 사용중인 번호를 알아오고자 한다. *** --
select seq_tbl_product_pnum.currval
from dual;

select *
from tbl_product
order by pnum desc;

select *
from tbl_product
where pnum = 62;

select *
from tbl_product_imagefile
where fk_pnum = 62;

select *
from tbl_product P JOIN tbl_product_imagefile I
ON P.pnum = I.fk_pnum
WHERE P.pnum = 62;

select S.sname, pnum, pname, pcompany, price, saleprice, point, pqty, pcontent, pimage1, pimage2, prdmanual_systemFileName, nvl(prdmanual_orginFileName, '없음') AS prdmanual_orginFileName
from
(
select fk_snum, pnum, pname, pcompany, price, saleprice, point, pqty, pcontent, pimage1, pimage2, prdmanual_systemFileName, prdmanual_orginFileName
from tbl_product
where pnum = 62
) P JOIN tbl_spec S
ON P.fk_snum = S.snum;


select prdmanual_systemFileName, prdmanual_orginFileName 
from tbl_product
where pnum = 62;


-------- **** 장바구니 테이블 생성하기 **** ----------
 desc tbl_member;
 desc tbl_product;

 create table tbl_cart
 (cartno        number               not null   --  장바구니 번호             
 ,fk_userid     varchar2(20)         not null   --  사용자ID            
 ,fk_pnum       number(8)            not null   --  제품번호                
 ,oqty          number(8) default 0  not null   --  주문량                   
 ,registerday   date default sysdate            --  장바구니 입력날짜
 ,constraint PK_shopping_cart_cartno primary key(cartno)
 ,constraint FK_shopping_cart_fk_userid foreign key(fk_userid) references tbl_member(userid) 
 ,constraint FK_shopping_cart_fk_pnum foreign key(fk_pnum) references tbl_product(pnum)
 );

 create sequence seq_tbl_cart_cartno
 start with 1
 increment by 1
 nomaxvalue
 nominvalue
 nocycle
 nocache;

 comment on table tbl_cart
 is '장바구니 테이블';

 comment on column tbl_cart.cartno
 is '장바구니번호(시퀀스명 : seq_tbl_cart_cartno)';

 comment on column tbl_cart.fk_userid
 is '회원ID  tbl_member 테이블의 userid 컬럼을 참조한다.';

 comment on column tbl_cart.fk_pnum
 is '제품번호 tbl_product 테이블의 pnum 컬럼을 참조한다.';

 comment on column tbl_cart.oqty
 is '장바구니에 담을 제품의 주문량';

 comment on column tbl_cart.registerday
 is '장바구니에 담은 날짜. 기본값 sysdate';
 
 select *
 from user_tab_comments;

 select column_name, comments
 from user_col_comments
 where table_name = 'TBL_CART';
 
 select cartno, fk_userid, fk_pnum, oqty, registerday 
 from tbl_cart
 order by cartno asc;
 
select A.cartno, A.fk_userid, A.fk_pnum, 
        B.pname, B.pimage1, B.price, B.saleprice, B.point, A.oqty
from tbl_cart A join tbl_product B 
on A.fk_pnum = B.pnum 
where A.fk_userid = 'tjdansrlf'
order by A.cartno desc;


select NVL( sum(B.saleprice * A.oqty), 0) AS SUMTOTALPRICE
    ,  NVL( sum(B.point *  A.oqty), 0) AS SUMTOTALPOINT
from tbl_cart A join tbl_product B 
on A.fk_pnum = B.pnum 
where A.fk_userid = 'tjdansrlf';

select NVL( sum(B.saleprice * A.oqty), 0) AS SUMTOTALPRICE
    ,  NVL( sum(B.point *  A.oqty), 0) AS SUMTOTALPOINT
from tbl_cart A join tbl_product B 
on A.fk_pnum = B.pnum 
where A.fk_userid = 'leess';

------------------ >>> 주문관련 테이블 <<< -----------------------------
-- [1] 주문 테이블    : tbl_order
-- [2] 주문상세 테이블 : tbl_orderdetail


-- *** "주문" 테이블 *** --
create table tbl_order
(odrcode        varchar2(20) not null          -- 주문코드(명세서번호)  주문코드 형식 : s+날짜+sequence ==> s20210503-1 , s20210503-2 , s20210503-3
                                               --                                                      s20210504-4 , s20210504-5 , s20210504-6
,fk_userid      varchar2(20) not null          -- 사용자ID
,odrtotalPrice  number       not null          -- 주문총액
,odrtotalPoint  number       not null          -- 주문총포인트
,odrdate        date default sysdate not null  -- 주문일자
,constraint PK_tbl_order_odrcode primary key(odrcode)
,constraint FK_tbl_order_fk_userid foreign key(fk_userid) references tbl_member(userid)
);


-- "주문코드(명세서번호) 시퀀스" 생성
create sequence seq_tbl_order
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

select 's'||to_char(sysdate,'yyyymmdd')||'-'||seq_tbl_order.nextval AS odrcode
from dual;
-- s20210424-1

select odrcode, fk_userid, 
       odrtotalPrice, odrtotalPoint,
       to_char(odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate
from tbl_order
order by odrcode desc;


-- *** "주문상세" 테이블 *** --
create table tbl_orderdetail
(odrseqnum      number               not null   -- 주문상세 일련번호
,fk_odrcode     varchar2(20)         not null   -- 주문코드(명세서번호)
,fk_pnum        number(8)            not null   -- 제품번호
,oqty           number               not null   -- 주문량
,odrprice       number               not null   -- "주문할 그때 그당시의 실제 판매가격" ==> insert 시 tbl_product 테이블에서 해당제품의 saleprice 컬럼값을 읽어다가 넣어주어야 한다.
,deliverStatus  number(1) default 1  not null   -- 배송상태( 1 : 주문만 받음,  2 : 배송중,  3 : 배송완료)
,deliverDate    date                            -- 배송완료일자  default 는 null 로 함.
,constraint PK_tbl_orderdetail_odrseqnum  primary key(odrseqnum)
,constraint FK_tbl_orderdetail_fk_odrcode foreign key(fk_odrcode) references tbl_order(odrcode) on delete cascade
,constraint FK_tbl_orderdetail_fk_pnum foreign key(fk_pnum) references tbl_product(pnum)
,constraint CK_tbl_orderdetail check( deliverStatus in(1, 2, 3) )
);


-- "주문상세 일련번호 시퀀스" 생성
create sequence seq_tbl_orderdetail
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


select *
from tbl_order
order by odrcode desc;

select *
from tbl_orderdetail
order by odrseqnum desc;

select A.cartno, A.fk_userid, A.fk_pnum, 
        B.pname, B.pimage1, B.price, B.saleprice, B.point, A.oqty
from tbl_cart A join tbl_product B 
on A.fk_pnum = B.pnum 
where A.fk_userid = 'tjdansrlf'
order by A.cartno desc;

select coin, point
from tbl_member
where userid = 'tjdansrlf';

update tbl_member set coin = 9000000, point = 80000
where userid = 'tjdansrlf';

commit;

select count(*)
from tbl_order A join tbl_orderdetail B
on A.odrcode = B.fk_odrcode;
 
select count(*)
from tbl_order A join tbl_orderdetail B
on A.odrcode = B.fk_odrcode
where a.fk_userid = 'tjdansrlf';

---------------------------------------------------
select odrcode, fk_userid, odrdate, odrseqnum, fk_pnum, oqty, odrprice, deliverstatus, 
       pname, pimage1, price, saleprice, point
from
(
select row_number() over (order by B.fk_odrcode desc, B.odrseqnum desc) AS RNO 
      , A.odrcode, A.fk_userid 
      , to_char(A.odrdate, 'yyyy-mm-dd hh24:mi:ss') AS odrdate 
      , B.odrseqnum, B.fk_pnum, B.oqty, B.odrprice 
      , case B.deliverstatus 
      when 1 then '주문완료' 
      when 2 then '배송중' 
      when 3 then '배송완료' 
      end AS deliverstatus 
    , C.pname, C.pimage1, C.price, C.saleprice, C.point 
from tbl_order A join tbl_orderdetail B 
on A.odrcode = B.fk_odrcode 
join tbl_product C 
on B.fk_pnum = C.pnum
) V
where RNO between 1 and 3;

select odrcode, fk_userid, odrdate, odrseqnum, fk_pnum, oqty, odrprice, deliverstatus, 
       pname, pimage1, price, saleprice, point
from 
(
select row_number() over (order by B.fk_odrcode desc, B.odrseqnum desc) AS RNO 
      , A.odrcode, A.fk_userid 
      , to_char(A.odrdate, 'yyyy-mm-dd hh24:mi:ss') AS odrdate 
      , B.odrseqnum, B.fk_pnum, B.oqty, B.odrprice 
      , case B.deliverstatus 
      when 1 then '주문완료' 
      when 2 then '배송중' 
      when 3 then '배송완료' 
      end AS deliverstatus 
    , C.pname, C.pimage1, C.price, C.saleprice, C.point 
from tbl_order A join tbl_orderdetail B 
on A.odrcode = B.fk_odrcode 
join tbl_product C 
on B.fk_pnum = C.pnum
where A.fk_userid = 'tjdansrlf'
) V
where RNO between 1 and 3;


----- *** 좋아요, 싫어요 (투표) 테이블 생성하기 *** ----- 
create table tbl_product_like
(fk_userid   varchar2(40) not null 
,fk_pnum     number(8) not null
,constraint  PK_tbl_product_like primary key(fk_userid,fk_pnum)
,constraint  FK_tbl_product_like_userid foreign key(fk_userid) references tbl_member(userid)
,constraint  FK_tbl_product_like_pnum foreign key(fk_pnum) references tbl_product(pnum) on delete cascade
);

create table tbl_product_dislike
(fk_userid   varchar2(40) not null 
,fk_pnum     number(8) not null
,constraint  PK_tbl_product_dislike primary key(fk_userid,fk_pnum)
,constraint  FK_tbl_product_dislike_userid foreign key(fk_userid) references tbl_member(userid)
,constraint  FK_tbl_product_dislike_pnum foreign key(fk_pnum) references tbl_product(pnum) on delete cascade
);
-----------------------------------------------------

select O.odrcode
from tbl_order O join tbl_orderdetail D
on O.odrcode = D.fk_odrcode
where O.fk_userid = 'tjdansrlf' and D.fk_pnum = 66;


select O.odrcode
from tbl_order O join tbl_orderdetail D
on O.odrcode = D.fk_odrcode
where O.fk_userid = 'tjdansrlf' and D.fk_pnum = 20;


--- tjdansrlf 이라는 사용자가 제품번호 58 제품을 좋아한다에 투표를 한다.
--- 먼저 tjdansrlf 이라는 사용자가 제품번호 58 제품을 싫어한다에 투표를 했을 수도 있다.
--- 그러므로 먼저 tbl_product_dislike 테이블에서 tjdansrlf 이라는 사용자가 제품번호 58 제품이 insert 되어진 것을 delete 해야 한다.
delete from tbl_product_dislike
where fk_userid = 'tjdansrlf' and fk_pnum = 66;

insert into tbl_product_like(fk_userid, fk_pnum)
values('tjdansrlf', 66);

select *
from tbl_product_like
where fk_pnum = 66

--- tjdansrlf 이라는 사용자가 제품번호 58 제품을 싫어한다에 투표를 한다.
--- 먼저 tjdansrlf 이라는 사용자가 제품번호 58 제품을 좋아한다에 투표를 했을 수도 있다.
--- 그러므로 먼저 tbl_product_like 테이블에서 tjdansrlf 이라는 사용자가 제품번호 58 제품이 insert 되어진 것을 delete 해야 한다.

delete from tbl_product_like
where fk_userid = 'tjdansrlf' and fk_pnum = 66;

insert into tbl_product_dislike(fk_userid, fk_pnum)
values('tjdansrlf', 66);

select *
from tbl_product_dislike
where fk_pnum = 66;


rollback;


-------- **** 상품구매 후기 테이블 생성하기 **** ----------
create table tbl_purchase_reviews
(review_seq          number 
,fk_userid           varchar2(20)   not null   -- 사용자ID       
,fk_pnum             number(8)      not null   -- 제품번호(foreign key)
,contents            varchar2(4000) not null
,writeDate           date default sysdate
,constraint PK_purchase_reviews primary key(review_seq)
-- 로그인하여 실제 해당 제품을 구매했을 때만 딱 1번만 작성할 수 있는 것. 제품후기를 삭제했을 경우에는 다시 작성할 수 있는 것임.
,constraint UQ_tbl_purchase_reviews unique(fk_userid, fk_pnum)
,constraint FK_purchase_reviews_userid foreign key(fk_userid) references tbl_member(userid) on delete cascade 
,constraint FK_purchase_reviews_pnum foreign key(fk_pnum) references tbl_product(pnum) on delete cascade
);


create sequence seq_purchase_reviews
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

select *
from tbl_purchase_reviews
order by review_seq desc;


select review_seq, name, fk_pnum, contents, to_char(writeDate, 'yyyy-mm-dd hh24:mi:ss') AS writeDate
from tbl_purchase_reviews R join tbl_member M
on R.fk_userid = M.userid 
where R.fk_pnum = 3
order by review_seq desc;

select fk_userid
from tbl_order
where odrcode = 's20220412-8'

--------------------------

select *
from tbl_orderdetail;

select *
from tbl_orderdetail;
where FK_ODRCODE 's20220412-3'

select *
from tbl_orderdetail;
where FK_ODRCODE || '/' || FK_PNUM in('s20220412-3/5','s20220412-3/3','s20220412-3/62');

update tbl_orderdetail set deliverystatus = 2
where fk_odrcode || '/' || fk_pnum in('s20220412-35','s20220412-33','s20220412-362' )


-------- **** 매장찾기(카카오지도) 테이블 생성하기 **** ----------
create table tbl_map 
(storeID       varchar2(20) not null   --  매장id
,storeName     varchar2(100) not null  --  매장명
,storeUrl      varchar2(200)            -- 매장 홈페이지(URL)주소
,storeImg      varchar2(200) not null   -- 매장소개 이미지파일명  
,storeAddress  varchar2(200) not null   -- 매장주소 및 매장전화번호
,lat           number not null          -- 위도
,lng           number not null          -- 경도 
,zindex        number not null          -- zindex 
,constraint PK_tbl_map primary key(storeID)
,constraint UQ_tbl_map_zindex unique(zindex)
);

create sequence seq_tbl_map_zindex
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store1','롯데백화점 본점','https://place.map.kakao.com/7858517','lotte02.png','서울 중구 을지로 30 (T)02-771-2500',37.56511284953554,126.98187860455485,1);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store2','신세계백화점 본점','https://place.map.kakao.com/7969138','shinsegae.png','서울 중구 소공로 63 (T)1588-1234',37.56091181255155,126.98098265772731,2);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store3','미래에셋센터원빌딩','https://place.map.kakao.com/13057692','miraeeset.png','서울 중구 을지로5길 26 (T)02-6030-0100',37.567386065415086,126.98512381778167,3);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store4','현대백화점신촌점','https://place.map.kakao.com/21695719','hyundai01.png','서울 서대문구 신촌로 83 현대백화점신촌점 (T)02-3145-2233',37.556005,126.935699,4);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store5','쌍용강북교육센터','https://place.map.kakao.com/16530319','sist01.jpg','서울 마포구 월드컵북로 21 풍성빌딩 2~4층 (T)02-336-8546',37.556583,126.919557,5);

commit; 

select storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex
from tbl_map
order by zindex asc;