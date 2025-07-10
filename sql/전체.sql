GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, 
      CREATE SYNONYM, CREATE PROCEDURE, CREATE TRIGGER, CREATE MATERIALIZED VIEW 
TO bookmanager;
GRANT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE
TO bookmanager;
ALTER USER bookmanager DEFAULT TABLESPACE USERS;
ALTER USER bookmanager QUOTA UNLIMITED ON USERS;


CREATE TABLE USERINFO (
userNumber      NUMBER PRIMARY KEY,
userId          VARCHAR2(100),
userPw          VARCHAR2(100),
userName        VARCHAR2(100),
userTel         VARCHAR2(20),
userEmail       VARCHAR2(200),
userBirth       VARCHAR2(50),
userZipCode     VARCHAR2(50),
userAddress     VARCHAR2(300),
userDetailAddress VARCHAR2(500),
userBorrow      NUMBER DEFAULT 0,
userCanBorrow      NUMBER DEFAULT 5,
userAdmin       NUMBER DEFAULT 0,
userRegdate     DATE DEFAULT SYSDATE
);


CREATE TABLE user_sessions (
userId VARCHAR(50) PRIMARY KEY,
sessionId VARCHAR(100) NOT NULL,
loginTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE BOOKINFO (
bookNumber          NUMBER PRIMARY KEY,
bookIsbn            VARCHAR2(50) DEFAULT 0,
bookTitle           VARCHAR2(400),
bookComent          VARCHAR2(4000),
bookWrite           VARCHAR2(100),
bookPub             VARCHAR2(100),
bookDate            DATE,
bookMajorCategory   NVARCHAR2(100),
bookSubCategory     NVARCHAR2(100),
bookCount           NUMBER,
bookBorrowCount     NUMBER DEFAULT 0
);


CREATE TABLE NOTICE(
noticeNum            NUMBER PRIMARY KEY,
noticeTitle          VARCHAR2(500) NOT NULL,
noticeContent        VARCHAR2(4000) NOT NULL,
noticewriter         VARCHAR2(100) DEFAULT '관리자',
noticeregdate        DATE DEFAULT SYSDATE,
noticeviews          NUMBER DEFAULT 0,
noticeCategory       VARCHAR2(30)
);


CREATE TABLE BOARD (
boardNumber     NUMBER PRIMARY KEY,
userNumber      NUMBER,
userName        VARCHAR2(50),
boardTitle      VARCHAR2(1000),
boardContent    VARCHAR2(4000),
boardWriteDate  DATE DEFAULT SYSDATE,
boardHit        NUMBER DEFAULT 0,
boardViews      NUMBER DEFAULT 0,
boardLikes      NUMBER DEFAULT 0,
FOREIGN KEY (userNumber) REFERENCES USERINFO(userNumber)ON DELETE CASCADE
);


CREATE TABLE board_likes (
boardNumber number,
userNumber number,
PRIMARY KEY (boardNumber, userNumber)
);


CREATE TABLE BOARD_COMMENT (
commentNumber       NUMBER PRIMARY KEY,
commentSubNumber    NUMBER,
commentSubStepNumber NUMBER,
boardNumber         NUMBER,
userNumber          NUMBER,
userName            VARCHAR2(50),
commentContent      VARCHAR2(4000),
commentWriteDate    DATE DEFAULT SYSDATE,
COMMENTSTATUS VARCHAR2(10) DEFAULT 'ACTIVE'
);


ALTER TABLE BOARD_COMMENT
ADD CONSTRAINT fk_comment_board
FOREIGN KEY (boardNumber)
REFERENCES BOARD(boardNumber)
ON DELETE CASCADE;


ALTER TABLE BOARD_COMMENT
ADD CONSTRAINT fk_comment_user
FOREIGN KEY (userNumber)
REFERENCES USERINFO(userNumber)
ON DELETE CASCADE;
DESC board_comment;


CREATE TABLE BOOK_BORROW (
borrowNumber        NUMBER PRIMARY KEY,
userNumber          NUMBER,
bookNumber          NUMBER,
bookTitle           VARCHAR2 (400),
bookWrite           VARCHAR2 (100),
bookBorrowDate      DATE DEFAULT SYSDATE,
bookReturnDate      DATE,
bookMajorCategory   NVARCHAR2(100),
bookSubCategory     NVARCHAR2(100),
FOREIGN KEY (userNumber) REFERENCES USERINFO(userNumber)ON DELETE CASCADE,
FOREIGN KEY (bookNumber) REFERENCES BOOKINFO(bookNumber)ON DELETE CASCADE
);

CREATE TABLE Book_RECORD (
recordNumber  NUMBER PRIMARY KEY,
userNumber          NUMBER,
bookNumber          NUMBER,
bookTitle           VARCHAR2 (400),
bookWrite           VARCHAR2 (100),
bookBorrowDate      DATE,
bookReturnDate      DATE,
bookMajorCategory   NVARCHAR2(100),
bookSubCategory     NVARCHAR2(100),
FOREIGN KEY (userNumber) REFERENCES USERINFO(userNumber),
FOREIGN KEY (bookNumber) REFERENCES BOOKINFO(bookNumber)
);


CREATE TABLE BOOK_REVIEW (
REVIEWID NUMBER PRIMARY KEY,                -- 리뷰 고유 ID (시퀀스 사용)
BOOKNUMBER NUMBER NOT NULL,                 -- 도서 번호 (외래키) - 실제 타입으로 수정 필요
USERNUMBER NUMBER NOT NULL,                 -- 사용자 ID (외래키) - VARCHAR2(50)에서 NUMBER로 수정
REVIEWTITLE VARCHAR2(200) NOT NULL,         -- 리뷰 제목
REVIEWCONTENT CLOB NOT NULL,                -- 리뷰 내용 (긴 텍스트)
REVIEWRATING NUMBER(1) NOT NULL,            -- 평점 (1-5)
REVIEWDATE DATE DEFAULT SYSDATE,            -- 작성일
REVIEWMODIFIED_DATE DATE,                   -- 수정일
REVIEWSTATUS VARCHAR2(10) DEFAULT 'ACTIVE',           -- 상태 (Y: 활성, N: 삭제)

CONSTRAINT FK_REVIEW_BOOK FOREIGN KEY (BOOKNUMBER) REFERENCES BOOKINFO(BOOKNUMBER),
CONSTRAINT FK_REVIEW_USER FOREIGN KEY (USERNUMBER) REFERENCES USERINFO(USERNUMBER),
CONSTRAINT CHK_REVIEW_RATING CHECK (REVIEWRATING BETWEEN 1 AND 5)

);


-- 리뷰 ID 시퀀스
CREATE SEQUENCE SEQ_REVIEW_ID
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE TABLE REVIEW_HELPFUL (
HELPFUL_ID NUMBER PRIMARY KEY,
REVIEWID NUMBER NOT NULL,
USERNUMBER NUMBER NOT NULL,
HELPFUL_DATE DATE DEFAULT SYSDATE,
CONSTRAINT FK_REVIEW_HELPFUL_REVIEW FOREIGN KEY (REVIEWID) REFERENCES BOOK_REVIEW(REVIEWID),
CONSTRAINT FK_REVIEW_HELPFUL_USER FOREIGN KEY (USERNUMBER) REFERENCES USERINFO(USERNUMBER),
CONSTRAINT UQ_REVIEW_HELPFUL UNIQUE (REVIEWID, USERNUMBER)
);


-- 리뷰(도움됨)시퀀스 생성
CREATE SEQUENCE SEQ_HELPFUL_ID
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


-- 거래게시판
CREATE TABLE Trade_Post (
    postID NUMBER PRIMARY KEY,
    userNumber NUMBER NOT NULL,  -- userID에서 userNumber로 변경
    title VARCHAR2(100) NOT NULL,
    content CLOB NOT NULL,
    price NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'AVAILABLE', -- AVAILABLE, RESERVED, SOLD
    location VARCHAR2(100),
    viewCount NUMBER DEFAULT 0,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    BOOKMAJORCATEGORY VARCHAR2(100),
    BOOKSUBCATEGORY VARCHAR2(100),
    CONSTRAINT fk_tradePost_user FOREIGN KEY (userNumber) REFERENCES userinfo(userNumber)  -- 참조 컬럼 변경
);

-- 시퀀스 생성
CREATE SEQUENCE seqPostID START WITH 1 INCREMENT BY 1;

-- 채팅방
CREATE TABLE Trade_ChatRoom (
    roomID NUMBER PRIMARY KEY,
    postID NUMBER NOT NULL,
    sellerNumber NUMBER NOT NULL,  -- sellerID에서 sellerNumber로 변경
    buyerNumber NUMBER NOT NULL,   -- buyerID에서 buyerNumber로 변경
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastMessageAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'ACTIVE', -- ACTIVE, INACTIVE, BLOCKED
    CONSTRAINT fk_chatRoom_post FOREIGN KEY (postID) REFERENCES Trade_Post(postID),
    CONSTRAINT fk_chatRoom_seller FOREIGN KEY (sellerNumber) REFERENCES userinfo(userNumber),  -- 참조 컬럼 변경
    CONSTRAINT fk_chatRoom_buyer FOREIGN KEY (buyerNumber) REFERENCES userinfo(userNumber),    -- 참조 컬럼 변경
    CONSTRAINT uq_chatRoom UNIQUE (postID, sellerNumber, buyerNumber)  -- 제약조건 컬럼명 변경
);

-- 시퀀스 생성
CREATE SEQUENCE seqRoomID START WITH 1 INCREMENT BY 1;

-- 채팅방 메세지
CREATE TABLE Trade_ChatMessage (
    messageID NUMBER PRIMARY KEY,
    roomID NUMBER NOT NULL,
    senderNumber NUMBER NOT NULL, 
    RECEIVERNUMBER NUMBER NOT NULL,  
    message CLOB NOT NULL,
    readStatus VARCHAR2(10) DEFAULT 'UNREAD', -- READ, UNREAD
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chatMessage_room FOREIGN KEY (roomID) REFERENCES trade_chatroom(roomID),
    CONSTRAINT fk_chatMessage_sender FOREIGN KEY (senderNumber) REFERENCES userinfo(userNumber)  -- 참조 컬럼 변경
);

-- 시퀀스 생성
CREATE SEQUENCE seqMessageID START WITH 1 INCREMENT BY 1;



CREATE SEQUENCE TRADE_CHATROOM_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 시퀀스 생성
CREATE SEQUENCE TRADE_CHATMESSAGE_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
-- 인덱스 추가
CREATE INDEX IDX_CHATROOM_SELLER ON TRADE_CHATROOM(SELLERNUMBER);
CREATE INDEX IDX_CHATROOM_BUYER ON TRADE_CHATROOM(BUYERNUMBER);
CREATE INDEX IDX_CHATROOM_POST ON TRADE_CHATROOM(POSTID);
CREATE INDEX IDX_CHATMESSAGE_ROOM ON TRADE_CHATMESSAGE(ROOMID);
CREATE INDEX IDX_CHATMESSAGE_SENDER ON TRADE_CHATMESSAGE(SENDERNUMBER);
CREATE INDEX IDX_CHATMESSAGE_CREATEDAT ON TRADE_CHATMESSAGE(CREATEDAT);


-- 중고도서 관심
CREATE TABLE Trade_Favorite (
    favoriteID NUMBER PRIMARY KEY,
    postID NUMBER NOT NULL,
    userNumber NUMBER NOT NULL,  -- userID에서 userNumber로 변경
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tradeFavorite_post FOREIGN KEY (postID) REFERENCES Trade_Post(postID),
    CONSTRAINT fk_tradeFavorite_user FOREIGN KEY (userNumber) REFERENCES userinfo(userNumber),  -- 참조 컬럼 변경
    CONSTRAINT uq_tradeFavorite UNIQUE (postID, userNumber)  -- 제약조건 컬럼명 변경
);

-- 시퀀스 생성
CREATE SEQUENCE seqFavoriteID START WITH 1 INCREMENT BY 1;

-- 거래내역
CREATE TABLE Trade_record (
    transactionID NUMBER PRIMARY KEY,
    postID NUMBER NOT NULL,
    sellerNumber NUMBER NOT NULL,  -- sellerID에서 sellerNumber로 변경
    buyerNumber NUMBER NOT NULL,   -- buyerID에서 buyerNumber로 변경
    price NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'PENDING', -- PENDING, COMPLETED, CANCELED
    completedAt TIMESTAMP,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_post FOREIGN KEY (postID) REFERENCES Trade_Post(postID),
    CONSTRAINT fk_transaction_seller FOREIGN KEY (sellerNumber) REFERENCES userinfo(userNumber),  -- 참조 컬럼 변경
    CONSTRAINT fk_transaction_buyer FOREIGN KEY (buyerNumber) REFERENCES userinfo(userNumber)     -- 참조 컬럼 변경
);

-- 시퀀스 생성
CREATE SEQUENCE seqTransactionID START WITH 1 INCREMENT BY 1;


-- 위시리스트
-- 북마크 테이블
CREATE TABLE BOOK_WISHLIST (
  userNumber  NUMBER,
  bookNumber  NUMBER,
  addedDate   DATE DEFAULT SYSDATE,
  PRIMARY KEY (userNumber, bookNumber),
  FOREIGN KEY (userNumber) REFERENCES USERINFO(userNumber) ON DELETE CASCADE,
  FOREIGN KEY (bookNumber) REFERENCES BOOKINFO(bookNumber) ON DELETE CASCADE
);
    

-- activity_log 테이블 생성
CREATE TABLE ACTIVITY_LOG (
    log_id NUMBER PRIMARY KEY,
    activity_type VARCHAR2(50) NOT NULL, -- 활동 유형 (book_add, user_add, book_borrow, notice_add, book_return, notice_delete, book_delete)
    actor_type VARCHAR2(20) NOT NULL, -- 수행자 유형 (admin or user)
    actor_id NUMBER NOT NULL, -- 수행자 ID
    actor_name VARCHAR2(100) NOT NULL, -- 수행자 이름
    target_name VARCHAR2(255), -- 대상 이름 (책 제목, 회원 이름 등)
    description VARCHAR2(500) NOT NULL, -- 활동 설명
    log_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL -- 로그 생성 시간
);

-- activity_log 테이블 시퀀스 생성
CREATE SEQUENCE activity_log_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;



-- 인덱스 생성
CREATE INDEX idx_activity_type ON ACTIVITY_LOG(activity_type);
CREATE INDEX idx_actor_type ON ACTIVITY_LOG(actor_type);
CREATE INDEX idx_log_date ON ACTIVITY_LOG(log_date);



CREATE TABLE NOTIFICATIONS
   (   ID NUMBER, 
   USER_NUMBER NUMBER NOT NULL ENABLE, 
   MESSAGE VARCHAR2(4000) NOT NULL ENABLE, 
   CREATED_AT TIMESTAMP (6) DEFAULT SYSTIMESTAMP NOT NULL ENABLE, 
   SENT NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
   READ NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
   TITLE VARCHAR2(100) NOT NULL ENABLE, 
   TYPE VARCHAR2(100) NOT NULL ENABLE, 
   URL VARCHAR2(200) );



--------------------------------------------- 시퀀스 드래그로 개별 컴파일
CREATE SEQUENCE  "BOOKMANAGER"."NOTIFICATIONS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 307 NOCACHE  NOORDER  NOCYCLE 

CREATE SEQUENCE  "BOOKMANAGER"."BORROWRECORD_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE


--------------------------------------------- 트리거 드래그로 개별 컴파일
CREATE OR REPLACE TRIGGER trg_notifications_id
BEFORE INSERT ON NOTIFICATIONS
FOR EACH ROW
BEGIN
    SELECT notifications_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

CREATE INDEX IDX_NOTI_USER ON NOTIFICATIONS(USER_NUMBER);
CREATE INDEX IDX_NOTI_SENT ON NOTIFICATIONS(SENT);
CREATE INDEX IDX_NOTI_READ ON NOTIFICATIONS(READ);


--------------------------------------------- 트리거 드래그로 개별 컴파일
CREATE OR REPLACE TRIGGER activity_log_bi
BEFORE INSERT ON ACTIVITY_LOG
FOR EACH ROW
BEGIN
    SELECT activity_log_seq.NEXTVAL
    INTO :new.log_id
    FROM dual;
END;

--------------------------------------------- 트리거 드래그로 개별 컴파일
create or replace TRIGGER after_book_record_insert
after INSERT ON book_record
FOR EACH ROW

BEGIN
-- BOOKINFO 업데이트
UPDATE BOOKINFO
SET
BOOKCOUNT = BOOKCOUNT + 1
WHERE BOOKNUMBER = :NEW.BOOKNUMBER;

-- USERINFO 업데이트
UPDATE USERINFO
SET
    USERCANBORROW = USERCANBORROW + 1
WHERE USERNUMBER = :NEW.USERNUMBER;

END;

--------------------------------------------- 세션 어쩌구
ALTER SESSION SET PLSCOPE_SETTINGS='IDENTIFIERS:NONE';
--------------------------------------------- 트리거 드래그로 개별 컴파일

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


--------------------------------------------- 트리거 드래그로 개별 컴파일
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