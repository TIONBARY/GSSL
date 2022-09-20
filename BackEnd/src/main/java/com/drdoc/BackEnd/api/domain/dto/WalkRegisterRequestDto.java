package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;
import java.util.List;

import io.swagger.annotations.ApiModelProperty;
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
public class WalkRegisterRequestDto {

	@ApiModelProperty(name = "start_time", example = "2022-09-14T15:44:30.327959")
	private LocalDateTime start_time;

	@ApiModelProperty(name = "end_time", example = "2022-09-14T15:44:30.327959")
	private LocalDateTime end_time;

	@ApiModelProperty(name = "distance", example = "123")
	private int distance;

	@ApiModelProperty(name = "pet_ids", example = "[1,2,3,4]")
	private List<Integer> pet_ids;

}
