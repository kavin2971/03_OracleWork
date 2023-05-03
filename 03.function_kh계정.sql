/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    - 단일행 함수 : N개의 값을 읽어들여 N개의 결과값을 반환 (매 행마다 함수실행)
    - 그룹 함수 : N개의 값을 읽어들여 1개의 결과값 반환 (그룹별로 함수 실행)
    
    >> SELECT 절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HEVING절    
*/

-----------------------------------------------------------------------------
--===========================================================================
--                           <문자 처리 함수>
--===========================================================================
/*
    * LENGTH / LENGTHB / 
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수 반환 (반환형 : NUMBER)
    LENGTHB(컬럼|'문자열') : 해당 문자열의 BYTE수 반환 (반환형 : NUMBER)
      - 한글 : XE버젼일 때 → 1글자당 3BYTE( ㄱ, ㅏ, 정 등 1글자로 인식 )
               EE버젼일 때 → 1글자당 2BYTE
      - 그외 : 1글자당 1BYTE         
*/

SELECT LENGTH ('오라클') 글자수, LENGTHB('오라클') BYTE수
FROM DUAL; -- 오라클에서 제공하는 가상테이블

SELECT LENGTH ('ㅋㅋ') 글자수, LENGTHB('ㅋㅋ') BYTE수
FROM DUAL;

SELECT LENGTH ('Oracle') 글자수, LENGTHB('Oracle') BYTE수
FROM DUAL;

SELECT EMP_NAME 이름, LENGTH(EMP_NAME) 이름글자수,LENGTHB(EMP_NAME) 이름바이트수, 
EMAIL 이메일, LENGTH(EMAIL)이메일글자수,LENGTHB(EMAIL)이메일바이트수
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정 문자의 시작위치 (INDEX)를 찾아서 반환(반환형 : NUMBER)
    - *** ORACLE에서 INDEX는 1부터 시작. 찾을 문자가 없을 때 0 반환
    
    INSTR(컬럼|'문자열', '찾고자하는문자',[찾을위치의 시작값, [순번]])
    - 찾을 위치의 시작값
        1 : 앞에서 부터 찾기 (기본값)
       -1 : 뒤에서 부터 찾기 
   
*/
SELECT INSTR('JAVASCRIPTJAVAORACLE','A') FROM DUAL;      -- 결과 : 2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1) FROM DUAL;    -- 결과 : 2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1) FROM DUAL;   -- 결과 : 17

SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1,3) FROM DUAL;  -- 결과 : 12
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1,2) FROM DUAL; -- 결과 : 14

--EMPLOYEE 테이블에서 EMAIL _의 인덱스값, '@'의 인덱스값
SELECT EMAIL "E-MAIL ADDRESS", INSTR(EMAIL,'_',1,1) "_ INDEX POSITION",INSTR(EMAIL,'@',1) "@ INDEX POSITION" FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
  * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환 (반환형 : CHARACTER)

  SUBSTR(컬럼|'문자열', POSITION, [LENGTH])  
  - POSITION : 문자열을 추출할 시작위치 INDEX
  - LENGTH : 추출할 문자 갯수 (생략시 마지막까지 추출)
*/
SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;  -- 결과 : HTMLCSS
SELECT SUBSTR('ORACLEHTMLCSS', 7,4) FROM DUAL; -- 결과 : HTML
SELECT SUBSTR('ORACLEHTMLCSS', 1,6) FROM DUAL; -- 결과 : ORACLE
SELECT SUBSTR('ORACLEHTMLCSSRE', -9,4) FROM DUAL; -- 결과 : HTML

-- EMPLOYEE 테이블 주민번호에서 성별만 추출하여 주민번호, 사원명, 성별을 조회
SELECT EMP_NO, EMP_NAME, SUBSTR(EMP_NO,-7,1)"성별 남자1 여자2"
FROM EMPLOYEE;
SELECT EMP_NO, EMP_NAME, SUBSTR(EMP_NO,8,1)"성별 남자1 여자2"
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 여자사원들만 사원번호, 사원명, 성별을 조회
SELECT EMP_NO, EMP_NAME, SUBSTR(EMP_NO,8,1)"남자1 여자2"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = '2';

