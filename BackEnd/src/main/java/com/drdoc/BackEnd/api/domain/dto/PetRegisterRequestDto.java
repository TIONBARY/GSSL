package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;

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
public class PetRegisterRequestDto {
	
	@ApiModelProperty(name = "kind_id", example = "2")
	private int kind_id;
	
	@ApiModelProperty(name = "species", example = "true")
	private boolean species;
	
	@ApiModelProperty(name = "name", example = "초코")
	@Size(max = 10)
	private String name;
	
	@ApiModelProperty(name = "gender", example="true")
	@Size(max=1)
    private String gender;
	
	@ApiModelProperty(name = "neutralize", example="true")
	private boolean neutralize;
	
	@ApiModelProperty(name = "birth", example="2022-09-14T15:44:30.327959")
	private LocalDateTime birth;
	
	@ApiModelProperty(name = "weight", example="3.3")
	private float weight;
	
	@ApiModelProperty(name="animal_pic", example="주소1")
	@Size(max=256)
    private String animal_pic;
	
	@ApiModelProperty(name = "death", example="false")
	private boolean death;
	
	@ApiModelProperty(name = "diseases", example="null")
	@Size(max=15)
	private String diseases;
	
    @Size(max=50)
	@ApiModelProperty(name="description", example="갓 태어난 아이 초코입니다. 귀엽습니다.")
    private String description;
	
	
	


}
