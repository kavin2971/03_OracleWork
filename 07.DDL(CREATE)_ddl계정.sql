/*
    * DDL(DATE DEFINITION LANGUAGE) : 데이터 정의 언어
    오라클에서 제공하는 객체(OBJECT)를 만들고(CREATE), 구조를 변경(ALTER)하고, 구조자체를 삭제(DROP)하는 언어
    즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
    주로 DB관리자, 설계자가 사용함
    
    오라클에서 객체(OBJECT)
    : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 패키지(PACKAGE),
      프로시저(PROCEDURE), 함수(FUNCTION), 트리거(TRIGGER), 동의어(SYNONYM), 사용자(USER)   
*/
--=============================================================================
--      <CREATE>
--      객체를 생성하는 구문
--=============================================================================
/*
    1. 테이블 생성
        - 테이블이란 :  행(ROW)과 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
                    모든 데이터들은 테이블을 통해 저장됨
                    (DBMS용어 중 하나로, 데이터를 일종의 표 형태로 표현한것)
        [표현식]
        CREATE TABLE 테이블명 (
            컬럼명 자료형(크기),
            컬럼명 자료형(크기),
            컬럼명 자료형
            ...
        )
        
        * 자료형
        - 문자 :  CHAR(BYTE크기) | VARCHAR2(BYTE크기) => 반드시 크기 지정해줘야 함
        > CHAR  : 최대 2000BYTE 까지 지정 가능
                  고정길이 (지정한 크기보다 더 적은 값이 들어와도 공백으로라도 채워서 처음 지정한 크기만큼 고정)
                  고정된 데이터를 넣을 때 사용
        > VARCHAR2 : 최대 4000BYTE 까지 지정 가능
                     가변 길이 (담긴 값에 따라 공간의 크기가 맞춰짐)
                     몇글자가 들어올지 모를 경우 사용
        - 숫자 : NUMBER([BYTE크기]) => 크기 지정을 거의 하지 않음
                                      크기지정을 할 경우 22BYTE의 가변길이 38자리 까지 표현 가능
        - 날짜 : DATE                   
*/

-- 회원에 대한 테이블 생성 (테이블명 : MEMBER)
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE    
);

SELECT * FROM MEMBER;
-- 사용자가 가지고 있는 테이블 정보
-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블등
-- [참고] USER_TABLES : 이 사용자가 가지고 있는 테이블의 전반적인 구조를 확인할 수 있는 시스템 테이블

SELECT * FROM USER_TABLES;

--[참고] USER_TAB_COLUMNS :  이 사용자가 가지고 있는 테이블들의 모든 컬럼의 전반적인 구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TAB_COLUMNS;

--------------------------------------------------------------------------
/*
    2. 컬럼에 주석 달기(컬럼에 대한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 주석을 수정하려면 주석내용을 변경후 다시 실행하면 덮어쓰기가 됨
*/

COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남,여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

-- 테이블에 데이터를 추가 시키는 구문
-- INSERT INTO 테이블명 VALUES();
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '남', '02-1234-5678', 'hong@naver.com', '23/4/13');
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '남길순', '여', 'null', 'NULL', SYSDATE);
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

----------------------------------------------------------------------------
/*
    <제약조건 CONSTRAINTS>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정을 하는 제약
    - 데이터 무결성 보장을 목정르로함.
    
    * 종류 : NOT NULL, UNIQUE, CHECK(조건), PRIMARY KEY, FOREIGN KEY
*/
/*
    * NOT NULL 제약조건
    해당 컬럼에 반드시 값이 존재해야만 한다 (즉, 컬럼에 절대 NULL이 들어와서는 안됨)
    삽입/수정시 NULL값을 허용하지 않도록 제한
    
    제약조건을 부여하는 방식 크기 2가지로 나눌수 있다(컬럼 레벨 방식/테이블 레벨 방식)
    * NOT NULL 은 오로지 컬럼 레벨 방식만 됨
*/
-- 컬럼 레벨 방식 : 컬럼명 자료형 제약조건
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
  );
  
INSERT INTO MEM_NOTNULL VALUES(1,'user01','pass01','홍길동','남',null,null);
  
