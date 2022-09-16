package com.drdoc.BackEnd.api.domain.dto;

import org.springframework.data.domain.Page;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("JournalListResponse")
public class JournalListResponseDto extends BaseResponseDto {

	@ApiModelProperty(name = "Journal List")
	private Page<JournalThumbnailDto> journalList;

	public JournalListResponseDto(Integer statusCode, String message, Page<JournalThumbnailDto> journalList) {
		super(statusCode, message);
		this.journalList = journalList;
	}

	public static JournalListResponseDto of(Integer statusCode, String message, Page<JournalThumbnailDto> journalList) {
		JournalListResponseDto body = new JournalListResponseDto(statusCode, message, journalList);
		return body;
	}
}
