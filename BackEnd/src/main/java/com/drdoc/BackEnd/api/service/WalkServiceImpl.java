package com.drdoc.BackEnd.api.service;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.drdoc.BackEnd.api.domain.Pet;
import com.drdoc.BackEnd.api.domain.User;
import com.drdoc.BackEnd.api.domain.Walk;
import com.drdoc.BackEnd.api.domain.WalkPet;
import com.drdoc.BackEnd.api.domain.dto.WalkBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkDetailDto;
import com.drdoc.BackEnd.api.domain.dto.WalkModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkPetDetailDto;
import com.drdoc.BackEnd.api.domain.dto.WalkRegisterRequestDto;
import com.drdoc.BackEnd.api.domain.dto.WalkTimeDto;
import com.drdoc.BackEnd.api.repository.PetRepository;
import com.drdoc.BackEnd.api.repository.UserRepository;
import com.drdoc.BackEnd.api.repository.WalkPetRepository;
import com.drdoc.BackEnd.api.repository.WalkRepository;
import com.drdoc.BackEnd.api.util.SecurityUtil;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WalkServiceImpl implements WalkService {
	private final UserRepository userRepository;
	private final WalkRepository walkRepository;
	private final PetRepository petRepository;
	private final WalkPetRepository walkPetRepository;

	// 산책 기록 등록
	@Transactional
	public void register(WalkRegisterRequestDto request) {
		// 산책 테이블에 저장
		User user = getCurrentUser();
		Walk walk = new Walk(request, user);
		walkRepository.save(walk);

		// 산책동물 테이블에 저장
		for (int petId : request.getPet_ids()) {
			Pet pet = petRepository.findById(petId).get();
			WalkPet walkPet = new WalkPet(walk, pet);
			walkPetRepository.save(walkPet);
		}
	}

	// 산책 기록 수정
	@Transactional
	public void modify(Integer walkId, WalkModifyRequestDto request) {
		Walk walk = walkRepository.findById(walkId).get();

		User user = getCurrentUser();
		if (!walk.getUser().equals(user)) {
			new IllegalArgumentException("산책 기록에 접근 권한이 없습니다.");
		}
		// 산책동물 테이블에 저장된 정보 수정
		List<WalkPet> walkPetList = walkPetRepository.findByWalk(walk)
				.orElseThrow(() -> new IllegalArgumentException("해당 산책에 데려간 반려동물이 없습니다."));
		List<Integer> oldPetIds = walkPetList.stream().map(wp -> wp.getPet().getId()).collect(Collectors.toList());
		List<Integer> newPetIds = request.getPet_ids();

		// 기존 펫 제거
		for (int oldPetId : oldPetIds) {
			if (!newPetIds.contains(oldPetId)) {
				Pet pet = petRepository.findById(oldPetId)
						.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 반려동물입니다."));
				WalkPet walkPet = walkPetRepository.findFirstByWalkAndPet(walk, pet)
						.orElseThrow(() -> new IllegalArgumentException("해당 반려동물을 산책에 데려가지 않았습니다."));
				walkPetRepository.delete(walkPet);
			} else {
				newPetIds.remove((Integer) oldPetId);
			}
		}

		// 새 펫 추가
		for (int newPetId : newPetIds) {
			Pet pet = petRepository.findById(newPetId)
					.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 반려동물입니다."));
			WalkPet walkPet = new WalkPet(walk, pet);
			walkPetRepository.save(walkPet);
		}
	}

	// 산책 기록 삭제
	public void delete(int walkId) {
		walkRepository.findById(walkId).orElseThrow(() -> new IllegalArgumentException("산책 기록을 찾을 수 없습니다."));
		walkRepository.deleteById(walkId);
	}

	// 산책 기록 일괄 삭제
	public void batchDelete(WalkBatchDeleteRequestDto walks) {
		walkRepository.deleteAllByIdInBatch(walks.getWalk_ids());
	}

	// 산책 기록 전체 조회
	public Page<WalkDetailDto> listAll() {
		User user = getCurrentUser();
		Sort sort = Sort.by(Sort.Direction.DESC, "id");
		List<Walk> list = walkRepository.findByUser(user, sort).stream().collect(Collectors.toList());
		List<WalkDetailDto> result = list.stream().map(walk -> new WalkDetailDto(walk, getPetList(walk.getId())))
				.collect(Collectors.toList());
		return new PageImpl<>(result);
	}

	// 산책 기록 상세 조회
	public WalkDetailDto detail(int walkId) {
		Walk walk = walkRepository.findById(walkId).orElseThrow(() -> new IllegalArgumentException("산책 기록이 없습니다."));
		List<WalkPetDetailDto> petList = getPetList(walkId);
		return new WalkDetailDto(walk, petList);
	}

	public List<WalkPetDetailDto> getPetList(int walkId) {
		Walk walk = walkRepository.findById(walkId).orElseThrow(() -> new IllegalArgumentException("산책 기록이 없습니다."));
		List<WalkPet> walkPetList = walkPetRepository.findByWalk(walk)
				.orElseThrow(() -> new IllegalArgumentException("해당 산책에 데려간 반려동물이 없습니다."));
		List<WalkPetDetailDto> petList = walkPetList.stream().map(wp -> new WalkPetDetailDto(wp.getPet())).collect(Collectors.toList());
		return petList;
	}

	public User getCurrentUser() {
		String memberId = SecurityUtil.getCurrentUsername();
		Optional<User> user = userRepository.findByMemberId(memberId);
		return user.get();
	}

	@Override
	public boolean isDone(int petId) {
		Pet pet = petRepository.findById(petId).orElseThrow(() -> new IllegalArgumentException("해당 반려동물이 없습니다."));
		WalkPet lastHistory = walkPetRepository.findFirstByPetOrderByIdDesc(pet).orElseThrow(() -> new IllegalArgumentException("해당 반려동물의 산책기록이 없습니다."));
		Walk walk = lastHistory.getWalk();
		LocalDate finished = walk.getEnd_time().toLocalDate();
		if (finished.equals(LocalDate.now())) {
			return true;
		}
		return false;
	}

	@Override
	public WalkTimeDto walkTimeSum(int petId) {
		Pet pet = petRepository.findById(petId).orElseThrow(() -> new IllegalArgumentException("해당 반려동물이 없습니다."));
		List<WalkPet> walkPetList = walkPetRepository.findByPet(pet).orElseThrow(() -> new IllegalArgumentException("해당 반려동물의 오늘 산책기록이 없습니다."));
		int totalDistance = 0;
		int totalTimeSpent = 0;
		
		for (WalkPet wp : walkPetList) {
			Walk walk = wp.getWalk();
			totalDistance += walk.getDistance();
			Duration duration = Duration.between(walk.getEnd_time(), walk.getStart_time());
			totalTimeSpent += duration.getNano();
		}
		LocalDateTime sumTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(totalTimeSpent), ZoneOffset.UTC).minusYears(1970).minusDays(1);
		if (!LocalDateTime.ofInstant(Instant.ofEpochMilli(totalTimeSpent), ZoneOffset.UTC).isEqual(LocalDateTime.ofEpochSecond(0, 0, ZoneOffset.UTC))) {
			WalkTimeDto timeDto = new WalkTimeDto(sumTime, totalDistance);
			
			return timeDto;
		} else {
			return null;
		}
	}
}
