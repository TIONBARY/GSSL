package com.drdoc.BackEnd.api.service;

import org.springframework.data.domain.Page;

import com.drdoc.BackEnd.api.domain.dto.WalkBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkDetailDto;
import com.drdoc.BackEnd.api.domain.dto.WalkModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkRegisterRequestDto;

public interface WalkService {

	// 산책 기록 등록
	void register(WalkRegisterRequestDto request);

	// 산책 기록 수정
	void modify(Integer WalkId, WalkModifyRequestDto request);

	// 산책 기록 삭제
	void delete(int WalkId);

	// 산책 기록 일괄 삭제
	void batchDelete(WalkBatchDeleteRequestDto Walks);

	// 산책 기록 전체 조회
	Page<WalkDetailDto> listAll();
	
	// 산책 기록 상세 조회
	WalkDetailDto detail(int WalkId);
}
