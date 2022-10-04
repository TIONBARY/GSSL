package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;

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

	@ApiModelProperty(name="time_passed", example="0000-01-08T03:23:05.224")
	private LocalDateTime time_passed;
	@ApiModelProperty(name="distance_sum", example="10959")
	private int distance_sum;

}