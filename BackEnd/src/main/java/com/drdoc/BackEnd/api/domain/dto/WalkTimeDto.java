package com.drdoc.BackEnd.api.domain.dto;

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
public class WalkTimeDto {

	@ApiModelProperty(name="time_passed", example="11111")
	private int time_passed;
	@ApiModelProperty(name="distance_sum", example="10959")
	private int distance_sum;

}