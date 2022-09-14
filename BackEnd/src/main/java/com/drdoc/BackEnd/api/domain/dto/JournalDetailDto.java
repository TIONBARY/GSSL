package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;

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
    private LocalDateTime created_date;    
    
}