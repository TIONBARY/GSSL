package com.drdoc.BackEnd.api.domain.dto;

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
public class WalkDetailResponseDto extends BaseResponseDto {
	
	private WalkDetailDto detail;
	
	public WalkDetailResponseDto(Integer statusCode, String message, WalkDetailDto detail) {
		super(statusCode, message);
		this.detail = detail;
	}
	
	public static WalkDetailResponseDto of(Integer statusCode, String message, WalkDetailDto detail) {
		WalkDetailResponseDto body = new WalkDetailResponseDto(statusCode, message, detail);
		return body;
	}

}
