package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;

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
public class JournalRequestDto {
    
	@ApiModelProperty(name="pet_id", example="1234")
    private int pet_id;
	
	@ApiModelProperty(name="picture", example="null")
    private String picture;

    @NotBlank(message = "부위는 필수 입력 값입니다.")
	@ApiModelProperty(name="part", example="다리")
    private String part;

	@ApiModelProperty(name="symptom", example="가려움")
    private String symptom;

    @NotBlank(message = "결과는 필수 입력 값입니다.")
	@ApiModelProperty(name="result", example="결막염")
    private String result;
	
	@ApiModelProperty(name="created_date", example="2022-09-14T15:44:30.327959")
    private LocalDateTime created_date;
	
//  자동 입력 불가능한 항목 주석처리
//	@ApiModelProperty(name="cured", example="true")
//    private boolean cured;
//
//	@ApiModelProperty(name="start_date", example="2022-09-14T15:44:30.327959")
//    private LocalDateTime start_date;
//
//	@ApiModelProperty(name="end_date", example="2022-09-14T15:44:30.327959")
//    private LocalDateTime end_date;
}
