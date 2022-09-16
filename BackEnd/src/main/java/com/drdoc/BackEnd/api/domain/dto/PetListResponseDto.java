package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("PetListResponse")
public class PetListResponseDto extends BaseResponseDto {
	@ApiModelProperty(name = "Pet List")
	private List<PetListDto> petList;
	
	public PetListResponseDto(Integer statusCode, String message, List<PetListDto> petList) {
		super(statusCode, message);
		this.petList = petList;
	}
	
	public static PetListResponseDto of(Integer statusCode, String message, List<PetListDto> petList) {
		PetListResponseDto body = new PetListResponseDto(statusCode, message, petList);
		return body;
	}

}
