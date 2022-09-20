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
public class WalkPetDetailDto {

	private int pet_id;
	private String name;
	private String gender;
	private String animal_pic;

	public WalkPetDetailDto(Pet pet) {
		this.pet_id = pet.getId();
		this.name = pet.getName();
		this.gender = pet.getGender();
		this.animal_pic = pet.getAnimalPic();
	}
}
