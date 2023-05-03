/*
    <JOIN>
    두개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
    조회 결과는 하나의 결과물(RESULT SET)로 나옴
    
    관계형 데이터베이스는 최소한의 데이터로 각각 테이블에 담겨 있음
    (중복을 최소하하기 위해 최대한 쪼개서 관리)
    → 관계형 데이터베이스에서 SQL문을 이용한 테이블간 "관계"를 맺는 방법
    
    JOIN은 크게 "오라클전용구문"과 "ANSI구문" (ANSI == 미국국립표준협회)
    
------------------------------------------------------------------------------
                            [ JOIN 용어 정리]  
             오라클 전용 구문         |                ANSI 구문
------------------------------------------------------------------------------
                등가조인             |  내부조인(INTER JOIN) → JOIN USING / ON
              (EQUAL JOIN)          |  자연조인(NATURAL JOIN) → JOIN USING
------------------------------------------------------------------------------          
                포괄조인             |       왼쪽 외부조인(LEFT OUTER JOIN)
              (LEFT OUTER)          |      오른쪽 외부조인(RIGHT OUTER JOIN)
              (RIGHT OUTER)         |       전체 외부조인(FULL OUTER JOIN
------------------------------------------------------------------------------
            자체조인(SELF JOIN)      |                JOIN ON
        비등가 조인(NON EQUAL JOIN)   |  
------------------------------------------------------------------------------
     카테시안 곱(CARTESIAN PRODUCT)  |           교차조인(CROSS JOIN)
------------------------------------------------------------------------------              
*/

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

------------------------------------------------------------------------------
/*
    1. 등가조인(EQUAL JOIN) / 내부조인 (INNER JOIN)
       연결시키는 컬럼의 값이 "일치하는 행들만" 조인되어 조회 (= 일치하는 값이 없으면 행은 조회에서 제외)
*/
       
--       >> 오라클 전용 구문
--       FROM 절에 조회하고자하는 테이블 나열 (, 구분자로)
--       WHERE 절에 매칭시킬 컬럼(연결고리)에 대한 조건을 제시함

-- 1) 연결할 컬럼명이 다른 경우 (DEPT_CODE, DEPT_ID)
-- 사번, 사원명, 부서코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;

-- 컬럼명이 다른경우 WHERE 절에 반드시 두 테이블의 컬럼명을 넣어야한다.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 2) 연결할 컬럼명이 같은 경우 (EMPLOYEE : JOB_CODE / JOB : DOB_CODE)
-- 사번, 사원명, 직급코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB;
-- 해결방법1) "열의 정의가 애매합니다" 오류를 해결하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결방법2) 테이블에 별칭을 부여하여 이용하는 방법
-- 해당방법을 주로 사용한다.
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- >> ANSI 구문
--    FROM 절에 기준이 되는 테이블을 하나 기술 한 후 
--    JOIN 절에 같이 조회하고자 하는 테이블 기술 _ 매칭시킬 컬럼에 대한 조건도 기술
--    JOIN USING, JOIN ON

-- 1) 연결할 컬럼명이 다른 경우 (EMPLOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID)
-- JOIN ON 구문으로만 가능

-- 사번, 사원명, 부서코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결할 컬럼명이 같은 경우 (EMPLOYEE : JOB_CODE / JOB : DOB_CODE)
-- JOIN ON, JOIN USING 구문 사용가능
-- 사번, 사원명, 직급코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON (JOB_CODE = JOB_CODE);  --오류 : "열의 정의가 애매합니다"


-- 해결방법1) 테이블명 또는 별칭을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON(EMPLOYEE.JOB_CODE = JOB.JOB_CODE);
-- 별칭부여
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);
--        ↖ 변수명


-- 해결방법2) JOIN USING 구문 사용하는 방법 (두 컬럼명이 일치할 때만 사용가능)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);
--     ↖ 테이블명

-- [참고사항]
-- 자연조인(NATURAL JOIN) : 각 테이블마다 동일한 컬럼이 한 개만 존재할 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;
--             ↖ 테이블명

-- 해결방법3) 추가적인 조건 제시 가능
-- 직급이 대리인 사원의 사번, 이름, 직급, 급여 조회

