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
	private WalkTimeDto detail;
	
	public WalkTimeResponseDto(Integer statusCode, String message, WalkTimeDto detail) {
		super(statusCode, message);
		this.detail = detail;
	}
	
	public static WalkTimeResponseDto of(Integer statusCode, String message, WalkTimeDto detail) {
		WalkTimeResponseDto body = new WalkTimeResponseDto(statusCode, message, detail);
		return body;
	}

}
