package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

import com.drdoc.BackEnd.api.domain.Journal;

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
	
	private List<Journal> journalList;
	
	public JournalListResponseDto(Integer statusCode, String message, List<Journal> journalList) {
		super(statusCode, message);
		this.journalList = journalList;
	}
	
	public static JournalListResponseDto of(Integer statusCode, String message, List<Journal> journalList) {
		JournalListResponseDto body = new JournalListResponseDto(statusCode, message, journalList);
		return body;
	}

}
