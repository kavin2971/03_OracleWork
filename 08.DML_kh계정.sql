/*
    * DML (Data Manipulation Language) : 데이터 조작 언어
    테이블에 값을 삽입(INSERT), 수정(UPDATE), 삭제(DELETE), 검색(SELECT)하는 구문
*/

--============================================================================
/*
    1.INSERT
        테이블에 새로운 행을 추가하는 구문
        
    [표현식]
    1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3 ...);
        테이블에 모든 컬럼에 대한 값을 직접 제시하여 한 행을 넣고자 할 때 사용
        컬럼 순서를 지켜 VALUES에 값을 나열해야 함
        
        - 데이터 값이 컬럼의 갯수보다 적거나 많으면 오류가 발생됨
*/

INSERT INTO EMPLOYEE VALUES(230, '홍길동', '120304-2473847', 'hong@google.com', '01012341234', 'D3', 'J2', 3500000, 0.2, NULL, SYSDATE, NULL, DEFAULT);
------------------------------------------------------------------------------
/*
    2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3 ...) VALUES(값1, 값2, 값3 ...);
    - 테이블에 내가 선택한 컬럼에 대한 값만 삽입하고자 할 때
      (행단위로 추가 되기 때문에 넣지 않은 값은 NULL이나 DEFAULT값이 들어감)
    - 컬럼명을 기재한 순서에 맞춰 데이터를 입력해야 됨
    => NOT NULL 제약조건이 있는 컬럼은 반드시 값을 넣어줘야 됨
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)-- 해당컬럼 제외항목은 DEFAULT값 적용됨
VALUES(240, '아무개','340908-1295867', 'J5', '11/10/21'); 

INSERT INTO EMPLOYEE(EMP_NO, JOB_CODE, EMP_ID, EMP_NAME, DEPT_CODE)
VALUES('581123-2867589', 'J7', 241, '이길동', 'D3');

-----------------------------------------------------------------------------
/*
INSERT 
    INTO EMPLOYEE
            (
                EMP_NO
              , JOB_CODE
              , EMP_ID
              , EMP_NAME
              , DEPT_CODE
            )
    VALUES
            (
                '581123-2867589'
              , 'J7'
              , 241
              , '이길동'
              , 'D3'
            );
-----------------------------------------------------------------------------
INSERT 
    INTO EMPLOYEE 
    VALUES
        (
            230
          , '홍길동'
          , '120304-2473847'
          , 'hong@google.com'
          , '01012341234'
          , 'D3'
          , 'J2'
          , 3500000
          , 0.2
          , NULL
          , SYSDATE
          , NULL
          , DEFAULT
        );
*/
-----------------------------------------------------------------------------
/*
    3) INSERT INTO 테이블명 (서브쿼리);
       VALUES로 값을 직접 명시하는 대신 서브쿼리로 조회된 결과값을 모두 INSERT 가능 (여러행도 가능)
*/
-- EMP_01 테이블 생성
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_CODE VARCHAR2(20)
);

-- EMPLOYEE 테이블에서 전체사원의 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
  FROM EMPLOYEE;

INSERT INTO EMP_01 (SELECT EMP_ID, EMP_NAME, DEPT_CODE
                      FROM EMPLOYEE);
                      
-- EMP_02 테이블 생성
CREATE TABLE EMP_02 (
    EMP_ID VARCHAR2(3),
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(35)
);

-- 전 사원의 사번, 사원명, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
  FROM EMPLOYEE 
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 부서코드가 NULL 제외
  
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 전 사원

INSERT INTO EMP_02 (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
                      FROM EMPLOYEE
                      LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));

--===========================================================================
/*
    * INSERT ALL
    두개 이상의 테이블에 각각 INSERT 할 때
    이때 사용되는 서브쿼리가 동일한 경우
    
    [표현식]
    INSERT ALL
        INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
        INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
             서브쿼리;
*/

-- 테이블 2개 생성
--EMP_DEPT 테이블 생성
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
     FROM EMPLOYEE
    WHERE 1 = 0;    

--EMP_MANAGER 테이블 생성    
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
     FROM EMPLOYEE
    WHERE 1 = 0;
    
-- 부서코드가 'D1'인 사원들의 사번, 사원명, 부서코드, 입사일, 사수번호 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D1';

-- EMP_DEPT, EMP_MANAGER 테이블에 데이터가져오기
INSERT ALL 
    INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
         SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
           FROM EMPLOYEE
          WHERE DEPT_CODE = 'D1';

-- 테이블 2개
CREATE TABLE EMP_INFO
AS SELECT EMP_ID, EMP_NAME, EMP_NO, PHONE, EMAIL
     FROM EMPLOYEE
    WHERE 1 = 0;

CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
     FROM EMPLOYEE
    WHERE 1 = 0;
    
-- 전 사원의 서브쿼리를 이용하여 값을 입력하시오    
INSERT ALL
    INTO EMP_INFO VALUES(EMP_ID, EMP_NAME, EMP_NO, PHONE, EMAIL)
    INTO EMP_SALARY VALUES(EMP_ID, EMP_NAME, SALARY, BONUS)
         SELECT EMP_ID, EMP_NAME, EMP_NO, PHONE, EMAIL, SALARY, BONUS
         FROM EMPLOYEE;
    