-- EMPLOYEE 테이블에서 아이디 (EMAIL에서 @ 앞의 문자)만 추출하여 사원명, 이메일, 아이디 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) 아이디
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때 사용(반환형 : CHARACTER)
    
    LPAD / RPAD ('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
    문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열 반환

    System.out.printf("%5d", 312)
    00312

*/

-- 20만큼의 길이 중 EMAIL컬럼값을 오른쪽으로 정렬하고 나머지 부분은 공백으로 채워(왼쪽)
SELECT EMP_NAME, LPAD(EMAIL,20) "E-MAIL" --덧붙이고자하는 문자 생략시 기본값 공백
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL,20,'#') "E-MAIL"
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL,20,'#') "E-MAIL"
FROM EMPLOYEE;

-- 주민번호 971125-1****** 조회
SELECT EMP_NAME, SUBSTR(EMP_NO,1,8)
FROM EMPLOYEE;

SELECT EMP_NAME "이름", RPAD(SUBSTR(EMP_NO,1,8), 14, '*') 주민등록번호
FROM EMPLOYEE;

SELECT EMP_NAME "이름", SUBSTR(EMP_NO,1,8) || '******'  주민등록번호
FROM EMPLOYEE;

--------------------------------------------------------------------------
/*
    LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 나머지 반환 (반환형 : CHARACTER)
    * TRIM : 문자열의 앞/뒤 양쪽에 있는 지정한 문자들을 제거한 나머지 문자열 반환
    
    [표현법]
    LTRIM / RTRIM ('문자열', [제거하고자하는 문자열])
    TRIM([LEADING|TRAILING|BOTH]제거하고자 하는 문자열 FROM '문자열')
    - BOTH : 양쪽제거 (기본값) 생략가능
    - LEADING : 앞쪽(왼쪽) 제거 = LTRIM
    - TRAILING : 뒤쪽(오른쪽) 제거 = RTRIM
    
    문자열의 왼쪽/오른쪽 제거하고자하는 문자들을 제거한 나머지 문자열 반환
    
    명시한 문자외에 문자가 나오면 이후는 실행하지않음
*/

SELECT LTRIM('     K H     ') || '정보교육원' "왼쪽 공백제거" FROM DUAL;
SELECT RTRIM('     K H     ') || '정보교육원' "오른쪽 공백제거" FROM DUAL;

SELECT LTRIM('JAVAJAVASCRIPTJSP','JAVA') "왼쪽부터 JAVA 문자제거"  FROM DUAL;
SELECT LTRIM('BACAABCFDSCA','ABC') "왼쪽부터 ABC 문자제거"  FROM DUAL;
SELECT LTRIM('3829DKDIS213','0123456789') "왼쪽부터 0123456789 제거" FROM DUAL;

SELECT RTRIM('JAVAJAVASCRIPTAVJJAVAAAAAA','JAVA') "오른쪽부터 JAVA 문자제거"  FROM DUAL;
SELECT RTRIM('BACAABCFDSCA','ABC') "오른쪽부터 ABC 문자제거"  FROM DUAL;
SELECT RTRIM('3829DKDIS213','0123456789') "오른쪽부터 0123456789 제거" FROM DUAL;

SELECT TRIM('     K H     ') || '정보교육원' "TRIM은 양쪽 공백제거" FROM DUAL;

SELECT TRIM('A' FROM 'AAAJAVASCRIPTAAA')FROM DUAL; --기본값이 (BOTH)양쪽제거

SELECT TRIM(BOTH 'A' FROM 'AAAJAVASCRIPTAAA')"양쪽제거 BOTH 생략가능"FROM DUAL;
SELECT TRIM(LEADING 'A' FROM 'AAAJAVASCRIPTAAA') "왼쪽만제거 LTRIM과 동일" FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAAJAVASCRIPTAAA') "오른쪽만제거 RTRIM과 동일" FROM DUAL;