INSERT INTO MEM_NOTNULL VALUES(2,'user02',null,'남길동','남',null,'abc@google.com');
  -- NOT NULL 제약조건 위배되는 오류 발생
  
INSERT INTO MEM_NOTNULL VALUES(1,'user01','pass03','이길순','여',null,'def@google.com');
-- 번호 , ID는 중복되면 안되는데 추가되었음
----------------------------------------------------------------------------
/*
    * UNIQUE 제약조건
    해당 컬럼에 중복된 값이 들어가서는 안되는 경우
    컬럼값에 중복값을 제한하는 제약조건
    삽입/수정시 기존에 있는 데이터 중복값이 있을 경우 오류 발생
*/

-- 컬럼 레벨 방식
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 컬럼 레벨 방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);

-- 테이블 레벨 방식
CREATE TABLE MEM_UNIQUE2(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_NO), 
    UNIQUE(MEM_ID) -- 테이블 레벨 방식
);

INSERT INTO MEM_UNIQUE2 VALUES(1, 'user01', 'pass01', '홍길동', '남', '02-1234-5678', 'hong@naver.com');
INSERT INTO MEM_UNIQUE2 VALUES(2, 'user01', 'pass02', '박길순', '남', '010-1234-5678', 'park@naver.com');
-- 오류 구문은 제약조건명으로 알려줌
-- 특별히 제약조건명을 지정해주지 않으면 자동으로 숫자로 부여가 됨

/*
    * 제약조건 부여시 제약조건명까지 넣어주는 방법
    
    >> 컬럼 레벨 방식
        CREATE TABLE 테이블명(
            컬럼명 자료형(크기)[CONDTRAINT 제약조건명] 제약조건,
            컬럼명 자료형(크기),
            ...
        );
        
    >> 테이블 레벨 방식
        CREATE TABLE 테이블명(
            컬럼명 자료형(크기),
            컬럼명 자료형(크기),
            [CONSTRAINT 제약조건명] 제약조건(컬럼명)
        );
*/

CREATE TABLE MEM_UNIQUE3(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID)
);

INSERT INTO MEM_UNIQUE3 VALUES(1, 'USER01', 'PASS01', '아무개', NULL, NULL, NULL);
INSERT INTO MEM_UNIQUE3 VALUES(2, 'USER01', 'PASS02', '김개똥', NULL, NULL, NULL); -- UNIQUE 오류발생 : "무결성 제약 조건(DDL.MEMID_UQ)에 위배됩니다"
INSERT INTO MEM_UNIQUE3 VALUES(2, 'USER02', 'PASS02', '김개똥', '남', NULL, NULL); 
INSERT INTO MEM_UNIQUE3 VALUES(3, 'USER03', 'PASS03', '이말똥', 'ㄴ',NULL, NULL);
INSERT INTO MEM_UNIQUE3 VALUES(4, 'USER04', 'PASS04', '최말똥', '^&*',NULL, NULL);
--> 성별이 유효한 값이 아니어도 입력됨

-------------------------------------------------------------------------------
/*
    * CHECK(조건식) 제약조건
    해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해 줄 수 있다
    해당 조건에 만족하는 데이터 값만 입력하도록 할 수 있다
*/
 -- >> 컬럼방식
CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);

-- >> 테이블 레벨 방식

CREATE TABLE MEM_CHECK2 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID),
    CHECK(GENDER IN ('남', '여'))
);

INSERT INTO MEM_CHECK VALUES(1, 'USER01', 'PASS01', '이순신', '여', NULL, NULL);
INSERT INTO MEM_CHECK VALUES(2, 'USER02', 'PASS02', '박순신', NULL, NULL, NULL); -- 오류 : 발생 체크 제약조건(DDL.SYS_C008361)이 위배되었습니다
INSERT INTO MEM_CHECK VALUES(2, 'USER03', 'PASS03', '최순신', '남', NULL, NULL); 
-- > 회원번호를 식별자의 역할

