package com.drdoc.BackEnd.api.controller;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.WalkBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkDetailResponseDto;
import com.drdoc.BackEnd.api.domain.dto.WalkDoneResponseDto;
import com.drdoc.BackEnd.api.domain.dto.WalkListResponseDto;
import com.drdoc.BackEnd.api.domain.dto.WalkModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkRegisterRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkTimeResponseDto;
import com.drdoc.BackEnd.api.service.WalkService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import springfox.documentation.annotations.ApiIgnore;

@Api(value = "산책 API", tags = { "산책 기록 관리" })
@RestController
@CrossOrigin("*")
@RequestMapping("/api/walk")
@RequiredArgsConstructor
public class WalkController {

	@Autowired
	private WalkService walkService;

	@ApiOperation(value = "산책 기록 등록", notes = "반려동물의 산책정보 등록(날짜랑 거리(m단위) 정보 필요)")
	@PostMapping
	@ApiResponses({ @ApiResponse(code = 201, message = "산책 기록 등록"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> register(@RequestBody @Valid WalkRegisterRequestDto requestDto,
			@ApiIgnore Errors errors) {
		walkService.register(requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(201, "Created"));
	}

	@ApiOperation(value = "산책 기록 수정", notes = "반려동물의 산책정보 수정(반려동물의 산책정보 중 반려동물 목록만 수정 가능)")
	@PostMapping("/{walkId}")
	@ApiResponses({ @ApiResponse(code = 201, message = "산책 기록 수정"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> modify(@PathVariable int walkId,
			@RequestBody @Valid WalkModifyRequestDto requestDto, @ApiIgnore Errors errors) {
		walkService.modify(walkId, requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Modified"));
	}

	@ApiOperation(value = "산책 기록 삭제", notes = "내가 작성한 산책 기록 중에서 선택한 산책 기록를 1개 삭제")
	@DeleteMapping("/{walkId}")
	@ApiResponses({ @ApiResponse(code = 200, message = "산책 기록 삭제"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> delete(@PathVariable int walkId) {
		walkService.delete(walkId);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Deleted"));
	}

	@ApiOperation(value = "산책 기록 일괄 삭제", notes = "현재 로그인 된 유저의 모든 반려동물의 산책정보 중  선택한 정보들 여러개를 일괄 삭제")
	@PostMapping("/delete")
	@ApiResponses({ @ApiResponse(code = 200, message = "산책 기록 일괄 삭제"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 403, message = "권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> deleteSelected(@RequestBody @Valid WalkBatchDeleteRequestDto requestDto) {
		walkService.batchDelete(requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Deleted All"));
	}

	@ApiOperation(value = "산책 기록 목록 조회", notes = "나의 반려동물 산책 정보를 전부 조회")
	@GetMapping
	@ApiResponses({ @ApiResponse(code = 200, message = "산책 기록 조회"), @ApiResponse(code = 400, message = "잘못된 요청입니다."),
			@ApiResponse(code = 401, message = "인증이 필요합니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<WalkListResponseDto> getList() {
		return ResponseEntity.status(200).body(WalkListResponseDto.of(200, "Success", walkService.listAll()));
	}

	@ApiOperation(value = "산책 기록 상세 조회", notes = "내가 작성한 산책 기록을 상세 조회")
	@GetMapping("/{walkId}")
	@ApiResponses({ @ApiResponse(code = 200, message = "산책 기록 조회"), @ApiResponse(code = 401, message = "인증이 필요합니다."),
			@ApiResponse(code = 403, message = "권한이 없습니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<WalkDetailResponseDto> getDetail(@PathVariable int walkId) {
		return ResponseEntity.status(200)
				.body(WalkDetailResponseDto.of(200, "Success", walkService.detail(walkId)));
	}

	@ApiOperation(value = "산책 전체 시간/거리 조회", notes = "현재 반려동물의 산책 기록을 합하여 총 산책 시간과 거리를 조회")
	@GetMapping("/total/{petId}")
	@ApiResponses({ @ApiResponse(code = 200, message = "산책 시간 조회"), @ApiResponse(code = 401, message = "인증이 필요합니다."),
			@ApiResponse(code = 403, message = "권한이 없습니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<WalkTimeResponseDto> getTotalInfo(@PathVariable("petId") int petId) {
		return ResponseEntity.status(200)
				.body(WalkTimeResponseDto.of(200, "Success", walkService.walkTimeSum(petId)));
	}

	@ApiOperation(value = "오늘 산책 여부 조회", notes = "오늘 산책 했는지 여부 조회(반려동물 단위)")
	@GetMapping("/done/{petId}")
	@ApiResponses({ @ApiResponse(code = 200, message = "산책 기록 조회"), @ApiResponse(code = 401, message = "인증이 필요합니다."),
			@ApiResponse(code = 403, message = "권한이 없습니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<WalkDoneResponseDto> isTodayDone(@PathVariable("petId") int petId) {

		
		return ResponseEntity.status(200)
				.body(WalkDoneResponseDto.of(200, "Success", walkService.isDone(petId)));
	}

}
