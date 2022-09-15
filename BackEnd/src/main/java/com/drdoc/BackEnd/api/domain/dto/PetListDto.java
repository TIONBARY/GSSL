package com.drdoc.BackEnd.api.domain.dto;

import com.drdoc.BackEnd.api.domain.Pet;

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
public class PetListDto {

	private int id;
	private int user_id;
	private String name;
	private String animal_pic;
	
	public PetListDto(Pet pet) {
		this.id = pet.getId();
		this.user_id = pet.getUser().getId();
		this.name = pet.getName();
		this.animal_pic = pet.getAnimalPic();
	}
}
