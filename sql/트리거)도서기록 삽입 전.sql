create or replace TRIGGER before_book_record_insert
BEFORE INSERT ON book_record
FOR EACH ROW
DECLARE
v_borrowDate DATE;
v_borrowNumber NUMBER;
v_booktitle varchar2(400);
v_bookwrite varchar2(100);
v_bookmajor varchar2(100);
v_booksub   varchar2(100);
v_recordNumber number;
v_returnDate date default SYSDATE;
ex_no_borrow EXCEPTION;
BEGIN
-- 해당 대출 정보 유무 확인
SELECT borrowNumber, bookBorrowDate
INTO v_borrowNumber, v_borrowDate
FROM book_borrow
WHERE bookNumber = :NEW.bookNumber
AND userNumber = :NEW.userNumber;

select booktitle, bookwrite, bookmajorcategory, booksubcategory
into v_booktitle, v_bookwrite, v_bookmajor, v_booksub
from bookinfo
where bookNumber = :NEW.bookNumber;

 -- 새로운 borrowRecordNumber 미리 생성
SELECT NVL(MAX(recordNumber), 0) + 1
INTO v_recordNumber
FROM book_record;

:NEW.bookBorrowDate := v_borrowDate;
:NEW.bookReturnDate := v_returnDate;
:NEW.booktitle := v_booktitle;
:NEW.bookwrite := v_bookwrite;
:new.bookmajorcategory := v_bookmajor;
:new.booksubcategory := v_booksub;

-- 그 다음 BOOK_BORROW에서 삭제
DELETE FROM book_borrow
WHERE bookNumber = :NEW.bookNumber
  AND userNumber = :NEW.userNumber;
  
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR(-20004, '대출 정보가 존재하지 않아 반납할 수 없습니다.');
END;
