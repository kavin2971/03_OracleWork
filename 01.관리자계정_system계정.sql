--===========================================================================
--                                메모
--===========================================================================

/*
*sys

SuperUser
Oracle관리자
DB생성할 권리가 있다

접속하려면 
사용자명 입력: sys as sysdba
비밀번호 입력: 1234 엔터

*system

Oracle관리자
DB생성할 권리가 없다

접속하려면 
conn
사용자명 입력: system
비밀번호 입력: 1234 엔터

끝내려면, exit


CMD 접속시
sqlplus 엔터

사용자명 입력: sys as sysdba
비밀번호 입력: 1234 엔터

사용자명 입력: system
비밀번호 입력: 1234 엔터

conn system/1234 가능

*사용자생성 및 접속

-사용자 이름 test, 비번 1234로 생성
create user 사용자명 identified by 비밀번호;
create user test identified by 1234; 엔터

"ORA-65096: 공통 사용자 또는 롤 이름이 부적합합니다." 오류 발생

-11버젼 이상부터는 사용자명에 c##을 붙여야함
사용자 이름 test, 비번 1234로 생성
create user c##사용자명 identified by 비밀번호;
create user c##test identified by 1234; 엔터

"사용자가 생성되었습니다"

*권한부여를 반드시 해야 접속가능
grant connect, resource to c##test;

"권한이 부여되었습니다"

*접속
conn c##test/1234 또는
connect c##test/1234 또는

conn 엔터
사용자명 입력: system 엔터
비밀번호 입력: 1234 엔터

"연결되었습니다"
*/

--===========================================================================
--===========================================================================


-- 한줄 주석 : 단축키 ctrl + /
/*
 여러줄 주석 : 단축키 alt + shift + c
*/ 
-- test2 사용자 생성
create user c##test2 identified by 1234;
-- 실행 : 위에 ▷ 버튼 또는 ctrl + 엔터  

-- (c##) 이를 회피하는 방법
alter session set "_oracle_script" = true;

-- 앞으로 테이블을 생성하고 사용하려면 아래 3가지를 해야함
-- 사용자 계정 생성은 SYSTEM, SYS에서만 가능

-- 1. kh 사용자 생성
create user kh identified by 1234;

-- 2. 권한부여
grant connect, resource to kh;

-- 3. 테이블스페이스 할당
--alter user kh quota 30M on users; --명시
alter user kh default tablespace users quota unlimited on users; -- 제한을 두지않고

-- 사용자 삭제
drop user c##test2;

-- 테이블이 존재할 경우 사용자 삭제
drop user c##test2 cascade;


-- 사용자 : DDL
-- 비밀번호 : 1234

create user DDL identified by 1234;  -- DDL/1234 생성
GRANT CONNECT, RESOURCE TO DDL; -- 권한부여
ALTER USER DDL DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS; --테이블스페이스

-- 사용자 : workbook /1234

alter session set "_oracle_script" = true;
create user workbook identified by 1234;  -- DDL/1234 생성
GRANT CONNECT, RESOURCE TO workbook; -- 권한부여
ALTER USER workbook DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

create user JSP identified by 1234;
GRANT CONNECT, RESOURCE TO JSP;
ALTER USER JSP DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
