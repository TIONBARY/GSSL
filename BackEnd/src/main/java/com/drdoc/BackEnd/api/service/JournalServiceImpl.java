package com.drdoc.BackEnd.api.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.Journal;
import com.drdoc.BackEnd.api.domain.User;
import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.JournalBatchDeleteRequestDto;
import com.drdoc.BackEnd.api.domain.dto.JournalDetailDto;
import com.drdoc.BackEnd.api.domain.dto.JournalListResponseDto;
import com.drdoc.BackEnd.api.domain.dto.JournalRequestDto;
import com.drdoc.BackEnd.api.repository.JournalRepository;
import com.drdoc.BackEnd.api.repository.UserRepository;
import com.drdoc.BackEnd.api.util.SecurityUtil;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JournalServiceImpl implements JournalService {
	private final JournalRepository repository;
	private final UserRepository userRepository;
	private final S3Service s3Service;

	// 일지 등록
	@Override
	public ResponseEntity<BaseResponseDto> register(JournalRequestDto request, MultipartFile file) {
		try {
			if (file != null) {
				if (file.getSize() >= 10485760) {
					return ResponseEntity.status(HttpStatus.FORBIDDEN.value())
							.body(BaseResponseDto.of(HttpStatus.FORBIDDEN.value(), "이미지 크기 제한은 10MB 입니다."));
				}
				String originFile = file.getOriginalFilename();
				String originFileExtension = originFile.substring(originFile.lastIndexOf("."));
				if (!originFileExtension.equalsIgnoreCase(".jpg") && !originFileExtension.equalsIgnoreCase(".png")
						&& !originFileExtension.equalsIgnoreCase(".jpeg")) {
					return ResponseEntity.status(HttpStatus.FORBIDDEN.value())
							.body(BaseResponseDto.of(HttpStatus.FORBIDDEN.value(), "jpg, jpeg, png의 이미지 파일만 업로드해주세요."));
				}

				String imgPath = s3Service.upload(request.getPicture(), file);
				User user = getCurrentUser();
				request.setPicture(imgPath);

				Journal journal = new Journal(request, user);
				repository.save(journal);
				return ResponseEntity.status(200).body(BaseResponseDto.of(201, "Created"));
			} else {
				return ResponseEntity.status(400).body(BaseResponseDto.of(400, "이미지 파일을 찾지 못 했습니다."));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "잘못된 요청입니다."));
		}

	}

	// 일지 수정
	@Override
	@Transactional
	public void modify(Integer journalId, JournalRequestDto request) {
		Journal journal = repository.findById(journalId)
				.orElseThrow(() -> new IllegalArgumentException("일지를 찾을 수 없습니다."));
		if (checkOwner(journal)) {
			journal.modify(request);
		};
	}

	// 일지 삭제
	@Override
	@Transactional
	public void delete(int journalId) {
		Journal journal = repository.findById(journalId)
				.orElseThrow(() -> new IllegalArgumentException("일지를 찾을 수 없습니다."));
		if (checkOwner(journal)) {
			repository.deleteById(journalId);
		};
	}

	// 일지 일괄 삭제
	@Override
	@Transactional
	public void batchDelete(JournalBatchDeleteRequestDto Journals) {
		repository.deleteAllByIdInBatch(Journals.getJournal_ids());
	}

	// 일지 전체 조회
	@Override
	public JournalListResponseDto listAll() {
		User user = getCurrentUser();
        Sort sort = Sort.by(Sort.Direction.DESC, "id");
		JournalListResponseDto result = new JournalListResponseDto();
		List<Journal> list = repository.findByUserId(user.getId(), sort);
		result.setJournalList(list);
		return result;

	}

	// 일지 상세 조회
	@Override
	public JournalDetailDto detail(int journalId) {
		return null;

	}
	
	public boolean checkOwner(Journal journal) {
		String memberId = SecurityUtil.getCurrentUsername();
		Optional<User> user = userRepository.findByMemberId(memberId);
		if (user.get().equals(journal.getUser()) && !memberId.isEmpty()) {
			return true;
		} 
		return false;
	}
	
	public User getCurrentUser() {
		String memberId = SecurityUtil.getCurrentUsername();
		Optional<User> user = userRepository.findByMemberId(memberId);
		return user.get();
	}
}