-----------------------------------------------------------------------------
/*
  * LOWER / UPPER / INITCAP : 영문자를 모두 소/대문자로 변환 및 단어의 앞글자만 대문자로 반환
  
  [표현법]
  LOWER / UPPER / INITCAP ('문자열')
*/

SELECT LOWER('JAVA JAVASCRIPT ORACLE') FROM DUAL;
SELECT UPPER('JAVA javascript ORACLE') FROM DUAL;
SELECT INITCAP('JAVA JAVASCRIPT ORACLE') FROM DUAL;

-----------------------------------------------------------------------------
/*
  * CONCAT : 문자열 두개를 전달받아 하나로 합친 결과 반환
  
  [표현법]
   CONCAT ('문자열', '문자열')
*/

SELECT CONCAT('Oracle', '오라클') FROM DUAL;
SELECT 'Oracle' || '오라클' FROM DUAL;
SELECT CONCAT('Oracle', '오라클', '02-1234-5678') FROM DUAL; -- 2개만 가능

SELECT 'Oracle' || '오라클' || '02-1234-5678' FROM DUAL; -- 갯수 상관없음

-----------------------------------------------------------------------------

/*
    *REPLACE : 기존문자열을 새로운 문자열로 바꿈
    [표현법]
    REPLACE ('문자열', '기존문자열', '바꿀문자열')
*/

SELECT REPLACE(EMAIL, 'kh.or.kr', 'google.com') 메일주소
FROM EMPLOYEE;

--===========================================================================
--                           <숫자 처리 함수>
--===========================================================================

/*
    * ABS : 숫자의 절대값을 구해주는 함수
    
    [표현법]
    ABS(NUMBER)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

--------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지 값을 반환하는 함수
    
    [표현법]
    MOD(NUMBER, NUMBER)
*/
SELECT MOD(10,3) FROM DUAL;
SELECT MOD(10.9, 2) FROM DUAL; -- 잘쓰지 않음

--------------------------------------------------------------------------
/*
    * ROUND : 반올림한 결과를 반환하는 함수
    
    [표현법]
    ROUND(NUMBER, [위치])
*/
 SELECT ROUND(1234.567) "정수로 올림한 결과를 반환하는 함수"FROM DUAL;  -- 위치 생략시 0
 SELECT ROUND(12.34) FROM DUAL;
 SELECT ROUND(1234.5678, 2) FROM DUAL;
 SELECT ROUND(1234.5678, -2) FROM DUAL;

--------------------------------------------------------------------------
/*
    * CEIL : 정수로 올림한 결과를 반환하는 함수
    "무조건 올림"
    [표현법]
    CEIL(NUMBER)
*/
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(-123.456) FROM DUAL;

--------------------------------------------------------------------------
/*
    * FLOOR : 정수로 내림한 결과를 반환하는 함수
    "무조건 내림"
    [표현법]
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.956)"정수로 내림한 결과를 반환하는 함수" FROM DUAL;
SELECT FLOOR(-123.956)"정수로 내림한 결과를 반환하는 함수" FROM DUAL;

--------------------------------------------------------------------------
/*
    * TRUNC : 위치지정 가능한 버림 처리하는 함수
    
    [표현법]
    TRUNC(NUMBER, [위치]) 지정해준 위치를 제외한 버림
    
*/
SELECT TRUNC(123.789) FROM DUAL;  -- 위치 생략시 0
SELECT TRUNC(123.789, 1) FROM DUAL;
SELECT TRUNC(123.789, -1) FROM DUAL;

SELECT TRUNC(-123.857) FROM DUAL;
SELECT TRUNC(-123.857,-2) FROM DUAL;

--===========================================================================
--                           <날짜 처리 함수>
--===========================================================================
/*
    * SYSDATE : 시스템의 날짜 및 시간 반환
*/

