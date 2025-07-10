create or replace TRIGGER trg_after_book_borrow_insert
-- AFTER 에서 BEFORE로 바뀜
-- 중복 대출 체크(조회)를 위해 before로 수정
BEFORE INSERT ON BOOK_BORROW
FOR EACH ROW
DECLARE
v_bookcount     NUMBER;
v_usercanborrow NUMBER;
v_count    NUMBER;
v_booktitle     varchar2(400);
v_bookwrite     varchar2(100);
v_bookmajor     varchar2(100);
v_booksub       varchar2(100);
ex_no_stock     EXCEPTION;
ex_no_quota     EXCEPTION;
ex_already_borrowed EXCEPTION;
BEGIN
-- 책 재고, 제목, 저자 확인
SELECT BOOKCOUNT, booktitle, bookwrite, bookmajorcategory, booksubcategory
INTO v_bookcount, v_booktitle, v_bookwrite, v_bookmajor, v_booksub
FROM BOOKINFO
WHERE BOOKNUMBER = :NEW.BOOKNUMBER;

:NEW.booktitle := v_booktitle;
:NEW.bookwrite := v_bookwrite;
:NEW.bookReturnDate := SYSDATE + 30;
:new.bookmajorcategory := v_bookmajor;
:new.booksubcategory := v_booksub;

-- 사용자 대출 가능 횟수 확인
SELECT USERCANBORROW INTO v_usercanborrow
FROM USERINFO
WHERE USERNUMBER = :NEW.USERNUMBER;

-- 중복 대출 체크
SELECT COUNT(*) INTO v_count
FROM BOOK_BORROW
WHERE USERNUMBER = :NEW.USERNUMBER
 AND BOOKNUMBER = :NEW.BOOKNUMBER;

IF v_count > 0 THEN
RAISE ex_already_borrowed;
END IF;

-- 예외 조건 검사
IF v_bookcount <= 0 THEN
    RAISE ex_no_stock;
ELSIF v_usercanborrow <= 0 THEN
    RAISE ex_no_quota;
END IF;

-- BOOKINFO 업데이트
UPDATE BOOKINFO
SET
    BOOKBORROWCOUNT = BOOKBORROWCOUNT + 1,
    BOOKCOUNT = BOOKCOUNT - 1
WHERE BOOKNUMBER = :NEW.BOOKNUMBER;

-- USERINFO 업데이트
UPDATE USERINFO
SET
    USERCANBORROW = USERCANBORROW - 1,
    USERBORROW = USERBORROW + 1
WHERE USERNUMBER = :NEW.USERNUMBER;

EXCEPTION
WHEN ex_no_stock THEN
RAISE_APPLICATION_ERROR(-20001, '도서 재고가 부족하여 대출할 수 없습니다.');
WHEN ex_no_quota THEN
RAISE_APPLICATION_ERROR(-20002, '회원의 대출 가능 권수가 0입니다.');
WHEN ex_already_borrowed THEN
RAISE_APPLICATION_ERROR(-20004, '이미 빌린 책 입니다');
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20003, '트리거 처리 중 오류 발생: ' || SQLERRM);
END;