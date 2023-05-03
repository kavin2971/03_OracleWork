-- 3번 권한 부여 후
CREATE TABLE TEST(
    TEST_ID NUMBER,
    TEST_NAME VARCHAR2(20)
);

-- 4번 권한 부여 후
INSERT INTO TEST VALUES(1,'아무개');

-- 5번 권한 부여 후
SELECT *
FROM KH.EMPLOYEE;

-- 6번 권한 부여 후
INSERT INTO KH.DEPARTMENT
        VALUES('D0','설계부','L1');