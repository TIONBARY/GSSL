package com.drdoc.BackEnd.api.controller;

import java.util.List;

import javax.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.JournalRequestDto;
import com.drdoc.BackEnd.api.service.JournalService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import springfox.documentation.annotations.ApiIgnore;

@Api(value = "일지 API", tags = { "일지 관리" })
@RestController
@CrossOrigin("*")
@RequestMapping("/api/journal")
@RequiredArgsConstructor
public class JournalController {

	private final JournalService journalService;

	@ApiOperation(value = "일지 등록", notes = "사진, 부위, 증상, 상세 일지, 시작 날짜, (진단 결과, 치료 완료 여부, 완료 날짜) 입력 \r\n 1. 부위는 30자 이내\r\n"
			+ "2. 증상은 300자 이내\r\n" + "3. 사진, 부위, 증상, 상세 일지, 시작 날짜는 반드시 입력\r\n" + "4. 진단 결과, 치료 완료 여부, 완료 날짜는 선택 입력")
	@PostMapping
	@ApiResponses({ @ApiResponse(code = 201, message = "일지 등록"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> register(@RequestPart(value = "Journal") @Valid JournalRequestDto requestDto,
			@RequestPart(value = "file", required = true) MultipartFile file, @ApiIgnore Errors errors) {

		if (errors.hasErrors()) {
			List<ObjectError> errorMessages = errors.getAllErrors();

			for (ObjectError objectError : errorMessages) {
				System.err.println(objectError.getDefaultMessage());
			}

			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "잘못된 요청입니다."));
		}

		return journalService.register(requestDto, file);
	}

	@ApiOperation(value = "일지 수정", notes = "사진, 부위, 증상, 상세 일지, 시작 날짜, (진단 결과, 치료 완료 여부, 완료 날짜) 입력 \r\n \"1. 부위는 30자 이내\r\n"
			+ "2. 증상은 300자 이내\r\n" + "3. 사진, 부위, 증상, 상세 일지, 시작 날짜는 반드시 입력\r\n" + "4. 진단 결과, 치료 완료 여부, 완료 날짜는 선택 입력\r\n"
			+ "5. 작성 날짜는 수정 시 현재 날짜로 수정")
	@PostMapping("/{journalId}")
	@ApiResponses({ @ApiResponse(code = 201, message = "일지 수정"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> modify(@PathVariable int journalId,
			@RequestBody @Valid JournalRequestDto requestDto, @ApiIgnore Errors errors) {
		System.out.println(requestDto);
		if (errors.hasErrors()) {
			List<ObjectError> errorMessages = errors.getAllErrors();

			for (ObjectError objectError : errorMessages) {
				System.err.println(objectError.getDefaultMessage());
			}

			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "잘못된 요청입니다."));
		}
		journalService.modify(journalId, requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Success"));
	}

}
