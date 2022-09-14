package com.drdoc.BackEnd.api.controller;

import java.io.IOException;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.BoardWriteRequestDto;
import com.drdoc.BackEnd.api.service.BoardService;
import com.drdoc.BackEnd.api.service.S3Service;
import com.drdoc.BackEnd.api.util.SecurityUtil;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "커뮤니티 API", tags = { "Board 관리" })
@RestController
@CrossOrigin("*")
@RequestMapping("/api/board")
public class BoardController {
	
	@Autowired
	private S3Service s3Service;
	
	@Autowired
	private BoardService boardService;
	
	
	
	@PostMapping
	@ApiOperation(value = "커뮤니티 게시글 등록", notes = "커뮤니티에 게시글을 등록합니다.")
	public ResponseEntity<BaseResponseDto> writeBoard(@Valid @RequestPart(value = "board") BoardWriteRequestDto requestDto, @RequestPart(value = "file", required = false) MultipartFile file) throws IOException {
		String memberId = SecurityUtil.getCurrentUsername();
		try {
			System.out.println(file);
			if(file != null) {
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
				System.out.println(imgPath);
				requestDto.setImage(imgPath);
			}
			boardService.writeBoard(memberId, requestDto);
			return ResponseEntity.status(201).body(BaseResponseDto.of(201, "Created"));
		} catch (Exception e){
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "파일 업로드에 실패했습니다."));
		}
	}
}
