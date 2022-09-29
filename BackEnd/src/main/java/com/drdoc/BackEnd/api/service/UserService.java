package com.drdoc.BackEnd.api.service;

import com.drdoc.BackEnd.api.domain.dto.RefreshTokenDto;
import com.drdoc.BackEnd.api.domain.dto.TokenDto;
import com.drdoc.BackEnd.api.domain.dto.UserInfoDto;
import com.drdoc.BackEnd.api.domain.dto.UserLoginRequestDto;
import com.drdoc.BackEnd.api.domain.dto.UserModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.UserRegisterRequestDto;

public interface UserService {
    //회원가입
	void register(UserRegisterRequestDto user);

    //로그인
	TokenDto login(UserLoginRequestDto userLoginRequestDto);

    //memberId 중복체크
    boolean checkMemberId(String memberId);
	
    //닉네임 중복체크
    boolean checkNickname(String nickname);
    
    // 회원정보 조회
    UserInfoDto getUserDetail(String memberId);

    // 회원정보 수정
    void modify(String memberId, UserModifyRequestDto requestDto);
    
    // 메인 반려동물 수정
    void modifyPet(String memberId, int petId);

    //로그아웃
    void logout(String refresh_token);
	
    TokenDto reissue(RefreshTokenDto tokenRequestDto);

	String getProfilePicture(String memberId);
	
	void checkModifyDuplication(String memberId, UserModifyRequestDto requestDto);
	
	void checkDuplication(UserRegisterRequestDto requestDto);
	
	void quit(String memberId);

}
