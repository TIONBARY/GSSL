package com.drdoc.BackEnd.api.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import com.drdoc.BackEnd.api.domain.Pet;
import com.drdoc.BackEnd.api.domain.Walk;
import com.drdoc.BackEnd.api.domain.WalkPet;
import com.drdoc.BackEnd.api.domain.dto.WalkBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkDetailDto;
import com.drdoc.BackEnd.api.domain.dto.WalkModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkRegisterRequestDto;
import com.drdoc.BackEnd.api.repository.PetRepository;
import com.drdoc.BackEnd.api.repository.WalkPetRepository;
import com.drdoc.BackEnd.api.repository.WalkRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WalkServiceImpl implements WalkService {
	private final WalkRepository walkRepository;
	private final PetRepository petRepository;
	private final WalkPetRepository walkPetRepository;

	// 산책 기록 등록
	public void register(WalkRegisterRequestDto request) {
		// 산책 테이블에 저장
		Walk walk = new Walk(request);
		walkRepository.save(walk);

		// 산책동물 테이블에 저장
		for (int petId : request.getPet_ids()) {
			Pet pet = petRepository.findById(petId).get();
			WalkPet walkPet = new WalkPet(walk, pet);
			walkPetRepository.save(walkPet);
		}
	}

	// 산책 기록 수정
	public void modify(Integer walkId, WalkModifyRequestDto request) {
		Walk walk = walkRepository.findById(walkId).get();
		// 산책동물 테이블에 저장된 정보 수정
		List<WalkPet> walkPetList = walkPetRepository.findByWalk(walk);
		List<Integer> oldPetIds = walkPetList.stream().map(wp -> wp.getPet().getId()).collect(Collectors.toList());
		List<Integer> newPetIds = request.getPet_ids();
		
		// 기존 펫 제거
		for (int oldPetId : oldPetIds) {
			if (!newPetIds.contains(oldPetId)) {
				Pet pet = petRepository.findById(oldPetId).get();
				WalkPet walkPet = walkPetRepository.findFirstByWalkAndPet(walk, pet);
				walkPetRepository.delete(walkPet);
			} else {
				newPetIds.remove((Integer) oldPetId);
			}
		}

		// 새 펫 추가
		for (int newPetId : newPetIds) {
			Pet pet = petRepository.findById(newPetId).get();
			WalkPet walkPet = new WalkPet(walk, pet);
			walkPetRepository.save(walkPet);
		}
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