SELECT SYSDATE FROM DUAL;

-----------------------------------------------------------------------------
/*
    * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수를 반환
*/
SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) "근무일수"
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) "근무개월수"
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수"
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'개월차' AS "근무개월수"
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') AS "근무개월차수"
FROM EMPLOYEE
ORDER BY 근무개월차수;

-----------------------------------------------------------------------------
/*
    * ADD_MONTHS(DATE1, NUMBER) : 특정 날짜에 해당 숫자 만큼의 개월수를 더해 날짜를 반환
*/
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;

--EMPLOYEE  사원명, 입사일, 정직원된 날짜 (입사후 6개월후) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) AS "정직원이된날짜" FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * NEXT_DAY(DATE, 요일(문자, 숫자)) : 특정 날짜 이후에 가까운 해당 요일의 날짜 반환해주는 함수
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '화') FROM DUAL;
-- 1: 일요일
-- 2: 월요일 ...
SELECT SYSDATE, NEXT_DAY(SYSDATE, '화요일') FROM DUAL; -- 값 = 23/04/11
SELECT SYSDATE, NEXT_DAY(SYSDATE, 3) FROM DUAL; -- 값 = 23/04/11

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 오류발생. 원인: 현재 언어 KOREAN 

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN; -- 언어를 영어로 변경
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 출력가능
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL; -- 오류발생. 원인: 현재 언어 AMERICAN

ALTER SESSION SET NLS_LANGUAGE = KOREAN; -- 언어를 한글로 변경

-----------------------------------------------------------------------------
/*
    * LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환해주는 함수
*/

SELECT LAST_DAY(SYSDATE) "이번달의마지막일은" FROM DUAL;

SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) AS "입사한달의 마지막날짜"
FROM EMPLOYEE;

SELECT EMP_NAME 사원명, HIRE_DATE 입사일,LAST_DAY(HIRE_DATE) AS "입사한달의 마지막날짜", LAST_DAY(HIRE_DATE)-HIRE_DATE+1 AS "입사한달의 근무일수"
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * EXTRACT : 특정 날짜로 부터 년도 | 월 | 일 값을 추출하여 반환해주는 함수 (반환형 : NUMBER)
    * EXTRACT (YEAR FROM DATE) : 년도만 추출
    * EXTRACT (MONTH FROM DATE) : 월만 츄츌
    * EXTRACT (DAY FROM DATE) : 일만 추출
*/

SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE) "입사년도",  EXTRACT(MONTH FROM HIRE_DATE) "입사월", EXTRACT(DAY FROM HIRE_DATE) "입사일"
FROM EMPLOYEE
ORDER BY 입사년도, 입사월, 입사일;

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--===========================================================================
--                           <형변환 함수>
--===========================================================================
/*
    * TO_CHAR : 숫자 또는 날짜 타입의 값을 문자타입으로 변환시켜주는 함수
                반환 결과를 특정 형식에 맞게 출력할 수 도있음     
                
    [표현법]
    TO_CHAR(숫자|날짜, [포멧])
*/

------------------------------ 숫자타입 → 문자타입 -----------------------------
/*
    9 : 해당 자리의 숫자를 의미한다.
     - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표기
     
    0 : 해당 자리의 숫자를 의미한다
     - 값이 없을 경우 0으로 표시하며 숫자의 길이를 고정적으로 표시할 때 주로 사용
     
    L : 현재 설정된 나라(LOCAL)의 화폐단위
    
    FM : 좌우 9로 치환된 소수점 이상의 공백 및 소수점 이하의 0을 제거
        해당자리에 값이 없을 경우 자리 차지하지 않음
*/

SELECT TO_CHAR(1234) FROM DUAL;                          -- ↓ 여기서 99는 공백2개로 반환
SELECT TO_CHAR(1234), TO_CHAR(1234, '999999') FROM DUAL; -- 991234

SELECT TO_CHAR(1234, '000000') FROM DUAL; -- 반환값 :001234

                  -- ↓ LOCAL 원(￦) 표시 (언어: KOREAN)
