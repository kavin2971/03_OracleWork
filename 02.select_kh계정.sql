/*
    (') 홑따옴표 : 문자열을 감싸주는 기호
    (") 쌍따옴표 : 컬럼명 등을 감싸주는 기호
*/
/*
    <select>
    데이터 조회할 때 사용하는 구문
    
    >> result set : select문을 통해 조회된 결과물 (즉, 조회된 행(tuple)들의 집합)
    
    [표현법]
    SELECT 조회하고자하는 컬럼, 컬럼, ...
    FROM 테입블명;
*/

SELECT *
FROM EMPLOYEE;

--EMPLOYEE Table 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT *
FROM JOB;
--JOB TABLE ALL COLUMN 조회

/*
 연습문제
1. JOB TABLE 직급명 조회
2. DEPARTMENT TABLE ALL COLUMN 조회
3. DEPARTMENT TABLE 부서코드, 부서명 조회
4. EMPLOYEE TABLE 사원명, 이메일, 전화번호, 입사일, 급여 조회
*/

SELECT JOB_NAME
FROM JOB;

SELECT *
FROM DEPARTMENT;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE;

----------------------------컬럼(COLUMN)값을 통한 산술 연산 ----------------------

/*
    SELECT 절 컬럼명 작성부분에 산술 연산기술 가능 (이때, 산술연산된 결과값 조회)
*/

--EMPLOYEE TABLE 사원명, 사원의 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY*12
FROM EMPLOYEE;

--EMPLOYEE TABLE 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE;

--EMPLOYEE TABLE 사원명, 급여, 보너스, 연봉, 보너스가 포함된 연봉(급여 + 보너스*급여)*12 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY+BONUS*SALARY)*12
FROM EMPLOYEE;
-- 산술 과정중 NULL 값이 존재할 경우 산술 연산한 결과값도 NULL값으로 출력

-- 오늘날짜 : SYSDATE
-- DATE형식 간 연산가능 : 결과값 일 단위
-- EMPLOYEE TABLE 사원명, 입사일, 근무일수 (오늘날짜-입사일)
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
FROM EMPLOYEE;
--값이 소수점 이하로 나오는 이유는 시,분,초 단위의 시간정보까지 관리하기 때문
-- 함수 관련 수업시 진행


------------------------<컬럼 COLUMN 명에 별칭 지정하기>--------------------------

/*
    산술 연산시 컬럼명이 산술에 들어간 수식 그대로 됨 이때 별칭을 부여하면 깔끔하게 정리
    
    [표현법]
    컬럼명 별칭 | 컬럼명 AS별칭 | 컬럼명 "별칭" | 컬럼명 AS "별칭"
    
    별칭에 띄어쓰기가 들어 있거나 특수문자가 포함되어 있으면 반드시 ("")쌍따옴표로 기술
*/

SELECT EMP_NAME 사원명, SALARY AS 급여, BONUS, SALARY*12 "연봉(원)", (SALARY+BONUS*SALARY)*12 AS "총 소득(원)"
FROM EMPLOYEE;

---------------------------------< 리터럴 >------------------------------------
/*
    임의로 지정한 문자열 (' ')
    
    SELECT 절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터 처럼 조회가능
    조회된 RESULT SET의 모든 행에 반복적으로 같이 출력
*/
--EMPLOYEE 테이블에서 사번, 사원명, 급여 조회 (급여 옆에 '원'을 붙여 출력)

SELECT EMP_ID, EMP_NAME,'귀하' AS 존칭, SALARY,'원' AS 단위
FROM EMPLOYEE;

-----------------------------< 연결 연산자 || >--------------------------------
/*
  여러 컬럼값들을 마치 하나의 컬럼인것 처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/
-- 사번, 이름, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || SALARY AS "사번+이름+급여"
FROM EMPLOYEE;

--컬럼값과 리터럴과 연결
SELECT EMP_NAME || '의 월급은 ' || SALARY || ' 원 입니다'
FROM EMPLOYEE;
/*
  연습문제
1. EMPLOYEE 테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액-{연봉*세금3%)) 조회
단, 산술연산이 들어간것은 별칭 부여

2. LOCATION 테이블에서 NATIONAL_CODE 옆에 국가 컬럼추가

3. DEPARTMENT 테이블에서 1컬럼에 '인사관리부의 위치는 L1입니다'

*/

