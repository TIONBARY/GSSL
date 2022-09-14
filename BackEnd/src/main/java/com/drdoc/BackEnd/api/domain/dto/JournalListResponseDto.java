package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

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
	
	private List<JournalDto> journalDtoList;
	
	public JournalListResponseDto(Integer statusCode, String message, List<JournalDto> journalDtoList) {
		super(statusCode, message);
		this.journalDtoList = journalDtoList;
	}
	
	public static JournalListResponseDto of(Integer statusCode, String message, List<JournalDto> journalDtoList) {
		JournalListResponseDto body = new JournalListResponseDto(statusCode, message, journalDtoList);
		return body;
	}

}
