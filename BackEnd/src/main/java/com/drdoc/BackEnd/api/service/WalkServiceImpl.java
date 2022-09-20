package com.drdoc.BackEnd.api.service;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import com.drdoc.BackEnd.api.domain.dto.WalkBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkDetailDto;
import com.drdoc.BackEnd.api.domain.dto.WalkModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkRegisterRequestDto;
import com.drdoc.BackEnd.api.repository.WalkPetRepository;
import com.drdoc.BackEnd.api.repository.WalkRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WalkServiceImpl implements WalkService {
	private final WalkRepository walkRepository;
	private final WalkPetRepository walkPetRepository;

	 // 산책 기록 등록
	public void register(WalkRegisterRequestDto request) {
	}

	// 산책 기록 수정
	public void modify(Integer WalkId, WalkModifyRequestDto request) {
	}

	// 산책 기록 삭제
	public void delete(int WalkId) {
	}

	// 산책 기록 일괄 삭제
	public void batchDelete(WalkBatchDeleteRequestDto Walks) {
	}

	// 산책 기록 전체 조회
	public Page<WalkDetailDto> listAll() {
		return null;
	}
	
	// 산책 기록 상세 조회
	public WalkDetailDto detail(int WalkId) {
		return null;
	}
}