SELECT TO_CHAR(1234,'L999999') FROM DUAL; -- 반환값 : ￦1234 
SELECT TO_CHAR(1234,'$999999') FROM DUAL; -- 반환값 : $1234

SELECT TO_CHAR(1234,'L99,999') FROM DUAL; -- 반환값 : ￦1,234

SELECT EMP_NAME 사원명, TO_CHAR(SALARY, 'L99,999,999') 급여, TO_CHAR(SALARY*12, 'L999,999,999') 연봉
FROM EMPLOYEE;

SELECT TO_CHAR(123.456, 'FM999990.999') 값1 -- 결과값 : 123.456
      ,TO_CHAR(1234.56, 'FM9990.9') 값2     -- 결과값 : 1234.6
      ,TO_CHAR(0.1000,'FM9990.999') 값3     -- 결과값 : 0.1
      ,TO_CHAR(0.1000,'FM9999.999') 값4     -- 결과값 :  .1
      ,TO_CHAR(123,'FM9999.009') 값5        -- 결과값 : 123.00
      ,TO_CHAR(123,'9999.009') 값6          -- 결과값 : 123.000
FROM DUAL;

------------------------------ 날짜타입 → 문자타입 -----------------------------
-- 시간
SELECT TO_CHAR(SYSDATE, 'AM') KOREA 
      ,TO_CHAR(SYSDATE, 'PM','NLS_DATE_LANGUAGE=AMERICAN') AMERICA
FROM DUAL;
-- AM, PM 무엇을 쓰든 상관없음
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') 현재시간 FROM DUAL; -- 12시간 형식
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') 현재시간 FROM DUAL; -- 24시간 형식

-- 날짜
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL; -- 2023-04-07 금요일 금
SELECT TO_CHAR(SYSDATE, 'MON, YYYY')||'년' FROM DUAL; -- 4월, 2023년
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" DAY') FROM DUAL; --2023년 04월 07일 금요일
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL; -- 2023년 4월 7일 금요일

SELECT EMP_NAME 사원명,TO_CHAR(HIRE_DATE,'YY-MM-DD')입사일자 FROM EMPLOYEE;
SELECT EMP_NAME 사원명,TO_CHAR(HIRE_DATE,'DL')입사일자 FROM EMPLOYEE;
SELECT EMP_NAME 사원명,TO_CHAR(HIRE_DATE,'YYYY"년"MM"월"DD"일"')입사일자 FROM EMPLOYEE;

-- 년도
SELECT TO_CHAR(SYSDATE,'YYYY') 년도  -- 2023
      ,TO_CHAR(SYSDATE,'YY')   년도  -- 23
      ,TO_CHAR(SYSDATE,'RRRR') 년도  -- 2023
      ,TO_CHAR(SYSDATE,'RR')   년도  -- 23
      ,TO_CHAR(SYSDATE,'YEAR') 년도  -- TWENTY TWENTY-THREE
FROM DUAL;  

-- 월
SELECT TO_CHAR(SYSDATE,'MM')   월  -- 04
      ,TO_CHAR(SYSDATE,'MON')  월  -- 4월
      ,TO_CHAR(SYSDATE,'MONTH')월  -- 4월
      ,TO_CHAR(SYSDATE,'RM')   월  -- IV (로마자)
FROM DUAL; 

