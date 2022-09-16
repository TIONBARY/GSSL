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
public class UserInfoResponseDto extends BaseResponseDto {
	
	private UserInfoDto userInfoDto;
	
	public UserInfoResponseDto(Integer statusCode, String message, UserInfoDto userInfoDto) {
		super(statusCode, message);
		this.userInfoDto = userInfoDto;
	}
	
	public static UserInfoResponseDto of(Integer statusCode, String message, UserInfoDto userInfoDto) {
		UserInfoResponseDto body = new UserInfoResponseDto(statusCode, message, userInfoDto);
		return body;
	}

}
