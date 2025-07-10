	    function confirmDelete(noticeId) {
	        if (confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
	            location.href = '/pilotpjt/notice_delete?id=' + noticeId;
	        }
	    }