/*
    <SEQUENCE>
    자동으로 번호 발생시켜주는 역할을 하는 객체
    정수값을 순차적으로 일정값씩 증가 시키면서 생성해줌
    
    ex) 회원번호, 사원번호, 게시글번호, ...
--------------------------------------------------------
    1. 게시글1
    2. 게시글2
    3. 게시글1 답글
--------------------------------------------------------        
    번호        제목          내용      날짜
--------------------------------------------------------    
     2      게시글2
     1      게시글1
     3      - 게시글1 답글
--------------------------------------------------------     
    번호        제목          내용      날짜
-------------------------------------------------------- 
     1      게시글2
     2      게시글1
     3      - 게시글1 답글
*/

/*
    1. 시쿼스 객체 생성
    
    -------------------------주로 사용됨----------------------------
    [표현식]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작숫자]       --> 처음발생시킬 시작값 지정 (기본값 1,2,3, ...)
    [INCREMENT BY 숫자]        --> 몇 씩 증가 시킬것인지 (기본값 1씩 증가) 
    
    --------------------잘 사용하지 않음----------------------------
    [MAXVALUE 숫자]            --> 최대값 지정 (기본값 큼)
    [MINVALUE 숫자]            --> 최소값 지정 (기본값 1)
    [CYCLE | NOCYCLE]         --> 값 순환 여부 지정 (기본값 NOCYCLE)
    [NOCACHE | CACHE]         --> 캐시 메모리 할당 (기본값 CACHE 20)
    -------------------------------------------------------------
    * 캐시 메모리 : 미리 발생된 값들을 생성해서 저장해두는 공간
                 매번 호출될때 마다 새롭게 번호를 생성하는 것이 아니라
                 캐시메모리 공간에 미리 생성된 값들을 가져다 쓸 수 있음(속도가 빨라짐)
                 접속이 해제되면 => 캐시메모리에 미리 만들어 둔 값들은 사라짐
*/
--SEQ_TEST 생성
CREATE SEQUENCE SEQ_TEST;  -- Sequence SEQ_TEST이(가) 생성되었습니다.

--SEQ_EMPNO 생성
CREATE SEQUENCE SEQ_EMPNO  -- Sequence SEQ_EMPNO이(가) 생성되었습니다.
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용
    
    시쿼스명.CURRVAL : 현재 시쿼스의 값(마지막으로 성공적으로 수행한 NEXTVAL의 값
    시퀀스명.NEXTVAL : 시퀀스 값에서 INCREMENT BY 값 만큼 증가된 값
    == 시퀀스명.CURRVAL + INCREMENT BY 값
*/

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 300, LAST_NUMBER : 300 
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;  -- 결과값 : CURRVAL 300, LAST_NUMBER : 300 
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 305, LAST_NUMBER : 305 
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 310(MAXVALUE), LAST_NUMBER : 310

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;  -- MAXVAL : 310 이므로 실행불가
-- 오류 시퀀스 SEQ_EMPNO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
                                     
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;  -- 결과값 : CURRVAL 310(MAXVALUE), LAST_NUMBER : 310 

--SEQ_EMPNO2 생성
CREATE SEQUENCE SEQ_EMPNO2  -- Sequence SEQ_EMPNO2이(가) 생성되었습니다.
START WITH 300
INCREMENT BY 5
MAXVALUE 310
CYCLE
NOCACHE;

SELECT SEQ_EMPNO2.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 300, LAST_NUMBER : 300 
SELECT SEQ_EMPNO2.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 305, LAST_NUMBER : 305 
SELECT SEQ_EMPNO2.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 310(MAXVALUE), LAST_NUMBER : 310
SELECT SEQ_EMPNO2.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 1 (MINVALUE 값으로 순환 1)
SELECT SEQ_EMPNO2.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 6

--SEQ_EMPNO3 생성
CREATE SEQUENCE SEQ_EMPNO3  -- Sequence SEQ_EMPNO3이(가) 생성되었습니다.
START WITH 300
INCREMENT BY 5
MAXVALUE 310
MINVALUE 300
CYCLE
NOCACHE;

SELECT SEQ_EMPNO3.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 300, LAST_NUMBER : 300 사용
SELECT SEQ_EMPNO3.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 305, LAST_NUMBER : 305 사용
SELECT SEQ_EMPNO3.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 310(MAXVALUE), LAST_NUMBER : 310 사용
SELECT SEQ_EMPNO3.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 300 (MINVALUE 값 300으로 순환)
SELECT SEQ_EMPNO3.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 305

/*
    3. 시쿼스 구조 변경
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 숫자]        --> 몇 씩 증가 시킬것인지 (기본값 1씩 증가) 
    [MAXVALUE 숫자]            --> 최대값 지정 (기본값 큼)
    [MINVALUE 숫자]            --> 최소값 지정 (기본값 1)
    [CYCLE | NOCYCLE]         --> 값 순환 여부 지정 (기본값 NOCYCLE)
    [NOCACHE | CACHE]         --> 캐시 메모리 할당 (기본값 CACHE 20)    
    
    * START WITH 변경 불가!!
*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;  -- Sequence SEQ_EMPNO이(가) 변경되었습니다.

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;  -- 결과값 : NEXTVAL 320, LAST_NUMBER : 320

--4. 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO3; -- Sequence SEQ_EMPNO3이(가) 삭제되었습니다.


-----------------------------------------------------------------------------
--사원번호로 활용할 시퀀스 생성
CREATE SEQUENCE SEQ_EID
START WITH 400;  -- Sequence SEQ_EID이(가) 생성되었습니다.
/*
CREATED	2023/04/19
LAST_DDL_TIME	2023/04/19
SEQUENCE_OWNER	KH
SEQUENCE_NAME	SEQ_EID
MIN_VALUE	1
MAX_VALUE	9999999999999999999999999999
INCREMENT_BY	1
CYCLE_FLAG	N
ORDER_FLAG	N
CACHE_SIZE	20
LAST_NUMBER	400
SCALE_FLAG	N
EXTEND_FLAG	N
SHARDED_FLAG	N
SESSION_FLAG	N
KEEP_VALUE	N
DUPLICATED	N
SHARDED	N
*/

------------------------------------------------------------------------------
--사원번호로 활용할 시퀀스 생성
CREATE SEQUENCE SEQ_EID
START WITH 400;  -- Sequence SEQ_EID이(가) 생성되었습니다.

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '이개똥','200312-3123456','J5',SYSDATE);  -- 1 행 이(가) 삽입되었습니다.
        
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '최개똥','211123-4123456','J1','21/03/12');   -- 1 행 이(가) 삽입되었습니다.       