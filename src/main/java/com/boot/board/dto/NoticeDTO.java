package com.boot.board.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NoticeDTO {
	private int noticeNum;
	private String noticeTitle;
	private String noticeContent;
	private String noticeWriter;
	private String noticeRegdate;
	private int noticeViews;
	private String noticeCategory;
}
