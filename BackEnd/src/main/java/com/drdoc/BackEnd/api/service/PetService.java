package com.drdoc.BackEnd.api.service;

import java.util.List;

import com.drdoc.BackEnd.api.domain.dto.PetDetailDto;
import com.drdoc.BackEnd.api.domain.dto.PetKindListDto;
import com.drdoc.BackEnd.api.domain.dto.PetListDto;
import com.drdoc.BackEnd.api.domain.dto.PetModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.PetRegisterRequestDto;

public interface PetService {
	void registerPet(String userId, PetRegisterRequestDto petRegisterRequestDto);
	void modifyPet(int petId, String userId, PetModifyRequestDto petModifyRequestDto);
	String getPetImage(int petId);
	void deletePet(int petId, String userId);
	List<PetListDto> getPetList(String memberId);
	PetDetailDto getPetDetail(int petId);
	List<PetKindListDto> getPetKindList();



}