-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리';

-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME,JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리';

---------------------------------- 실습문제 ----------------------------------
--1.문제 ------인사관리부인 사원들의 사번, 사원명, 부서명, 보너스-------------------
-- >> 오라클 전용 구문
SELECT EMP_ID, DEPT_TITLE, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE= '인사관리부';

---- >> ANSI 구문
SELECT EMP_ID, DEPT_TITLE, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

--2.문제 ---부서번호, 부서명, 지역번호, 지역명--------------------
-- >> 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM  DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- >> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);


--3.문제 ---보너스를 받는 사번, 사원명, 보너스 부서명---------------
-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL;

-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

--4.문제 ---부서가 총무부가 아닌 사원의 사원명, 급여 -------------
-- >> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE != '총무부';

-- >> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE <> '총무부';

-----------------------------------------------------------------------------
/*
    2. 포괄조인 / 외부조인
    두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜 조회가능
    단, 반드시 LEFT / RIGHT 를 지정해야됨 (기준이 되는 테이블 지정)
*/
-- 외부조인과 비교할만한 INNER JOIN 조회
-- 사원명, 부서명, 급여, 연봉
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);  -- 부서배치가 안된 사원 조회안됨

-- 1) LEFT[OUTER] JOIN : 두 테이블 중 왼쪽에 기술된 테이블을 기준으로 JOIN
-->> 오라클전용구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- 기준이 되는 테이블에 반대편 테이블의 컬럼명 뒤 (+)를 붙이기

-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12   --23행
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) RIGHT[OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블을 기준으로 JOIN
-->> 오라클전용구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12   --24행
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); 

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행 조회 (단, 오라클 구문으로는 안됨)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);   --26행

-----------------------------------------------------------------------------
/*
    3. 비등가 조인 (NON EQUAL JOIN)
    매칭시킬 컬럼에 대한 조건 작성시 '='을 사용하지 않는 JOIN
    ANSI 구문으로는 JOIN ON으로만 가능
*/

-- 사원명, 급여, 급여레벨 조회
--  >> 오라클전용 구문
SELECT EMP_NAME, SALARY,SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;

SELECT EMP_NAME, SALARY,SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

--  >> ANSI 구문
SELECT EMP_NAME, SALARY,SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-----------------------------------------------------------------------------
/*
    4. 자체조인 (SELF JOIN)
     같은 테이블을 다시한번 조인하는 경우
*/
-- 전체 사원의 사원번호, 사원명, 사원부서코드, 사수사번, 사수명, 사수부서코드

--  >> 오라클 전용 구문

--  사수가 있는 사원만 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, E.MANAGER_ID, M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

--  모든 사원 (NULL 포함)의 사수 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, E.MANAGER_ID, M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);

--  >> ANSI 구문
--  사수가 있는 사원만 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, E.MANAGER_ID, M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

--  모든 사원 (NULL 포함)의 사수 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, E.MANAGER_ID, M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

-----------------------------------------------------------------------------
/*
    <다중 조인>
    2개 이상의 테이블을 가지고 JOIN 할 때
*/
-- 사번, 사원명, 부서명, 직급명

-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE;
--              ↖ 별칭을 안넣어줘도됨      ↖ 별칭을 반드시 넣어줘야됨

--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

-- 2) 사번EMP_ID, 사원명EMP_NAME, 부서명DEPT_TITLE , 지역명 LOCAL_NAME 조회
-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID AND LOCATION_ID = LOCAL_CODE;

--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
---------------------------------- 실습문제 ----------------------------------

--1. 사번, 사원명, 부서명, 지역명, 국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION L, NATIONAL N
WHERE DEPT_CODE = DEPT_ID 
AND LOCATION_ID = LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE;

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL N ON  (L.NATIONAL_CODE = N.NATIONAL_CODE);

--2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, SAL_GRADE, NATIONAL N
WHERE DEPT_CODE = DEPT_ID 
AND LOCATION_ID = LOCAL_CODE
AND E.JOB_CODE = J.JOB_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND SALARY BETWEEN MIN_SAL AND MAX_SAL;

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN JOB USING(JOB_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);




