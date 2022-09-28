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
public class CommentWriteRequestDto {

	@ApiModelProperty(name = "board_id", example = "1")
	private int board_id;

	@ApiModelProperty(name = "content", example = "게시글 내용")
	@Size(max = 1000)
	private String content;
}
