package com.drdoc.BackEnd.api.domain.dto;

import org.springframework.data.domain.Page;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("WalkListResponse")
public class WalkListResponseDto extends BaseResponseDto {

	@ApiModelProperty(name = "Walk List")
	private Page<WalkDetailDto> walkList;

	public WalkListResponseDto(Integer statusCode, String message, Page<WalkDetailDto> walkList) {
		super(statusCode, message);
		this.walkList = walkList;
	}

	public static WalkListResponseDto of(Integer statusCode, String message, Page<WalkDetailDto> walkList) {
		WalkListResponseDto body = new WalkListResponseDto(statusCode, message, walkList);
		return body;
	}
}
