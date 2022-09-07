package com.drdoc.BackEnd.api.service;

import java.util.Optional;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.drdoc.BackEnd.api.domain.User;
import com.drdoc.BackEnd.api.domain.dto.UserRegisterRequestDto;
import com.drdoc.BackEnd.api.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
	private final UserRepository repository;
	private final PasswordEncoder encoder;

	// 회원가입
	@Override
	public void register(UserRegisterRequestDto requestDto) {
		User user = User.builder().memberId(requestDto.getMember_id()).nickname(requestDto.getNickname())
				.password(encoder.encode(requestDto.getPassword().toLowerCase())).email(requestDto.getEmail())
				.phone(requestDto.getPhone()).gender(requestDto.getGender()).profilePic(requestDto.getProfile_pic())
				.introduce(requestDto.getIntroduce()).build();

		repository.save(user);
	}

	// 로그인
//    boolean login(UserRequest.Login login);

	// 회원 1명 조회
//    User findByMemberId(String memberId);

	// memberId 중복체크
	public boolean checkMemberId(String memberId) {
		Optional<User> user = repository.findByMemberId(memberId);
		return !user.isPresent();

	};

	// 닉네임 중복체크
	public boolean checkNickname(String nickname) {
		Optional<User> user = repository.findByNickname(nickname);
		return !user.isPresent();
	};

	// 회원정보 수정
//    void modify(User user); // dto로 추가예정

	// 비밀번호 수정
//    void modifyPassword(String memberId, String password);

	// 삭제
//    void delete(String memberId);

}
