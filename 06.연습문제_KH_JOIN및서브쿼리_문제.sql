-- KH_연습문제
-- 1. 2020년 12월 25일의 요일 조회
SELECT TO_CHAR(TO_DATE(20201225), 'YYYY"년" MM"월" DD"일" DAY')요일조회 FROM DUAL;

-- 2. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회 
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E,DEPARTMENT,JOB J
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND EMP_NAME LIKE '전%'
AND SUBSTR(EMP_NO, 8, 1)IN ('2', '4')
AND SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79;

-- 3. 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회
SELECT EMP_CODE, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND MAX(EMP_NO);


-- 4. 이름에 ‘하’이 들어가는 사원의 사원 코드, 사원 명, 직급 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND EMP_NAME LIKE '%하%';

-- 5. 부서 코드가 D5이거나 D6인 사원의 사원 명, 직급, 부서 코드, 부서 명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND DEPT_CODE BETWEEN 'D5' AND 'D6';

-- 6. 보너스를 받는 사원의 사원 명, 보너스, 부서 명, 지역 명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND BONUS IS NOT NULL;

-- 7. 사원 명, 직급, 부서 명, 지역 명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, JOB J, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND E.JOB_CODE = J.JOB_CODE;

-- 8. 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회 
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_CODE BETWEEN 'JP'
AND 'KR';

-- 9. 한 사원과 같은 부서에서 일하는 사원의 이름 조회
SELECT E.EMP_NAME, Y.EMP_NAME, E.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE Y
WHERE E.DEPT_CODE = Y.DEPT_CODE
AND E.EMP_NAME != Y.EMP_NAME
ORDER BY 3;

-- 10. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND E.JOB_CODE BETWEEN 'J4' AND 'J7'
AND BONUS IS NOT NULL;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE NVL(BONUS,0) = 0 AND JOB_CODE IN ('J4','J7');
-- 11. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT 
COUNT(DECODE(ENT_YN, 'N', 1)) "재직",
COUNT(DECODE(ENT_YN, 'Y', 1)) "퇴사"
FROM EMPLOYEE;

-- 12. 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서 명, 직급, 입사일, 순위 조회

SELECT*
FROM(SELECT EMP_ID, EMP_NAME, RANK() OVER(ORDER BY SALARY+SALARY*NVL(BONUS,0)*12 DESC) 순위
    FROM EMPLOYEE)
WHERE 순위 <=5;


-- 13. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서 명, 부서 별 급여 합계 조회
--	13-1. JOIN과 HAVING 사용  

SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2 
                        FROM EMPLOYEE);

--	13-2. 인라인 뷰 사용      
SELECT DEPT_TITLE, SSAL
FROM (SELECT DEPT_TITLE , SUM(SALARY) SSAL
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_TITLE)

WHERE SSAL > (SELECT SUM(SALARY)*0.2 
                       FROM EMPLOYEE);
--	13-3. WITH 사용
WITH DEPT_SALARY AS (SELECT DEPT_TITLE, SUM(SALARY) DEPT_SALARY_SUM
                       FROM EMPLOYEE
                       JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
                      GROUP BY DEPT_TITLE)
                      
SELECT DEPT_TITLE 부서명, DEPT_SALARY_SUM 급여합계
FROM DEPT_SALARY
WHERE DEPT_SALARY_SUM > (SELECT SUM(SALARY)*0.2 
                           FROM EMPLOYEE);

-- 14. 부서 명과 부서 별 급여 합계 조회
SELECT DEPT_TITLE 부서명, SUM(SALARY)급여합계
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
GROUP BY DEPT_TITLE;

-- 15. WITH를 이용하여 급여 합과 급여 평균 조회
WITH SALARY_SUM_AVG AS (SELECT SUM(SALARY) 급여합, CEIL(AVG(SALARY)) 급여평균
                          FROM EMPLOYEE)
SELECT *
FROM SALARY_SUM_AVG;