-- 일
SELECT TO_CHAR(SYSDATE,'DDD') 일   -- 097 (365일기준) 년기준
      ,TO_CHAR(SYSDATE,'DD')  일   -- 07 (30일기준) 월기준
      ,TO_CHAR(SYSDATE,'D')   일   -- 6 (주기준(일요일) 몇일째
FROM DUAL; 

--요일
SELECT TO_CHAR(SYSDATE,'DAY') 요일  -- 금요일
      ,TO_CHAR(SYSDATE,'DY')  요일  -- 금
FROM DUAL;

-------------------------숫자,문자타입 → 날짜타입 -----------------------------
/*
    TO_DATE : 숫자 또는 문자 타입을 날짜타입으로 변환
    TO_DATE(숫자|문자, [포멧])
*/

SELECT TO_DATE(20230407) FROM DUAL; -- 20/04/07
SELECT TO_DATE(230407) FROM DUAL;   -- 20/04/07
SELECT TO_DATE(010223) FROM DUAL;   -- ERROR 원인 : 첫글자 0일경우
SELECT TO_DATE('010223') FROM DUAL; -- 01/02/23 첫글자가 0일경우에는 문자타입으로 변경

SELECT TO_DATE('070407140830', 'YYMMDDHHMISS') -- 04/07/14
FROM DUAL;
-------------------------------------------------------------------------------
--SELECT TO_CHAR(TO_DATE('070407140830', 'YYMMDDHHMISS'), 'YY/MM/DD HH24:MI:SS')
--FROM DUAL;    버젼이 바뀌면서 잘못된 출력, 다음에 다시 설명!
-------------------------------------------------------------------------------

SELECT TO_DATE('040630', 'YYMMDD') FROM DUAL;  -- 2004/06/30
SELECT TO_DATE('040630', 'RRMMDD') FROM DUAL;  -- 2004/06/30

SELECT TO_DATE('980630', 'YYMMDD') FROM DUAL;  -- 2098/06/30 YY : 무조건 현재 세기로 반영
SELECT TO_DATE('980630', 'RRMMDD') FROM DUAL;  -- 1998/06/30 RR : 해당 두자리가 50미만이면 현재세기, 50이상이면 이전세기

----------------------------- 문자타입 → 숫자타입 -------------------------------
/*
    * TO_NUMBER : 문자 타입을 숫자타입으로 변환
    TO_NUMBER(문자, [포멧])
*/
SELECT TO_NUMBER('01234567') FROM DUAL;  -- 1234567
SELECT '1000' + '5000' FROM DUAL;   -- 6000 연산결과 출력
SELECT '1,000' + '5,000' FROM DUAL;  -- ERROR 원인 : , 로 인해 자동형변환 불가
SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('550,000', '999,999') "백만-오십오만 연산결과" FROM DUAL; -- 1550000

-----------------------------------------------------------------------------
--===========================================================================
--                           <NULL처리 함수>
--===========================================================================
/*
    * NVL(컬럼, 해당컬럼값이 NULL일때 변환할 값)
*/
SELECT EMP_NAME, NVL(BONUS,0)
FROM EMPLOYEE;

-- 전사원의 이름 보너스포함 연봉(NULL 을 0으로 변경) 조회
SELECT EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 연봉
FROM EMPLOYEE;

-- 전사원의 이름 매니져ID 출력 NULL인경우 사수없음 으로 출력 조회
SELECT EMP_NAME, NVL(MANAGER_ID,'사수없음')
FROM EMPLOYEE;

-- 전사원의 이름 부서 출력 NULL인경우 부서없음 으로 출력 조회
SELECT EMP_NAME, NVL(DEPT_CODE,'부서없음')
FROM EMPLOYEE;

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

/*
    *NVL2(컬럼, 반환값1, 반환값2)
    - 컬럼값이 존재하면 반환값1
    - 컬럼값이 NULL이면 반환값2
*/

SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7,0.2)
FROM EMPLOYEE;

SELECT EMP_NAME, BONUS, NVL2(BONUS, BONUS+0.3, 0.2)
FROM EMPLOYEE;

SELECT EMP_NAME, NVL2(DEPT_CODE, '부서있음 O', '부서없음 X')
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * NULLIF(비교대상1, 비교대상2)
    - 두개의 값이 일치하면 NULL 반환
    - 두개의 값이 일치하지 않으면 비교대상1 값을 반환
*/
SELECT NULLIF('123', '123') FROM DUAL;

SELECT NVL2(NULLIF('123', '123'),'값이다르다','값이같다') "값이같은가?"
FROM DUAL;

