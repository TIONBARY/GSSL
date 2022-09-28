package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("PetKindListResponse")
public class PetKindResponseDto extends BaseResponseDto {
	@ApiModelProperty(name = "Pet Kind List")
	private List<PetKindListDto> petKindList;
	
	public PetKindResponseDto(Integer statusCode, String message, List<PetKindListDto> petList) {
		super(statusCode, message);
		this.petKindList = petList;
	}
	
	public static PetKindResponseDto of(Integer statusCode, String message, List<PetKindListDto> petList) {
		PetKindResponseDto body = new PetKindResponseDto(statusCode, message, petList);
		return body;
	}

}
