package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("PetKindListResponse")
public class PetKindListResponseDto extends BaseResponseDto {
	@ApiModelProperty(name = "Pet Kind List")
	private List<PetKindListDto> petKindList;
	
	public PetKindListResponseDto(Integer statusCode, String message, List<PetKindListDto> petList) {
		super(statusCode, message);
		this.petKindList = petList;
	}
	
	public static PetKindListResponseDto of(Integer statusCode, String message, List<PetKindListDto> petList) {
		PetKindListResponseDto body = new PetKindListResponseDto(statusCode, message, petList);
		return body;
	}

}