-- INSERT ALL
--    INTO EMP_INFO VALUES(EMP_ID, EMP_NAME, EMP_NO, PHONE, EMAIL)
--    INTO EMP_SALARY VALUES(EMP_ID, EMP_NAME, SALARY, BONUS)
--         SELECT *
--         FROM EMPLOYEE;   
 
 /*
    * 조건을 사용하여 각 테이블에 값을 삽입
    [표현식]
        INSERT ALL
        WHEN 조건1 THEN
            INTO 테이블명1 VALUES(컬럼명,컬럼명, ...)
        WHEN 조건2 THEN
            INTO 테이블명2 VALUES(컬럼명,컬럼명, ...)
        서브쿼리;
*/
-- 2000년도 이전 입사한 사원들을 넣을 테이블
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;
-- 2000년도 이후 입사한 사원들을 넣을 테이블
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;
    
INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)

    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;   

--===========================================================================
/*
    3. UPDATE
    테이블에 기록되어 있는 기존의 데이터를 수정하는 구문
    
    [표현식]
    UPDATE 테이블
    SET 컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...             --> 여러개의 컬럼값을 동시 변경가능
        [WHERE 조건]    --> 주의 : 조건을 생략하면 모든 행의 데이터가 변경
*/

-- EMP_02 테이블의 DEPT_TITLE 변경
UPDATE EMP_02
   SET DEPT_TITLE = '전략기획팀';

ROLLBACK;  -- 이전으로(실행취소)

-- 부서명이 총무부 인것만 바뀜    
UPDATE EMP_02
   SET DEPT_TITLE = ' 전략기획팀'
 WHERE DEPT_TITLE = '총무부';
 
-- EMP_SALARY 테이블에서 김정보 사원의 급여를 9000000으로 변경
UPDATE EMP_SALARY
   SET SALARY = 9000000
 WHERE EMP_NAME = '김정보';

-- EMP_SALARY 에서 박정보 사원의 급여를 4000000원으로, 보너스를 0.2로 변경
UPDATE EMP_SALARY
   SET SALARY = 4000000, BONUS = 0.2
 WHERE EMP_NAME = '박정보';
    
----------------------------------------------------------------------------
/*
    * UPDATE시 서브쿼리 사용가능
    
    [표현법]
    UPDATE 테이블명
       SET 컬럼명 = (서브쿼리)
     WHERE 조건;
*/
-- EMP_SALARY 테이블에서 전정보 사원의 급여, 보너스를 아무개에 급여 보너스로 동일하게변경
UPDATE EMP_SALARY
   SET SALARY = (SELECT SALARY 
                   FROM EMP_SALARY 
                  WHERE EMP_NAME = '전정보'),
        BONUS = (SELECT BONUS 
                   FROM EMP_SALARY 
                  WHERE EMP_NAME = '전정보')
 WHERE EMP_NAME = '아무개';
 
 -- 다중열 서브쿼리로도 가능
 UPDATE EMP_SALARY
   SET (SALARY, BONUS) = (SELECT SALARY,BONUS
                            FROM EMP_SALARY 
                           WHERE EMP_NAME = '문정보')
 WHERE EMP_NAME = '이길동';
 
 -- 전체사원의 급여를 기존의 급여에 10% 인상한 금액 (1존금액*1.1)
 UPDATE EMP_SALARY
 SET SALARY = SALARY *1.1;
 
 -- AISA 지역에 근무하는 사원들의 보너스를 0.3 으로 변경
 UPDATE EMPLOYEE_COPY
    SET BONUS = 0.3
  WHERE EMP_NAME IN (SELECT EMP_NAME
                     FROM EMPLOYEE_COPY
                     JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
                     JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
                    WHERE LOCAL_NAME LIKE 'ASIA%');
 
 -- EMP_SALARY 테이블에서 이정하, 홍정보, 최하보, 지정보, 정보 사원의 보너스를 오정보의 보너스와 같도록 변경
 UPDATE EMP_SALARY
   SET BONUS = (SELECT BONUS
                  FROM EMP_SALARY 
                 WHERE EMP_NAME = '오정보')
 WHERE EMP_NAME IN ('이정하','홍정보', '최하보', '지정보', '정보');
 --------------------------------------------------------------------------------
-- UPDATE시에도 해당 컬럼에 대한 제약조건이 위배되면 안됨

-- EMPLOYEE테이블에서 사번이 200번인 사원의 이름을 NULL로 변경
UPDATE EMPLOYEE
   SET EMP_NAME = NULL
 WHERE EMP_ID = 200; -- NOT NULL 위배
 
UPDATE EMPLOYEE
   SET JOB_CODE = 'J9'
 WHERE EMP_NAME = '김정보'; -- FOREIGN KEY 위배
 
--------------------------------------------------------------------------------
/*
    * DELETE
      테이블에 기록된 데이터를 삭제하는 구문(행단위로 삭제)
      
      [표현식]
      DELETE FROM 테이블명
      [WHERE 조건]; -- 주의 : 조건을 제시하지 않으면 모든 행 삭제
*/
DELETE FROM EMPLOYEE_COPY3;

DELETE FROM EMPLOYEE_COPY
WHERE EMP_NAME = '지정보';

DELETE FROM EMPLOYEE_COPY
WHERE DEPT_CODE = 'D1';

ROLLBACK;

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D4';

ROLLBACK;
-----------------------------------------------------------------------------
/*
    *TRUNCATE : 테이블의 전체행을 삭제할때 사용되는 구문
                DELETE보다 수행속도가 더 빠름
                별도의 조건 제시 불가, ROLLBACK 불가
                
        [표현식]
        TRUNCATE TABLE 테이블명;
*/

TRUNCATE  TABLE EMP_01; -- 롤백불가