------------------------------------------------------------------------------
/*
    * PRIMARY KEY(기본키) 제약조건
    테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건 (식별자의 역할)
    ex) 회원번호, 학번, 사원번호, 부서코드, 직급코드, 주문번호, 예약번호, 운송장번호, ...
    
    PRIMARY KEY 제약조건을 부여하면 그 컬럼에 자동으로 NOT NULL + UNIQUE 제약조건을 의미
        >> 대체적으로 검색, 삭제, 수정 등에 기본키의 컬럼값을 이용함
        
        - 유의사항 :  한 테이블 당 오로지 한개만 설정 가능
*/

-- >> 컬럼 레벨 방식

CREATE TABLE MEM_PRIKEY (
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);


-- >> 테이블 레벨 방식

CREATE TABLE MEM_PRIKEY2 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID),
    CHECK(GENDER IN ('남', '여')),
    PRIMARY KEY(MEM_NO)
);


CREATE TABLE MEM_PRIKEY3 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_NN2 UNIQUE(MEM_ID),
    CONSTRAINT GENDER_CH CHECK(GENDER IN ('남', '여')),
    CONSTRAINT MEMNO_PK2 PRIMARY KEY(MEM_NO)
);

INSERT INTO MEM_PRIKEY VALUES(1, 'USER01', 'PASS01', '이순신', '여', NULL, NULL);
INSERT INTO MEM_PRIKEY VALUES(1, 'USER02', 'PASS02', '강순이', '여', NULL, NULL); -- UNIQUE 위배 오류발생 : "무결성 제약 조건(DDL.MEMNO_PK)에 위배됩니다"
INSERT INTO MEM_PRIKEY VALUES(NULL, 'USER02', 'PASS02', '강순이', '여', NULL, NULL); --NOT NULL 위배 오류발생 : "NULL을 ("DDL"."MEM_PRIKEY"."MEM_NO") 안에 삽입할 수 없습니다"

CREATE TABLE MEM_PRIKEY4 (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    PRIMARY KEY(MEM_NO, MEM_ID) -- 2개의 컬럼을 묶어서 PRIMARY KEY 제약조건 부여 (복합키)
);
-- 2개의 컬럼값을 묶어서 고유해야 됨
-- 1,'1111'
-- 1,'2222'
-- 2,'1111'
-- 2,'1111' - 동일한개 존재하므로 위배됨

INSERT INTO MEM_PRIKEY4 VALUES(1, 'USER01', 'PASS01', '홍길동', '남', NULL, NULL);
INSERT INTO MEM_PRIKEY4 VALUES(1, 'USER02', 'PASS02', '김길순', '여', NULL, NULL);
--                               ↖ ↑
--                               2개 고유 해야 하므로 행 삽입가능
INSERT INTO MEM_PRIKEY4 VALUES(2, 'USER02', 'PASS03', '김동순', '여', NULL, NULL);
INSERT INTO MEM_PRIKEY4 VALUES(2, 'USER02', 'PASS04', '최동순', '여', NULL, NULL);    -- UNIQUE 위배 오류발생 : "무결성 제약 조건(DDL.SYS_C008397)에 위배됩니다"

INSERT INTO MEM_PRIKEY4 VALUES(NULL, 'USER02', 'PASS04', '최동순', '여', NULL, NULL); -- NOT NULL 위배 오류발생 : "NULL을 ("DDL"."MEM_PRIKEY4"."MEM_NO") 안에 삽입할 수 없습니다"
INSERT INTO MEM_PRIKEY4 VALUES(3, NULL, 'PASS04', '최동순', '여', NULL, NULL);        -- NOT NULL 위배 오류발생 : "NULL을 ("DDL"."MEM_PRIKEY4"."MEM_NO") 안에 삽입할 수 없습니다"

-- > PRIMARY KEY로 묶여있는 각 컬럼에는 절대 NULL을 허용하지 않는다

/*

복합키 사용 ex) (어떤회원이 어떤상품을 찜했는지 데이터를 보관하는 테이블)
ex) 상품을 찜했을경우 (복합키)

USERID, 상품ID
1,        A     
1,        B       
1,        C       
1,        B       부적합
2,        A       
2,        C       
2,        A       부적합-- 같은 상품이 있으므로 "이미 찜이 되었습니다"

*/

------------------------------------------------------------------------------
-- 회원 등급에 대한 데이터를 따로 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

