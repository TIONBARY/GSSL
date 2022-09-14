package com.drdoc.BackEnd.api.domain.dto;

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
public class BoardWriteRequestDto {
	
	@ApiModelProperty(name="type_id", example="1")
    private int type_id;
	
	@ApiModelProperty(name="title", example="게시글 제목")
	@Size(max=20)
	private String title;
	
	@ApiModelProperty(name="image", example="게시글 사진")
	@Size(max=256)
	private String image;
	
	@ApiModelProperty(name="content", example="게시글 내용")
	@Size(max=1000)
	private String content;
}
