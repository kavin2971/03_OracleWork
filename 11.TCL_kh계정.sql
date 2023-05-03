/*
    <TCL : TRANSACTION CONTROL LANGUAGE>
    트랜잭션 제어 언어
    
    * 트랜잭션(TRANSACTION)
    - 데이터베이스의 논리적 연산단위
    - 데이터의 변경사항 (DML)들을 하나의 트랜잭션에 묶어서 처리
      DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                           트랜잭션이 존재하지않으면 트랜잭션을 만들어서 묶음                           
      COMMIT 하기 전까지의 변경사항들을 하나의 트랜잭션에 담게됨
    - 트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE(DML)
       
    COMMIT (트랜잭션 종료 처리 후 확정)
    ROLLBACK (트랜잭션 취소)
    SAVEPOINT (임시저장)
    
    - COMMIT; -> 진행:한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미(후에 트랜잭션이 사라짐)     
   
    - ROLLBACK; -> 진행:한 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 COMMIT 시점으로 돌아감
    - SAVEPOINT 포인트명; -> 진행: 현재 이 시점에 해당 포인트명으로 임시저장점을 정의해 두는것
*/
--==============================
--==============================
/*                              
    - 데이터 값 변경시            
      INSERT, UPDATE, DELETE    
                                
    - 테이블을 변경시             
      ADD, ALTER, DROP          
*/                              
--==============================
--==============================
-- EMPLOYEE_COPY3 테이블에서 사번 201번 지우기
DELETE FROM EMPLOYEE_COPY3
      WHERE EMP_ID = 201;

-- EMPLOYEE_COPY3 테이블에서 사번 202번 지우기      
DELETE FROM EMPLOYEE_COPY3
      WHERE EMP_ID = 202;      

ROLLBACK;       -- 201번과 202번 되살아남

------------------------------------------------------------------------------

-- EMPLOYEE_COPY3 테이블에서 사번 200번 지우기
DELETE FROM EMPLOYEE_COPY3
      WHERE EMP_ID = 200;
      
SELECT * FROM EMPLOYEE_COPY3;

-- EMPLOYEE_COPY3 테이블에서 사번 300번 추가
INSERT INTO EMPLOYEE_COPY3 VALUES(300, '홍길동',5000000,60000000); 

COMMIT;

ROLLBACK;  -- COMMIT한 후 부터 되살릴 수 있음. 현재는 되살릴것이 없음

------------------------------------------------------------------------------
-- 208, 217, 221 삭제
DELETE FROM EMPLOYEE_COPY3
      WHERE EMP_ID IN (208, 217, 221);

--임시저장 지점 만들기
SAVEPOINT SP;

-- 301번 삽입
INSERT INTO EMPLOYEE_COPY3 
        VALUES(301, '아무개',4000000,48000000); 

-- 세이브지점까지 롤백        
ROLLBACK TO SP; 

COMMIT; 

------------------------------------------------------------------------------
/*
    * 자동 COMMIT 되는 경우
    - 정상 종료
    - DCL과 DDL 명령문이 수행된 경우
    
    *자동 ROLLBACK 되는 경우
    - 비정상 종료된 경우
    - 전원이 꺼짐. 정전. 컴퓨터 DOWN
*/

DELETE FROM EMPLOYEE_COPY3
      WHERE EMP_ID = 204;

INSERT INTO EMPLOYEE_COPY3
     VALUES (302, 'KH', 3000000, 36000000);

CREATE TABLE TEST(
     TID NUMBER
 );  -- DDL 구문을 실행하는 순간 COMMIT이 됨
     
ROLLBACK;
