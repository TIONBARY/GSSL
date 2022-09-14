package com.drdoc.BackEnd.api.service;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.JournalBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.JournalRequestDto;
import com.drdoc.BackEnd.api.domain.dto.JournalSelectionRequestDto;

public interface JournalService {

	// 일지 등록
	ResponseEntity<BaseResponseDto> register(JournalRequestDto request, MultipartFile file);

	// 일지 수정
	void modify(Integer journalId, JournalRequestDto request);

	// 일지 삭제
	void delete(JournalSelectionRequestDto journal);

	// 일지 일괄 삭제
	void batchDelete(JournalBatchDeleteRequestDto Journals);

	// 일지 전체 조회
	void listAll();
	
	// 일지 상세 조회
	void detail(JournalSelectionRequestDto journal);
}
