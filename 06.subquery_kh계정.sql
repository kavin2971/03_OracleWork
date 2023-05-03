/*
    * 서브쿼리 (SUBQUERY)
    - 하나의 SQL문 안에 포함된 또 다른 SELECT문
    - 메인 SQL문을 위해 보조 역할을 하는 QUERY문
*/

-- 박정보 사원과 같은 부서에 속한 사원들 조회
-- 1. 박정보 사원의 부서코드 조회
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME = '박정보';

-- 2. 부서코드가 D9인 사원의 이름 조회
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--  위의 단계를 하나의 쿼리문으로
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '박정보');

-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급코드, 급여 조회

--1. 전직원의 평균급여
SELECT CEIL(AVG(SALARY)) 평균급여
FROM EMPLOYEE;
--2. 급여가 3047633보다 많이 받는 사원의 사번, 이름, 직급코드, 급여
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                  FROM EMPLOYEE);

/*
    * 서브쿼리 구분
    서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라 분류
    
    - 단일행 서브쿼리 : 서브쿼리 조회 결과값이 오로지 1개 일 때 (한행 한열)
    - 다중행 서브쿼리 : 서브쿼리 조회 결과값이 여러행 일 때 (여러행 한열)
    - 다중열 서브쿼리 : 서브쿼리 조회 결과값이 한행 여러열 일 때 (한행 여러열)
    - 다중행 다중열 서브쿼리 : 서브쿼리 조회 결과값이 여러행 여러열 일 때 (여러행 여러열)
    
    >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/  
------------------------------------------------------------------------------
/*
    1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
    서브쿼리 조회 결과값이 오로지 1개 일 때 (한행 한열)
    일반 비교연산자 사용가능
    =, !=, >, >= ....
*/
-- 1) 전 직원의 평균급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
                ORDER BY SALARY;

-- 2) 최저 급여를 받는 사원의 사번, 이름, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
-- 3) 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
                
------------------------------------ JOIN -------------------------------------

-- 4) 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 부서명, 급여

--  >> 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_ID = DEPT_CODE
AND SALARY > (SELECT SALARY
            FROM EMPLOYEE
            WHERE EMP_NAME = '박정보');
--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE SALARY > (SELECT SALARY
            FROM EMPLOYEE
            WHERE EMP_NAME = '박정보');
-- 5) 선우정보와 같은 부서원들의 사번, 사원명, 전화번호, 부서명 조회 (단, 구정하 제외)
SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_CODE = (SELECT DEPT_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '구정하')               
AND EMP_NAME != (SELECT EMP_NAME
                FROM EMPLOYEE
                WHERE EMP_NAME = '구정하');

SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                    WHERE EMP_NAME = '구정하')               
AND EMP_NAME != '구정하';

------------------------------------------------------------------------------
-- GROUP BY
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
--  6.1 부서별 급여합 중 가장큰 값
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--  6.2 부서별 급여 합이 17700000인 부서 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 위의 쿼리문을 하나로
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                       FROM EMPLOYEE
                   GROUP BY DEPT_CODE);
------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
    서브쿼리 조회 결과값이 여러행 일 때 (여러행 한열)
    - IN 서브쿼리 :  여러개의 결과 값 중에서 한개라도 일치하는 값이 있다면
    - > ANY 서브쿼리 : 여러개의 결과 값 중에서 "한개라도" 클 경우                     
                      (여러개의 결과값 중에서 가장 작은값 보다 클 경우)
    - < ANY 서브쿼리 : 여러개의 결과 값 중에서 "한개라도" 작을 경우                     
                      (여러개의 결과값 중에서 가장 큰값 보다 작을 경우) 
    비교대상 > ANY (값1, 값2, 값3)
    비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
    
*/

-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여

-- 1.1 조정연 또는 전지연 사원과 같은 직급코드
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('조정연', '전지연'); -- J3, J7

-- 1.2 직급코드가 J3, J7인 사원의 사번, 사원명, 직급코드, 급여
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                     FROM EMPLOYEE
                    WHERE EMP_NAME IN ('조정연', '전지연'));

-- 2) 대리 직급임에도 불구하고 과장 직급 급여들중 최소 급여보다 많이 받는 사원의 사번, 이름, 직급명, 급여
-- 2.1 과장 직급 사원들 급여
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장';  -- 2200000, 2500000, 3760000

-- 2.1 직급이 대리이면서 급여 값이 위의 목록들 값중에서 하나라도 큰사원들의 사번, 이름, 직급명, 급여
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY(2200000, 2500000, 3760000);

