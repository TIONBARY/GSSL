package com.drdoc.BackEnd.api.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JournalDetailResponseDto extends BaseResponseDto {
	
	private JournalDetailDto detail;
	
	public JournalDetailResponseDto(Integer statusCode, String message, JournalDetailDto detail) {
		super(statusCode, message);
		this.detail = detail;
	}
	
	public static JournalDetailResponseDto of(Integer statusCode, String message, JournalDetailDto detail) {
		JournalDetailResponseDto body = new JournalDetailResponseDto(statusCode, message, detail);
		return body;
	}

}
