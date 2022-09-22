package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;

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
public class JournalThumbnailDto {

    private int journal_id;
    private int pet_id;
    private String picture;
    private String result;
    private LocalDateTime created_date;    
    
	public JournalThumbnailDto(Journal journal) {
		this.journal_id = journal.getId();
		this.pet_id = journal.getPet_id();
		this.picture = journal.getPicture();
		this.result = journal.getResult();
		this.created_date = journal.getCreated_date();
	}


}