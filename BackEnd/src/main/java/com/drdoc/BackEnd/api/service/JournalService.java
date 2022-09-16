package com.drdoc.BackEnd.api.service;

import org.springframework.data.domain.Page;

import com.drdoc.BackEnd.api.domain.dto.JournalBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.JournalDetailDto;
import com.drdoc.BackEnd.api.domain.dto.JournalRequestDto;
import com.drdoc.BackEnd.api.domain.dto.JournalThumbnailDto;

public interface JournalService {

	// 일지 등록
	void register(JournalRequestDto request);

	// 일지 수정
	void modify(Integer journalId, JournalRequestDto request);

	// 일지 삭제
	void delete(int journalId);

	// 일지 일괄 삭제
	void batchDelete(JournalBatchDeleteRequestDto Journals);

	// 일지 전체 조회
	Page<JournalThumbnailDto> listAll();
	
	// 일지 상세 조회
	JournalDetailDto detail(int journalId);
}
