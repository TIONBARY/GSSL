package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.drdoc.BackEnd.api.domain.Walk;

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
public class WalkDetailDto {

	private int walk_id;
	private LocalDateTime start_time;
	private LocalDateTime end_time;
	private int distance;
	private List<WalkPetDetailDto> petsList;

	public WalkDetailDto(Walk walk) {
		this.walk_id = walk.getId();
		this.start_time = walk.getStart_time();
		this.end_time = walk.getEnd_time();
		this.distance = walk.getDistance();
	}

	public WalkDetailDto(Walk walk, List<WalkPetDetailDto> petsList) {
		this(walk);
		this.petsList = petsList;
	}

	public void editPetList(List<WalkPetDetailDto> petsList) {
		this.petsList = petsList;
	}

}