-- 회원 정보 테이블
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER  -- 회원등급번호를 보관할 컬럼
);

INSERT INTO MEM VALUES (1, 'user01', 'pass01', '홍길동', '남', null, null, null);
INSERT INTO MEM VALUES (2, 'user02', 'pass02', '김길순', '여', null, null, 10);
INSERT INTO MEM VALUES (3, 'user03', 'pass03', '이길동', '여', null, null, 50);
-- 유효한 회원등급번호가 아님에도 불구하고 입력됨

------------------------------------------------------------------------------
/*
    FOREIGN KEY(외래키) 제약조건
    다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
    --> 다른 테이블을 참조한다고 표현
    --> FOREIGN KEY 제약조건에 의해 테이블 간의 관계가 형성됨
    
    >> COLUMN LEVEL 방식
    -- 컬럼명 자료형 REFERENCES 참조할테이블명(참조할컬럼명)
    컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명(참조할컬럼명)
    
    >> TABLE LEVEL 방식
    -- FOREIGN KEY(컬럼명)  REFERENCES 참조할테이블명(참조할컬럼명)
     [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명(참조할컬럼명)
    
    --> 참조할컬럼명 생략시 참조할테이블에 PRIMARY KEY로 지정된 컬럼으로 매칭     
*/

CREATE TABLE MEM2 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
   -- GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE)     -- COLUMN LEVEL
    GRADE_ID NUMBER, --NOT NULL 
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) -- TABLE LEVEL
);

INSERT INTO MEM2 VALUES (1, 'user01', 'pass01', '홍길동', '남', null, null, null);
-- 외래키 제약조건이 부여된 컬럼에 기본적으로 NULL 허용됨
INSERT INTO MEM2 VALUES (2, 'user02', 'pass02', '홍길동', '남', null, null, 20);
INSERT INTO MEM2 VALUES (3, 'user03', 'pass03', '홍길동', '남', null, null, 70); -- 오류발생 : "무결성 제약조건(DDL.SYS_C008412)이 위배되었습니다- 부모 키가 없습니다"
-- MEM_GRADE(부모테이블) -|--------<- MEM2(자식테이블)
--  (10,20,30 존재함)

-- 이때, 부모테이블 데이터값을 삭제할 경우 문제발생

-- 데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;
--              DELETE FROM 테이블명;  테이블의 모든게 삭제됨

-- > MEM_GRADE 테이블에서 20번 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 20; -- 오류발생 : "무결성 제약조건(DDL.SYS_C008412)이 위배되었습니다- 자식 레코드가 발견되었습니다"

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 30; -- "1 행 이(가) 삭제되었습니다."

-- 자식테이블에 30이라는 값을 사용하고 있지 않기 때문에 삭제가 됨

-- 자식테이블이 이미 사용하고 있는 값이 있을 경우
-- 부모테이블로부터 무조건 삭제가 안되는 삭제제한 옵션이 걸려있음 (기본값)

INSERT INTO MEM_GRADE VALUES(30, '특별회원'); -- "1 행 이(가) 삽입되었습니다."

-----------------------------------------------------------------------------
/*
    자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정가능
    * 삭제 옵션 : 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 
                 자식테이블의 값을 어떻게 처리할 것인지
                 
    - ON DELETE RESTRICTED(기본값) : 삭제제한옵션으로, 자식테이블이 데이터를 사용하고 있으면 부모데이터 삭제 불가
    - ON DELETE SET NULL : 자식테이블이 데이터를 사용하고 있으면 자식테이블의 값을 NULL로 변경후 부모데이터 삭제
    - ON DELETE CASCADE : 자식테이블이 데이터를 사용하고 있으면 자식테이블의 데이터(행) 삭제하고 부모데이터를 삭제
*/

CREATE TABLE MEM3 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE SET NULL
);
-- GRADE_ID NUMBER REFERENCES MEM_GRADE --> MEM_GRADE 테이블의 PRIMARY KEY와 외래키를 걸면 컬럼명을 안써도 됨

INSERT INTO MEM3 VALUES (1, 'user01', 'pass01', '홍길동', '남', null, null, 10);
INSERT INTO MEM3 VALUES (2, 'user02', 'pass02', '홍길동', '남', null, null, 20);
INSERT INTO MEM3 VALUES (3, 'user03', 'pass03', '홍길동', '남', null, null, 30); 

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 30;

