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
public class WalkDoneResponseDto extends BaseResponseDto {
	
	private boolean isDone;
	
	public WalkDoneResponseDto(Integer statusCode, String message, boolean isDone) {
		super(statusCode, message);
		this.isDone = isDone;
	}
	
	public static WalkDoneResponseDto of(Integer statusCode, String message, boolean isDone) {
		WalkDoneResponseDto body = new WalkDoneResponseDto(statusCode, message, isDone);
		return body;
	}

}
