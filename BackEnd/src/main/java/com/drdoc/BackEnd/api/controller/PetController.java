package com.drdoc.BackEnd.api.controller;

import java.io.IOException;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.PetModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.PetRegisterRequestDto;
import com.drdoc.BackEnd.api.service.PetService;
import com.drdoc.BackEnd.api.service.S3Service;
import com.drdoc.BackEnd.api.util.SecurityUtil;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import springfox.documentation.annotations.ApiIgnore;

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
			petService.registerPet(memberId, petRegisterRequestDto);
			return ResponseEntity.status(201).body(BaseResponseDto.of(201, "Created"));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "파일 업로드에 실패했습니다."));
		}
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
			petService.modifyPet(petId, memberId, petModifyRequestDto);
			return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Modified"));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "파일 업로드에 실패했습니다."));
		}
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



}
