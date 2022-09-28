package com.drdoc.BackEnd.api.domain.dto;

import com.drdoc.BackEnd.api.domain.Kind;

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
public class PetKindListDto {
	
	private int id;
	private String name;
	
	public PetKindListDto(Kind kind) {
		this.id = kind.getId();
		this.name = kind.getName();
	}
}