SELECT  EMP_NAME 이름, SALARY*12 연봉, (SALARY+BONUS*SALARY)*12 AS "총수령액", ((SALARY+BONUS*SALARY)*12)-((SALARY*12)*0.03) 실수령액
FROM EMPLOYEE;

SELECT NATIONAL_CODE 국가코드, '국가' 국가
FROM LOCATION;

SELECT  DEPT_TITLE || '의 위치는 ' || LOCATION_ID || ' 입니다' AS "위치안내"
FROM DEPARTMENT;

-----------------------------< DISTINCT >--------------------------------
/*
    컬럼에 중복된 값을 한번씩만 표기하고자 할 때
*/
--EMPLOYEE 테이블에서 직급코드 조회
SELECT JOB_CODE AS "직급코드"
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 직급코드를 중복제거하여 조회
SELECT DISTINCT JOB_CODE 직급코드
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 부서코드를 중복제거하여 조회
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

-- 유의사항 : DISTINCT는 SELECT 절에 단 한번만 기술가능
-- SELECT DISTINCT DEPT_CODE, DISTINCT JOB_CODE FROM EMPLOYEE;
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

/*
    <WHERE 절>
    조회하고자 하는 테이블로 부터 특정 조건에 만족하는 데이터만 조회할 때
    이때 WHERE절에 조건식을 제시하게 됨
    조건식에는 다양한 연산자들을 사용
    
    [표현법]
    SELECT 컬럼, 컬럼, ...
    FROM 테이블명
    WHERE 조건식;
    
    -- 비교연산자
    <, >, >=, <= : 대소 비교
    =            : 같은지 비교
    !=, ^=, <>   : 같지 않은지 비교
 
*/

-- EMPLOYEE 테이블에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블에서 부서코드가 'D1'인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME 이름, DEPT_CODE 부서코드, SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE 테이블에서 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_CODE 부서코드
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D1';
--WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE 테이블에서 급여가 400만원 이상인 사원의 사원명, 부서코드, 급여조회
SELECT EMP_NAME 사원명, DEPT_CODE 부서코드, SALARY 급여
FROM EMPLOYEE
WHERE SALARY >= 4000000;

SELECT EMP_ID 사번, EMP_NAME 이름, HIRE_DATE 입사일
FROM EMPLOYEE
WHERE ENT_YN = 'N';

SELECT EMP_NAME 이름, SALARY 급여, HIRE_DATE 입사일, SALARY*12 연봉
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_NAME 이름, SALARY 급여, SALARY*12 연봉, DEPT_CODE 부서코드
FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;

SELECT EMP_ID 사번, EMP_NAME 이름, JOB_CODE 직급코드, ENT_YN 퇴사여부
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

----------------------------------------------------------------------------
/*
    <논리연산자>
    여러개의 조건을 제시하고자 할 때 사용
    
    AND (~이면서, 그리고)
    OR (~이거나, 또는)
*/

-- 부서 코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME 사원명, DEPT_CODE 부서코드, SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME 사원명, DEPT_CODE 부서코드, SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;

-- 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;


SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;
----------------------------------------------------------------------------
/*
    <BETWEEN AND>
    조건식에서 사용되는 구문 
    ~이상 ~이하 범위에 대한 조건을 제시할 때 사용되는 연산자
    
    [표현법]
    비교대상 컬럼 BETWEEN 하한값 AND 상한값
    -> 해당 컬럼값이 하한값 이상이고 상한값 이하인 경우
*/
-- 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 급여가 350만원 미만 600만원 초과인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
--WHERE SALARY < 3500000 OR SALARY > 6000000;
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
--NOT : 논리부정연산자

-- 입사일 90/01/01 ~ 01/01/01
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
--WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01';
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

