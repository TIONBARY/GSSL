package com.drdoc.BackEnd.api.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("PetDetailResponse")
public class PetDetailResponseDto extends BaseResponseDto {
	
	@ApiModelProperty(name = "Pet Detail")
	private PetDetailDto pet;

	public PetDetailResponseDto(Integer statusCode, String message, PetDetailDto pet) {
		super(statusCode, message);
		this.pet = pet;
	}

	public static PetDetailResponseDto of(Integer statusCode, String message, PetDetailDto pet) {
		PetDetailResponseDto body = new PetDetailResponseDto(statusCode, message, pet);
		return body;
	}


}
