package com.drdoc.BackEnd.api.domain.dto;

import javax.validation.constraints.NotBlank;

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
public class UserLogoutRequestDto {

    @NotBlank(message = "Refresh Token은 필수 입력 값입니다.")
	@ApiModelProperty(name="refresh_token", example="eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzc2FmeSIsImF1dGgiOiJST0xFX1VTRVIiLCJleHAiOjE2NjMwNDIwOTZ9.Or20tcoghV7mDGUAoMKOb2wYc_ku6Bp3mtOvJ29tcBuaeGE1c2bCClAVIaQre2bJ1B7BHr-KokoSs8o59Lq6SQ")
    private String refresh_token;	
}
