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
public class JournalDetailDto {
	
    private int petId;
    private String picture;
    private String part;
    private String symptom;
    private String result;
    private LocalDateTime created_date;    
    
	public JournalDetailDto(Journal journal) {
		this.petId = journal.getPetId();
		this.picture = journal.getPicture();
		this.part = journal.getPart();
		this.symptom = journal.getSymptom();
		this.result = journal.getResult();
		this.created_date = journal.getCreated_date();
	}


}