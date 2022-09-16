package com.drdoc.BackEnd.api.domain.dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

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
public class UserModifyRequestDto {

    @NotBlank(message = "아이디는 필수 입력 값입니다.")
    @Pattern(regexp="(?=.*\\w).{5,20}",
            message = "아이디는 영문 대,소문자와 _, 숫자만 사용 가능하며, 5자 ~ 20자여야 합니다.")
	@ApiModelProperty(name="member_id", example="ssafy123")
    private String member_id;
	
	@Pattern(regexp="(?=.*[0-9])(?=.*[a-zA-Z])(?=.*\\W)(?=\\S+$).{8,16}",
            message = "비밀번호는 영문 소문자와 숫자, 특수기호가 적어도 1개 이상씩 포함된 8자 ~ 16자의 비밀번호여야 합니다.")
	@ApiModelProperty(name="password", example="password!123")
    private String password;

    @NotBlank(message = "닉네임은 필수 입력 값입니다.")
    @Size(max=10)
	@ApiModelProperty(name="nickname", example="김싸피")
    private String nickname;

    @NotBlank(message = "성별은 필수 입력 값입니다.")
    @Size(max=1)
	@ApiModelProperty(name="gender", example="F")
    private String gender;

    @NotBlank(message = "전화번호는 필수 입력 값입니다.")
    @Size(max=11)
	@ApiModelProperty(name="phone", example="01012345678")
    private String phone;

    @NotBlank(message = "이메일 주소는 필수 입력 값입니다.")
    @Email
    @Size(max=50)
	@ApiModelProperty(name="email", example="ssafy@ssafy.com")
    private String email;

    @Size(max=256)
	@ApiModelProperty(name="profile_pic", example="randompic")
    private String profile_pic;

    @Size(max=50)
	@ApiModelProperty(name="introduce", example="간단한 자기소개입니다.")
    private String introduce;
    
    @ApiModelProperty(name="pet_id", example="1")
    private int pet_id;
        
}