-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '대리'
   AND SALARY > ANY(SELECT SALARY
                      FROM EMPLOYEE
                      JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '과장');

-- 단일행 서브쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '대리'
   AND SALARY > ANY(SELECT MIN(SALARY)
                      FROM EMPLOYEE
                      JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '과장');

-- 3. 차장 직급임에도 과장직급의 급여 보다 적게 받는 사원의 사번 , 이름, 직급명, 급여
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '차장'
   AND SALARY < ANY(SELECT SALARY
                      FROM EMPLOYEE
                      JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '과장');

-- 차장중에 과장보다 급여를 적게받는 사원들중 최저
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '차장'
   AND SALARY < ANY(SELECT MIN(SALARY)
                      FROM EMPLOYEE
                      JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '과장');

-- 4. 과장 직급임에도 차장 직급인 사원들의 급여보다 더 많이 받는 사원의 사번, 이름, 직급명, 급여
-- ANY : 차장중 가장 적게 받는 급여보다 많이 받는 과장
--       비교대상 > 값1, OR 비교대상 > 값2 OR 비교대상 > 값3
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '과장'
   AND SALARY > ANY(SELECT SALARY
                      FROM EMPLOYEE
                      JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '차장');

-- ALL : 차장의 가장 많이 받는 급여 보다 많이 받는 과장
--       비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '과장'
   AND SALARY > ALL(SELECT SALARY
                      FROM EMPLOYEE
                      JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '차장');

------------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리 
    결과값은 한행이지만 나열된 컬럼수가 여러개일 경우
    (한행 여러열)   
*/
-- 1. 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                    WHERE EMP_NAME = '장정보')
AND JOB_CODE = (SELECT JOB_CODE
                  FROM EMPLOYEE
                 WHERE EMP_NAME = '장정보')
AND EMP_NAME != '장정보';

-- >> 다중열 서브쿼리로
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '장정보');
-- 2. 지정보 사원과 같은 직급코드, 같은 사소를 가지고 있는 사원의 사번, 사원명, 직급코드, 관리자사번
SELECT EMP_ID, EMP_NAME, JOB_CODE, EMP_ID, MANAGER_ID
  FROM EMPLOYEE
 WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                   FROM EMPLOYEE
                                  WHERE EMP_NAME = '지정보');

------------------------------------------------------------------------------
 /*
  4. 다중행 다중열 서브쿼리  
  서브쿼리 조회 결과값이 여러행 여러줄일 경우 (여러행 여러열)
 */
 -- 1. 각 직급별 최소급여 금액을 받는 사원의 사번, 이름, 직급코드, 급여
 --     1.1 각 직급별 최소급여를 받는 사원들의 직급코드
 SELECT JOB_CODE 직급코드, MIN(SALARY) 최소금액
 FROM EMPLOYEE
 GROUP BY JOB_CODE;
 --     1.2
 SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE;
 
 /*
 WHERE (JOB_CODE, SALARY) = ('J1', 8000000)
    OR (JOB_CODE, SALARY) = ('J1', 8000000)
    OR (JOB_CODE, SALARY) = ('J1', 8000000) 
    OR (JOB_CODE, SALARY) = ('J1', 8000000) 
    ....;
 */
 
 /*
 GROUP BY JOB_CODE = 'J1' AND '8000000'
       OR JOB_CODE = 'J2' AND '3700000'
       OR JOB_CODE = 'J3' AND '3400000'
       OR JOB_CODE = 'J4' AND '1550000'
       OR JOB_CODE = 'J5' AND '2200000'
       OR JOB_CODE = 'J6' AND '1380000'
       OR JOB_CODE = 'J7' AND '2000000';
 */
 
 -- 서브쿼리로 적용
  SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
  WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);
 
 -- 2. 각 부서별 최고 급여를 받는 사원의 사번, 사원명, 직급코드, 급여 
 SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_CODE 부서코드, SALARY 급여
   FROM EMPLOYEE
  WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                 FROM EMPLOYEE
                                GROUP BY DEPT_CODE);
                                
------------------------------------------------------------------------------
 /*                     ↙ VIEW 가상테이블
  5. 인라인 뷰 (INLINE VIEW) 
  FROM 절에 서브쿼리작성
  
  서브쿼리를 수행한 결과를 마치 테이블처럼 사용
 */                                
 
 -- 사원들의 사번, 이름, 보너스포함연봉(별칭부여), 부서코드 조회
 -- >> 연봉이 NULL이 나오지 않도록
 -- >> 조건 : 연봉이 3000만원 이상인 사원들만 조회
                                
SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 연봉, DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY+SALARY*NVL(BONUS,0))*12 >= 30000000;
-- WHERE 연봉 >= 30000000;
-- 오류(별칭안됨) : 순서 FROM (테이블의 모든 데이터) → WHERE(조건)에 맞는 행 (모든컬럼) 추출 SELECT(조건에
                                
-- WHERE 절에 별칭으로 사용하고 싶으면 INLINE VIEW 사용
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,1))*12 연봉, DEPT_CODE
      FROM EMPLOYEE)     -- TABLE 처럼 사용
WHERE 연봉 >= 30000000;

SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 연봉, DEPT_CODE
  FROM EMPLOYEE;  
  
-- INLINE VIEW 테이블에서 내가 원하는 컬럼만 가져올수 있음
SELECT EMP_ID, EMP_NAME, 연봉
FROM (SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 연봉, DEPT_CODE 
      FROM EMPLOYEE)     -- TABLE 처럼 사용
WHERE 연봉 >= 30000000;  

-- INLINE VIEW 테이블에서 없는 컬럼은 가져올 수 없다
SELECT 사번, 이름, 연봉, PHONE
FROM (SELECT EMP_ID 사번, EMP_NAME 이름, (SALARY+SALARY*NVL(BONUS,0))*12 연봉, DEPT_CODE 
      FROM EMPLOYEE)     -- TABLE 처럼 사용
WHERE 연봉 >= 30000000;

-- INLINE VIEW 를 주로 사용하는 예 => TOP-N 분석 (상위 몇위만 가져오기)

-- 전 직원 중 급여가 가장 높은 상위 5명만 조회
-- *ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

-- 선순위
-- 1.FROM → 2.SELECT → 3.ORDER (순서가 맨 마지막)

-- ORDER BY 절이 다 수행된 결과를 가지고 ROWNUM 부여한 후 5명을 추출
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) 
WHERE ROWNUM <= 5;      

SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;               
        
-- 가장 최근에 입사한 사원명 5명의 사원명, 급여, 입사일조회

SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)E
WHERE ROWNUM <= 5;

SELECT *
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

-- 각 부서별 평균 급여가 높은 3개의 부서의 부서코드, 평균급여 조회
SELECT *
FROM(SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
       FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <= 3;

SELECT DEPT_CODE, CEIL(평균급여)
FROM(SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
       FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <= 3;

SELECT *
FROM(SELECT DEPT_CODE, ROUND(AVG(SALARY))
       FROM EMPLOYEE 
      GROUP BY DEPT_CODE
      ORDER BY 2 DESC)
WHERE ROWNUM  <=3;

---------------------------------------------------------------------------
/*
    * 순위 매기는 함수 (WINDOW FUNTION)
    RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
    - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
                             ex) 공동1위가 2명이면, 그 다음 순위는 3위
    - DENSE_RANK() OVER(정렬기준) : 동일한 순위 이후의 등수는 인원수와 상관없이 1을 증가 시킴     
                             ex) 공동1위가 2명이면, 그 다음 순위는 2위
                             
*/
-- 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- 공동 19위 2명, 그 다음 순위는 21위

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- 공동 19위 2명, 그 다음 순위는 20위

-- 급여가 상위 5위인 사원들의 이름, 급여, 순위 조회

SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- >> INLINE
SELECT *
FROM(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
       FROM EMPLOYEE)
WHERE 순위 <= 5;       

SELECT *
FROM(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC)
       FROM EMPLOYEE)
WHERE ROWNUM <= 5; 

/*
    WITH 
    서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM 절에 기술
    - 장점
    같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할수 있고
    실행속도도 빨라진다는 장점이 있음
    
    WITH 서브쿼리명 AS (서브쿼리)
*/

WITH TOPN_SAL3 AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE
                    ORDER BY 2 DESC)                   
/*
SELECT DEPT_CODE, 평균급여
FROM TOPN_SAL3
WHERE ROWNUM <= 3;
*/

SELECT *
FROM TOPN_SAL3
WHERE ROWNUM <= 5;

-- >> INLINE VIEW 밖에 할수 없음
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
        FROM  EMPLOYEE)
        WHERE 순위 <= 5;

--WITH와 함께 사용
WITH TOP_SALARY AS (SELECT EMP_NAME, SALARY, RANK() OVER (ORDER BY SALARY DESC) 순위
                     FROM EMPLOYEE)
SELECT 순위, EMP_NAME, SALARY
FROM TOP_SALARY
WHERE 순위 <= 5;





