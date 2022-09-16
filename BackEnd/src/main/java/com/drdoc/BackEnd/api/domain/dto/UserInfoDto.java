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
public class UserInfoDto {

	@ApiModelProperty(name="member_id", example="ssafy123")
    private String member_id;

	@ApiModelProperty(name="nickname", example="김싸피")
    private String nickname;

	@ApiModelProperty(name="gender", example="F")
    private String gender;

	@ApiModelProperty(name="phone", example="01012345678")
    private String phone;

	@ApiModelProperty(name="email", example="ssafy@ssafy.com")
    private String email;

	@ApiModelProperty(name="profile_pic", example="randompic")
    private String profile_pic;

	@ApiModelProperty(name="introduce", example="간단한 자기소개입니다.")
    private String introduce;
	
	@ApiModelProperty(name="leave", example="false")
    private boolean leave;
}
