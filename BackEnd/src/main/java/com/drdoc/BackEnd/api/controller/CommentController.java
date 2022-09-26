package com.drdoc.BackEnd.api.controller;

import java.io.IOException;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.CommentModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.CommentWriteRequestDto;
import com.drdoc.BackEnd.api.service.CommentService;
import com.drdoc.BackEnd.api.util.SecurityUtil;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(value = "커뮤니티 댓글 API", tags = { "Comment 관리" })
@RestController
@CrossOrigin("*")
@RequestMapping("/api/comment")
public class CommentController {

	@Autowired
	private CommentService commentService;

	@PostMapping
	@ApiOperation(value = "커뮤니티 댓글 등록", notes = "커뮤니티에 댓글을 등록합니다.")
	@ApiResponses({ @ApiResponse(code = 201, message = "댓글 등록에 성공했습니다."),
			@ApiResponse(code = 400, message = "입력이 잘못되었거나 입력 제한을 넘어갔습니다."),
			@ApiResponse(code = 401, message = "인증이 만료되어 로그인이 필요합니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> writeComment(
			@Valid @RequestBody CommentWriteRequestDto requestDto) throws IOException {
		String memberId = SecurityUtil.getCurrentUsername();
		commentService.writeComment(memberId, requestDto);
		return ResponseEntity.status(201).body(BaseResponseDto.of(201, "Created"));
	}
	
	@PutMapping("/{commentId}")
	@ApiOperation(value = "커뮤니티 댓글 수정", notes = "커뮤니티에 작성한 댓글을 수정합니다.")
	@ApiResponses({ @ApiResponse(code = 201, message = "댓글 수정에 성공했습니다."),
			@ApiResponse(code = 400, message = "입력이 잘못되었거나 입력 제한을 넘어갔습니다."),
			@ApiResponse(code = 401, message = "인증이 만료되어 로그인이 필요합니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> modifyComment(
			@PathVariable("commentId") int commentId, @Valid @RequestBody CommentModifyRequestDto requestDto) throws IOException {
		String memberId = SecurityUtil.getCurrentUsername();
		commentService.modifyComment(commentId, memberId, requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Modified"));
	}
}
