package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

import org.springframework.data.domain.Page;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;

@Getter
@ApiModel("CommentListResponse")
public class CommentListResponseDto extends BaseResponseDto {

	@ApiModelProperty(name = "Comment List")
	private List<CommentListDto> comments;

	public CommentListResponseDto(Integer statusCode, String message, List<CommentListDto> comments) {
		super(statusCode, message);
		this.comments = comments;
	}

	public static CommentListResponseDto of(Integer statusCode, String message, List<CommentListDto> comments) {
		CommentListResponseDto body = new CommentListResponseDto(statusCode, message, comments);
		return body;
	}
}
