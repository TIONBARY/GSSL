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
public class JournalListResponseDto extends BaseResponseDto {
	
	private JournalDto journalDto;
	
	public JournalListResponseDto(Integer statusCode, String message, JournalDto journalDto) {
		super(statusCode, message);
		this.journalDto = journalDto;
	}
	
	public static JournalListResponseDto of(Integer statusCode, String message, JournalDto journalDto) {
		JournalListResponseDto body = new JournalListResponseDto(statusCode, message, journalDto);
		return body;
	}

}
