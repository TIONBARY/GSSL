package com.drdoc.BackEnd.api.controller;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.JournalBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.JournalDetailResponseDto;
import com.drdoc.BackEnd.api.domain.dto.JournalListResponseDto;
import com.drdoc.BackEnd.api.domain.dto.JournalRequestDto;
import com.drdoc.BackEnd.api.service.JournalService;
import com.drdoc.BackEnd.api.service.S3Service;

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

	@Autowired
	private S3Service s3Service;
	
	@Autowired
	private JournalService journalService;

	@ApiOperation(value = "일지 등록", notes = "사진, 부위, 증상, 상세 일지, 시작 날짜, (진단 결과, 치료 완료 여부, 완료 날짜) 입력 \r\n 1. 부위는 30자 이내\r\n"
			+ "2. 증상은 300자 이내\r\n" + "3. 사진, 부위, 증상, 상세 일지, 시작 날짜는 반드시 입력\r\n" + "4. 진단 결과, 치료 완료 여부, 완료 날짜는 선택 입력")
	@PostMapping
	@ApiResponses({ @ApiResponse(code = 201, message = "일지 등록"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> register(@RequestPart(value = "journal") @Valid JournalRequestDto requestDto,
			@RequestPart(value = "file", required = true) MultipartFile file, @ApiIgnore Errors errors) {
		try {
			if (file != null) {
				if (file.getSize() >= 10485760) {
					return ResponseEntity.status(HttpStatus.FORBIDDEN.value())
							.body(BaseResponseDto.of(HttpStatus.FORBIDDEN.value(), "이미지 크기 제한은 10MB 입니다."));
				}
				String originFile = file.getOriginalFilename();
				String originFileExtension = originFile.substring(originFile.lastIndexOf("."));
				if (!originFileExtension.equalsIgnoreCase(".jpg") && !originFileExtension.equalsIgnoreCase(".png")
						&& !originFileExtension.equalsIgnoreCase(".jpeg")) {
					return ResponseEntity.status(HttpStatus.FORBIDDEN.value())
							.body(BaseResponseDto.of(HttpStatus.FORBIDDEN.value(), "jpg, jpeg, png의 이미지 파일만 업로드해주세요."));
				}

				String imgPath = s3Service.upload(requestDto.getPicture(), file);
				requestDto.setPicture(imgPath);

				journalService.register(requestDto);
				
				return ResponseEntity.status(200).body(BaseResponseDto.of(201, "Created"));
			} else {
				return ResponseEntity.status(400).body(BaseResponseDto.of(400, "이미지 파일을 찾지 못 했습니다."));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "잘못된 요청입니다."));
		}
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
		journalService.modify(journalId, requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Modified"));
	}

	@ApiOperation(value = "일지 삭제", notes = "내가 작성한 일지 중에서 선택한 일지를 1개 삭제")
	@DeleteMapping("/{journalId}")
	@ApiResponses({ @ApiResponse(code = 200, message = "일지 삭제"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> delete(@PathVariable int journalId) {
		journalService.delete(journalId);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Deleted"));
	}

	@ApiOperation(value = "일지 일괄 삭제", notes = "내가 작성한 일지 중에서 선택한 일지를 여러개 삭제")
	@PostMapping("/delete")
	@ApiResponses({ @ApiResponse(code = 200, message = "일지 일괄 삭제"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> deleteSelected(@RequestBody @Valid JournalBatchDeleteRequestDto requestDto) {
		journalService.batchDelete(requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Deleted All"));
	}

	@ApiOperation(value = "일지 목록 조회", notes = "내가 작성한 일지를 모두 조회하여 썸네일 사진, 작성날짜 등을 출력")
	@GetMapping
	@ApiResponses({ @ApiResponse(code = 200, message = "일지 조회"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<JournalListResponseDto> getList() {
		return ResponseEntity.status(200).body(JournalListResponseDto.of(200, "Success", journalService.listAll()));
	}

	@ApiOperation(value = "일지 상세 조회", notes = "내가 작성한 일지를 조회하여 썸네일 사진, 작성날짜 등을 출력")
	@GetMapping("/{journalId}")
	@ApiResponses({ @ApiResponse(code = 200, message = "일지 조회"), @ApiResponse(code = 401, message = "인증이 필요합니다."),
			@ApiResponse(code = 403, message = "권한이 없습니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<JournalDetailResponseDto> getDetail(@PathVariable int journalId) {
		return ResponseEntity.status(200)
				.body(JournalDetailResponseDto.of(200, "Success", journalService.detail(journalId)));
	}

}