----------------------------------------------------------------------------
/*
    <LIKE.
    비교하고자하는 컬럼값이나 내가 제시한 특정 패턴에 만족하는 경우 조회
    
    [표현법]
    비교대상컬럼 LIKE '특정패턴'
    : 특정패턴 제시할 때 '%', '_'를 와일드카드로 사용함 (ex) A * )
    
    >> '%' : 0글자 이상
    ex) 비교대상컬럼 LIKE '오라클%' → 비교대상의 컬럼값이 '오라클'로 시작하는것 조회
        비교대상컬럼 LIKE '%문자' → 비교대상의 컬럼값이 '문자'로 끝나는것 조회  
        비교대상컬럼 LIKE '%ORACLE%' → 비교대상의 컬럼값이 '문자'가 포함되는것 조회
        
    >> '_' : 1글자
    ex) 비교대상컬럼 LIKE '_문자' → 비교대상의 컬럼값이 '문자' 앞에 무조건 한글자인 경우 조회(ex. a문자)
        비교대상컬럼 LIKE '__문자' → 비교대상의 컬럼값이 '문자' 앞에 무조건 두글자인 경우 조회(ex. aa문자)
        비교대상컬럼 LIKE '_문자_' → 비교대상의 컬럼값이 '문자' 앞과 뒤에 무조건 한글자씩 있는 경우 조회 (ex. a문자a)
*/

-- EMPLOYEE TABLE 에서 사원들중 성이 '전'씨인 사원들의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%보';

-- EMPLOYEE TABLE 사원 이름중 '하'가 포함되어있는 사원명, 주민번호, 전화번호 조회
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- EMPLOYEE TABLE 사원 이름중 가운데 글자가 '하' 인 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
--WHERE EMP_NAME LIKE '_하%'     -- 무조건 한글자 가운데 '하' 뒤에 몇글자든 관계없음
--WHERE EMP_NAME LIKE '%하_'     -- 앞에 몇글자든 관계없음 가운데 '하' 뒤에 한글자 무조건
WHERE EMP_NAME LIKE '_하_';       -- 가운데 '하' 들어간 외자 제외

-- EMPLOYEE TABLE 전화번호중 3번째 값이 '1'인 사원의 사원명, 전화번호, 이메일 조회
-- (앞에 2글자 반드시 들어와야함, 4번째부터는 갯수와 상관없음)
SELECT EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

--주민번호 9로 시작하는 사원
SELECT EMP_NAME, PHONE, EMAIL, EMP_NO
FROM EMPLOYEE
WHERE EMP_NO LIKE '9%';

--주민번호 8로 시작하는 사원
SELECT EMP_NAME, PHONE, EMAIL, EMP_NO
FROM EMPLOYEE
WHERE EMP_NO LIKE '8%';

--EMPLOYEE 테이블에서 이메일 중 _앞에 글자가 3글자인 사원의 사번, 이름, 이메일조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '____%';

-- 와일드 카드로 사용되고 있는 문자와 컬럼값에 들어 있는 문자가 동일하기 때문에 조회안됨
-- 모두가 와일드카드로 인식
-- > 어떤 것이 와일드 카드인지, 데이터값인지 구분해줘야 함
-- > 데이터값으로 취급하고 싶은 값 앞에 나만의 와일드카드(아무거나 문자, 숫자, 특수문자)를 제시하고
--   나만의 와일드 카드를 ESCAPE로 등록함

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___$_%' ESCAPE'$';

-- 위의 사원이 아닌 그외 사람들만 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE NOT EMAIL LIKE '___$_%' ESCAPE'$';

----------------------------------실습문제---------------------------------
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

SELECT EMP_NAME, PHONE
FROM EMPLOYEE
--WHERE PHONE NOT LIKE '010%';
WHERE NOT PHONE LIKE '010%';

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%정보%';

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '%해외영업%';

-------------------------<IS NULL | IS NOT NULL>-----------------------------
-- 컬럼값이 NULL 이 있을경우 NULL값에 사용되는 연산자

-- 보너스 값이 NULL인 사원
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- 보너스 값이 NULL아닌 사원
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- 사수가 있는 사원의 사원명, 사수사번, 부서코드
SELECT EMP_NAME, MANAGER_ID,DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 사수가 없는 사원의 사원명, 사수사번, 부서코드
SELECT EMP_NAME, MANAGER_ID,DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 부서배치 받지않고, 보너스는 받는 사원의 이름 보너스 부서코드
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

----------------------------------------------------------------------------
/*
    <IN | NOT IN>
    IN : 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는것만 조회
    NOT IN : 컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지만 조회
    
    [표현법]
    비교대상컬럼 IN ('값1', '값2', '값3', ...)
    
*/

