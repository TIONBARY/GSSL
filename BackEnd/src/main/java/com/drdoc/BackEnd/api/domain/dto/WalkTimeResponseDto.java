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
public class WalkTimeResponseDto extends BaseResponseDto {
	
	@ApiModelProperty(name="WalkTimeDto")
	private WalkTimeDto totalInfo;
	
	public WalkTimeResponseDto(Integer statusCode, String message, WalkTimeDto totalInfo) {
		super(statusCode, message);
		this.totalInfo = totalInfo;
	}
	
	public static WalkTimeResponseDto of(Integer statusCode, String message, WalkTimeDto totalInfo) {
		WalkTimeResponseDto body = new WalkTimeResponseDto(statusCode, message, totalInfo);
		return body;
	}

}
