package com.drdoc.BackEnd.api.domain.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("BoardDetailResponse")
public class BoardDetailResponseDto extends BaseResponseDto {

	@ApiModelProperty(name = "Board Detail")
	private BoardDetailDto board;

	public BoardDetailResponseDto(Integer statusCode, String message, BoardDetailDto board) {
		super(statusCode, message);
		this.board = board;
	}

	public static BoardDetailResponseDto of(Integer statusCode, String message, BoardDetailDto board) {
		BoardDetailResponseDto body = new BoardDetailResponseDto(statusCode, message, board);
		return body;
	}
}
