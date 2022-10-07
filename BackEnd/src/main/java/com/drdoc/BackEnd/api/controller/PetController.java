package com.drdoc.BackEnd.api.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.PetDetailResponseDto;
import com.drdoc.BackEnd.api.domain.dto.PetKindListDto;
import com.drdoc.BackEnd.api.domain.dto.PetKindListResponseDto;
import com.drdoc.BackEnd.api.domain.dto.PetKindResponseDto;
import com.drdoc.BackEnd.api.domain.dto.PetListResponseDto;
import com.drdoc.BackEnd.api.domain.dto.PetModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.PetRegisterRequestDto;
import com.drdoc.BackEnd.api.service.PetService;
import com.drdoc.BackEnd.api.service.S3Service;
import com.drdoc.BackEnd.api.util.SecurityUtil;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(value = "반려동물 API", tags = { "반려동물 관리" })
@RestController
@CrossOrigin("*")
@RequestMapping("/api/pet")
public class PetController {
	
	@Autowired
	private S3Service s3Service;
	
	@Autowired
	private PetService petService;
	
	@PostMapping
	@ApiOperation(value = "반려동물 정보 등록", notes = "반려동물 정보를 등록합니다.")
	@ApiResponses({
			@ApiResponse(code = 201, message = "반려동물 등록에 성공했습니다."),
			@ApiResponse(code = 400, message = "입력이 잘못되었거나 입력 제한을 넘어갔습니다."),
			@ApiResponse(code = 401, message = "인증이 만료되어 로그인이 필요합니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> registerPet(
			@Valid @RequestPart(value = "pet") PetRegisterRequestDto petRegisterRequestDto,
			@RequestPart(value = "file", required = false) MultipartFile file) {
		String memberId = SecurityUtil.getCurrentUsername();
		try {
			if (file != null) {
				if (file.getSize() >= 10485760) {
					return ResponseEntity.status(400).body(BaseResponseDto.of(400, "이미지 크기 제한은 10MB 입니다."));
				}
				String originFile = file.getOriginalFilename();
				String originFileExtension = originFile.substring(originFile.lastIndexOf("."));
				if (!originFileExtension.equalsIgnoreCase(".jpg") && !originFileExtension.equalsIgnoreCase(".png")
						&& !originFileExtension.equalsIgnoreCase(".jpeg")) {
					return ResponseEntity.status(400).body(BaseResponseDto.of(400, "jpg, jpeg, png의 이미지 파일만 업로드해주세요"));
				}
				String imgPath = s3Service.upload("", file);
				petRegisterRequestDto.setAnimal_pic(imgPath);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "파일 업로드에 실패했습니다."));
		}
		petService.registerPet(memberId, petRegisterRequestDto);
		return ResponseEntity.status(201).body(BaseResponseDto.of(201, "Created"));
	}

	@PutMapping("/{petId}")
	@ApiOperation(value = "반려동물 정보 수정", notes = "반려동물의 정보를 수정합니다.")
	@ApiResponses({
			@ApiResponse(code = 200, message = "반려동물 정보 수정에 성공했습니다."),
			@ApiResponse(code = 400, message = "입력이 잘못되었거나 입력 제한을 넘어갔습니다."),
			@ApiResponse(code = 401, message = "인증이 만료되어 로그인이 필요합니다."),
			@ApiResponse(code = 403, message = "게시글 수정 권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> modifyPet(@PathVariable("petId") int petId,
			@Valid @RequestPart(value = "pet") PetModifyRequestDto petModifyRequestDto,
			@RequestPart(value = "file", required = false) MultipartFile file) {
		String memberId = SecurityUtil.getCurrentUsername();
		try {
			if (file != null) {
				if (file.getSize() >= 10485760) {
					return ResponseEntity.status(400).body(BaseResponseDto.of(400, "이미지 크기 제한은 10MB 입니다."));
				}
				String originFile = file.getOriginalFilename();
				String originFileExtension = originFile.substring(originFile.lastIndexOf("."));
				if (!originFileExtension.equalsIgnoreCase(".jpg") && !originFileExtension.equalsIgnoreCase(".png")
						&& !originFileExtension.equalsIgnoreCase(".jpeg")) {
					return ResponseEntity.status(400).body(BaseResponseDto.of(400, "jpg, jpeg, png의 이미지 파일만 업로드해주세요"));
				}
				String imgPath = s3Service.upload("", file);
				petModifyRequestDto.setAnimal_pic(imgPath);
			} else {
				s3Service.delete(petService.getPetImage(petId));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "파일 업로드에 실패했습니다."));
		}
		petService.modifyPet(petId, memberId, petModifyRequestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Modified"));
	}
	
	@DeleteMapping("/{petId}")
	@ApiOperation(value = "반려동물 정보 삭제", notes = "반려동물 정보를 삭제합니다.")
	@ApiResponses({
			@ApiResponse(code = 200, message = "반려동물 정보 삭제에 성공했습니다."),
			@ApiResponse(code = 400, message = "입력이 잘못되었습니다."),
			@ApiResponse(code = 401, message = "인증이 만료되어 로그인이 필요합니다."),
			@ApiResponse(code = 403, message = "게시글 삭제 권한이 없습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> deletePet(@PathVariable("petId") int petId) throws IOException {
		String memberId = SecurityUtil.getCurrentUsername();
		String image = petService.getPetImage(petId);
		if (image != null && !"".equals(image)) {
			s3Service.delete(image);
		}
		petService.deletePet(petId, memberId);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Deleted"));
	}
	
	@GetMapping
	@ApiOperation(value = "반려동물 목록 조회", notes = "나의 반려동물 목록을 모두 조회합니다.")
	@ApiResponses({
		@ApiResponse(code = 200, message = "반려동물 목록 조회"),
		@ApiResponse(code = 400, message = "잘못된 요청입니다."),
		@ApiResponse(code = 401, message = "인증이 필요합니다."),
		@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<PetListResponseDto> getPetList() {
		String memberId = SecurityUtil.getCurrentUsername();
		return ResponseEntity.status(200).body(PetListResponseDto.of(200, "Success", petService.getPetList(memberId)));
	}
	
	@GetMapping("/{petId}")
	@ApiOperation(value = "반려동물 상세 조회", notes = "나의 반려동물을 상세 조회합니다.")
	@ApiResponses({
		@ApiResponse(code = 200, message = "반려동물 상세 조회"),
		@ApiResponse(code = 401, message = "인증이 필요합니다."),
		@ApiResponse(code = 403, message = "권한이 없습니다."),
		@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<PetDetailResponseDto> getDetail(@PathVariable int petId) {
		return ResponseEntity.status(200)
				.body(PetDetailResponseDto.of(200, "Success", petService.getPetDetail(petId)));
	}
	
	@GetMapping("/kind")
	@ApiOperation(value = "반려동물 품종 목록 조회", notes = "반려동물 품종 목록을 모두 조회합니다.")
	@ApiResponses({
		@ApiResponse(code = 200, message = "반려동물 목록 조회"),
		@ApiResponse(code = 400, message = "잘못된 요청입니다."),
		@ApiResponse(code = 401, message = "인증이 필요합니다."),
		@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<PetKindListResponseDto> getPetKindList() {
		return ResponseEntity.status(200).body(PetKindListResponseDto.of(200, "Success", petService.getPetKindList()));
	}
	
	@GetMapping("/kind/{kindId}")
	@ApiOperation(value = "반려동물 품종 번호 조회", notes = "반려동물 품종 번호에 해당하는 품종을 조회합니다.")
	@ApiResponses({
		@ApiResponse(code = 200, message = "반려동물 목록 조회"),
		@ApiResponse(code = 400, message = "잘못된 요청입니다."),
		@ApiResponse(code = 401, message = "인증이 필요합니다."),
		@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<PetKindResponseDto> getPetKind(@PathVariable("kindId") int kindId) {
		return ResponseEntity.status(200).body(PetKindResponseDto.of(200, "Success", petService.getPetKind(kindId)));
	}





}
