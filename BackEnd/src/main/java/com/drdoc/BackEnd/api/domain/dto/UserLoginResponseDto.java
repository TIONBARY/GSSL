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
public class UserLoginResponseDto extends BaseResponseDto {
	
	private TokenDto tokenDto;
	
	public UserLoginResponseDto(Integer statusCode, String message, TokenDto tokenDto) {
		super(statusCode, message);
		this.tokenDto = tokenDto;
	}
	
	public static UserLoginResponseDto of(Integer statusCode, String message, TokenDto tokenDto) {
		UserLoginResponseDto body = new UserLoginResponseDto(statusCode, message, tokenDto);
		return body;
	}

}
