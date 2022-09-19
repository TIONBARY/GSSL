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
public class PetDetailDto {
	
	private int id;
	private int user_id;
	private String kind;
	private boolean species;
	private String name;
	private String gender;
	private boolean neutralize;
	private LocalDateTime birth;
	private float weight;
	private String animal_pic;
	private boolean death;
	private String diseases;
	private String description;

}