--===========================================================================
--                           <선택 함수>
--===========================================================================
/* SWITCH CASE 문과 유사
    * DECODE( 비교하고자하는대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2, ...)
    
*/

SELECT EMP_ID 사번, 
EMP_NAME 이름, 
SUBSTR(EMP_NO,1,8) || '******' 주민등록번호, 
DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여','3','남','4','여')성별
FROM EMPLOYEE;

SELECT EMP_NAME 사원명, SALARY 급여, 
DECODE((JOB_CODE),'J7', SALARY*1.1
                 ,'J6', SALARY*1.15
                 ,'J5', SALARY*1.2
                 ,      SALARY*1.05) "인상된 급여"
FROM EMPLOYEE;


-----------------------------------------------------------------------------
/* IF문과 유사
        CASE WHEN THEM
        END
        
        CASE WHEN 조건식1 THEN 결과값1
             WHEN 조건식2 THEN 결과값2
             ...
             ELSE 결과값N
        END        
*/
SELECT EMP_NAME, SALARY, 
        CASE WHEN SALARY>=5000000 THEN '고급'
             WHEN SALARY>=3500000 THEN '중급'
             ELSE '초급'
        END AS "등급"
FROM EMPLOYEE;

--===========================================================================
--                            <그룹 함수>
--===========================================================================
/*
    SUM(숫자타입컬럼) : 해당 컬럼 값들의 총 합계를 구해서 반환해주는 함수
*/
-- 전 사원의 총급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE
-- WHERE SUBSTR(EMP_NO,8,1) = '1' OR SUBSTR(EMP_NO,8,1) = '3'  ;
WHERE SUBSTR(EMP_NO,8,1) IN ('1','3');

SELECT SUM(SALARY*12) AS "D5연봉합산"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

SELECT SUM(SALARY+SALARY*NVL(BONUS,0))*12 AS "D5연봉(보너스포함)합산"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-----------------------------------------------------------------------------
/*
  * AVG(숫자타입컬럼) : 해당 컬럼값의 평균값을 반환해주는 함수
*/
-- 전사원급여의 평균
SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1)IN ('2', '4');
-----------------------------------------------------------------------------
/*
  * MIN(모든컬럼) : 해당 컬럼 값들중 가장 작은 값 반환
  * MAX(모든컬럼) : 해당 컬럼 값들중 가장 큰 값 반환
*/
SELECT MIN(SALARY) FROM EMPLOYEE;
SELECT MIN(EMP_NAME) FROM EMPLOYEE;
SELECT MIN(HIRE_DATE) FROM EMPLOYEE;

SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;

SELECT MAX(SALARY) FROM EMPLOYEE;
SELECT MAX(EMP_NAME) FROM EMPLOYEE;
SELECT MAX(HIRE_DATE) FROM EMPLOYEE;

SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    *COUNT(*|컬럼|DISTINCT컬럼) : 행의 갯수 반환
    
    COUNT(*) : 조회된 결과의 모든 행의 갯수
    COUNT(컬럼) : 제시한 컬럼값의 NULL 값을 제외한 행의 갯수
    COUNT(DISTINCT컬럼) : 해당 컬럼값 중복을 제거한 후의 행의 갯수
    
*/
-- 전체 사원의 수
SELECT COUNT (*)
FROM EMPLOYEE;

SELECT COUNT (*)
FROM EMPLOYEE;
--WHERE SUBSTR(EMP_NO,8,1)='2' OR SUBSTR(EMP_NO,8,1)='4';
WHERE SUBSTR(EMP_NO,8,1) IN ('2','4');

SELECT COUNT(BONUS) -- NULL 값제외한 행의갯수
FROM EMPLOYEE;

SELECT COUNT(DEPT_CODE) -- NULL 값제외한 행의갯수
FROM EMPLOYEE;

SELECT COUNT(DISTINCT DEPT_CODE) -- 중복제외 DISTINCT
FROM EMPLOYEE;