CREATE TABLE MEM4 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE CASCADE
);

INSERT INTO MEM_GRADE VALUES(10, '일반회원');
--INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

INSERT INTO MEM4 VALUES (1, 'user01', 'pass01', '홍길동', '남', null, null, 10);
INSERT INTO MEM4 VALUES (2, 'user02', 'pass02', '홍길동', '남', null, null, 20);
INSERT INTO MEM4 VALUES (3, 'user03', 'pass03', '홍길동', '남', null, null, 30); 

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
-- 부모테이블의 행이 삭제되고, 자식테이블의 값이 들어있는 행도 삭제됨

------------------------------------------------------------------------------
/*
    <DEFAULT 기본값>
    컬럼을 선정하지 않고 INSERT시 NULL이 아닌 기본값을 INSERT 하고자 할 때 세팅해 둘 수 있는값
    
    컬럼명 자료형 DEFAULT 기본값 [제약조건]
*/
CREATE TABLE MEMBER2 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    MEM_AGE NUMBER DEFAULT 0,
    HOBBY VARCHAR2(20) DEFAULT '없음',
    MEM_DATE DATE DEFAULT SYSDATE
);

INSERT INTO MEMBER2 VALUES(1,'황길동', 20, '운동', '23/03/25');
INSERT INTO MEMBER2 VALUES(2,'왕길동', NULL, NULL, NULL);
INSERT INTO MEMBER2 VALUES(3,'강길동', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO MEMBER2(MEM_NO, MEM_NAME) VALUES(4,'김길동');



--============================================================================
/*
    ============================= KH 계정 ==================================
    <SUBQUERY를 이용하여 테이블 생성>
    테이블 복사하는 개념
    
    [표현식]
    CREATE TABLE 테이블명
    AS 서브쿼리;
*/
--============================================================================

-- EMPLOYEE 테이블을 복제한 새로운 테이블 생성

-- select_kh계정으로 USER 변경.
CREATE TABLE EMPLOYEE_COPY
AS SELECT *
     FROM EMPLOYEE;

-- 컬럼, 데이터값, 제약조건 같은경우 NOT NULL만 보가됨
-- DEFAULT와 COMMENTS는 COPY 안됨

CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
     FROM EMPLOYEE
    WHERE 1 = 0; -- 구조만 복사하고자 할때 쓰이는 구문 (데이터값이 필요 없을 때)
                 -- FALSE가 되도록.. 즉, 1 = 0 이 될수 없으므로 데이터는 하나도 가져오지않음

CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 
     FROM EMPLOYEE;  
-- 서브쿼리 SELECT절에 산술식 또는 함수식 기술된 경우 반드시 별칭 부여해야함
-- 오류 발생 : "이 식은 열의 별명과 함께 지정해야 합니다"

CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
     FROM EMPLOYEE;

------------------------------------------------------------------------------
/*
    * 테이블을 다 생성한 후 제약조건 추가
    ALTER TABLE 테이블명 변경할 내용;
    
    - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
    - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(참조할 컬럼명)];
                    ==> (참조할컬럼명)은 PRIMARY KEY 일때는 생략가능                   
    - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식);
                                            IN('남','여') | >= 등...
    - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
*/

-- EMPLOYEE_COPY 테이블에 PRIMARY KEY 제약조건 추가
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLOYEE 테이블에 DEPT_CODE에 외래키제약조건 추가
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

-- EMPLOYEE 테이블에 JOB_CODE에 외래키제약조건 추가
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;

-- DEPARTMENT 테이블에 LOCATION_ID에 외래키 제약조건 추가 (LOCATION테이블의 LOCAL_CODE)
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCAL_CODE);

-- EMPLOYEE_COPY 테이블에 MEM_ID와 MEM_NO의 컬럼에 COMMENT 넣어주기

COMMENT ON COLUMN EMPLOYEE_COPY.EMP_ID IS '회원아이디';
COMMENT ON COLUMN EMPLOYEE_COPY.EMP_NO IS '회원번호';



















