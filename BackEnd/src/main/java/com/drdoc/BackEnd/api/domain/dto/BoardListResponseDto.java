package com.drdoc.BackEnd.api.domain.dto;

import org.springframework.data.domain.Page;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("BoardListResponse")
public class BoardListResponseDto extends BaseResponseDto {

	@ApiModelProperty(name = "Board List")
	private Page<BoardListDto> boardList;

	public BoardListResponseDto(Integer statusCode, String message, Page<BoardListDto> boardList) {
		super(statusCode, message);
		this.boardList = boardList;
	}

	public static BoardListResponseDto of(Integer statusCode, String message, Page<BoardListDto> boardList) {
		BoardListResponseDto body = new BoardListResponseDto(statusCode, message, boardList);
		return body;
	}
}
