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
	
	private TokenDto tokenDto;
	
	public JournalDetailResponseDto(Integer statusCode, String message, TokenDto tokenDto) {
		super(statusCode, message);
		this.tokenDto = tokenDto;
	}
	
	public static JournalDetailResponseDto of(Integer statusCode, String message, TokenDto tokenDto) {
		JournalDetailResponseDto body = new JournalDetailResponseDto(statusCode, message, tokenDto);
		return body;
	}

}
