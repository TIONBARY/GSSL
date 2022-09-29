package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("PetKindListResponse")
public class PetKindResponseDto extends BaseResponseDto {
	@ApiModelProperty(name = "Pet Kind")
	private PetKindListDto petKind;
	
	public PetKindResponseDto(Integer statusCode, String message, PetKindListDto petKind) {
		super(statusCode, message);
		this.petKind = petKind;
	}
	
	public static PetKindResponseDto of(Integer statusCode, String message, PetKindListDto petKind) {
		PetKindResponseDto body = new PetKindResponseDto(statusCode, message, petKind);
		return body;
	}

}