--EMPLOYEE TABLE 에서 DEPT_CODE가 'D6' 또는 'D8' 또는 'D5'인 부서원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';
WHERE DEPT_CODE IN ('D6','D8','D5');

--EMPLOYEE TABLE 에서 DEPT_CODE가 'D6' 또는 'D8' 또는 'D5'인 사원들을 제외한 사원의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D6' AND DEPT_CODE ^= 'D8' AND DEPT_CODE <> 'D5';
WHERE DEPT_CODE NOT IN ('D6','D8','D5');

----------------------------------------------------------------------------
/*
    <연산자 우선순위>
    1. ()
    2. 산술연산자
    3. 연결연산자
    4. 비교연산자
    5. IS NULL / LIKE / IN
    6. BTWEEN AND
    7. NOT(논리연산자)
    8. AND(논리연산자)
    9. OR(논리연산자)
  
*/

-- ** OR 보다 AND 가 먼저 연산됨
-- EMPLOYEE TABLE 직급코드가 J7이거나 J2인 사원중 급여가 200만원 이상인 사원들의 모든 컬럼 조회

SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J7' OR JOB_CODE = 'J2' AND SALARY >=2000000;

SELECT *
FROM EMPLOYEE
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >=2000000;

SELECT *
FROM EMPLOYEE
WHERE JOB_CODE IN ('J7','J2') AND SALARY >= 2000000;


---------------------------------실습문제--------------------------------
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

SELECT EMP_ID, EMP_NAME, SALARY*12, BONUS
FROM EMPLOYEE
WHERE  ((SALARY*12) >= 30000000) AND BONUS IS NULL;

SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NOT NULL ;

SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000 AND HIRE_DATE >='01/01/01' AND BONUS IS NULL;

SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12+BONUS*(SALARY*12) AS "보너스 포함된 연봉"
FROM EMPLOYEE
WHERE SALARY+SALARY*BONUS IS NOT NULL AND EMP_NAME LIKE '%하%';

-----------------------------------------------------------------------------
/*
    <ORDER BY>
    SELECT 문 가장 마지막 줄에 작성 뿐만 아니라 실행 순서 또한 마지막에 실행
    
    [표현법]
    SELECT 조회할 컬럼1, 컬럼1, ..
    FROM 테이블명
    WHERE 조건식
    ORDER BY 정렬기준 컬럼명 | 별칭 | 컬럼순번 [ASC|DESC] [NULLS FIRST | NULLS LAST]
    
    - ASC : 오름차순 정렬 (생략시 기본값)
    - DESC : 내림차순 정렬
    
    - NULLS FIRST : 정렬하고자 하는 컬럼값에 NULL이 있으면 해당 데이터를 맨 앞에 배치 (DESC 일때의 기본값)
    - NULLS LAST : 정렬하고자 하는 컬럼값에 NULL이 있으면 해당 데이터를 맨 뒤에 배치 (ASC 일때의 기본값)
*/

SELECT *
FROM EMPLOYEE
ORDER BY BONUS;                  -- 생략시 오름차순정렬

SELECT *
FROM EMPLOYEE
ORDER BY BONUS ASC;              -- 오름차순정렬 NULL값이 LAST

SELECT *
FROM EMPLOYEE
--ORDER BY BONUS;                -- 오름차순정렬 NULL값이 LAST
--ORDER BY BONUS DESC;           -- 내림차순정렬 NULL값이 FIRST
ORDER BY BONUS DESC NULLS LAST;  

-- 정렬기준이 여러개 일 때
-- 보너스 기준으로 내림차순 정렬, 보너스가 같으면 급여 오름차순 정렬
SELECT *
FROM EMPLOYEE
ORDER BY BONUS DESC, SALARY ASC;
                   --SALARY; ASC 생략가능
                   
                   
-- 전사원의 연봉별 내림차순 정렬
--SELECT EMP_NAME, (SALARY+SALARY*BONUS)*12 보너스포함연봉
--SELECT EMP_NAME, SALARY+(1*BONUS))*12 보너스포함연봉
--SELECT EMP_NAME, (SALARY+SALARY*BONUS)*12 보너스포함연봉
SELECT EMP_NAME, SALARY*12+(SALARY*12)*BONUS 보너스포함연봉
FROM EMPLOYEE
ORDER BY 보너스포함연봉 DESC NULLS LAST;


















