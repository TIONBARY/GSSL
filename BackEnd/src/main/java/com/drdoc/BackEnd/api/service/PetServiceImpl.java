package com.drdoc.BackEnd.api.service;

import java.util.List;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import com.drdoc.BackEnd.api.domain.Kind;
import com.drdoc.BackEnd.api.domain.Pet;
import com.drdoc.BackEnd.api.domain.User;
import com.drdoc.BackEnd.api.domain.dto.PetDetailDto;
import com.drdoc.BackEnd.api.domain.dto.PetKindListDto;
import com.drdoc.BackEnd.api.domain.dto.PetListDto;
import com.drdoc.BackEnd.api.domain.dto.PetModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.PetRegisterRequestDto;
import com.drdoc.BackEnd.api.repository.PetRepository;
import com.drdoc.BackEnd.api.repository.JournalRepository;
import com.drdoc.BackEnd.api.repository.PetKindRepository;
import com.drdoc.BackEnd.api.repository.UserRepository;
import com.drdoc.BackEnd.api.repository.WalkPetRepository;
import com.drdoc.BackEnd.api.repository.WalkRepository;

@Service
public class PetServiceImpl implements PetService {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private PetKindRepository petTypeRepository;

	@Autowired
	private PetRepository petRepository;
	
	@Autowired
	private JournalRepository journalRepository;

	@Override
	@Transactional
	public void registerPet(String userId, PetRegisterRequestDto petRegisterRequestDto) {
		User user = userRepository.findByMemberId(userId)
				.orElseThrow(() -> new IllegalArgumentException("가입하지 않은 계정입니다."));
		Kind kind = petTypeRepository.findById(petRegisterRequestDto.getKind_id())
				.orElseThrow(() -> new IllegalArgumentException("반려동물 품종 번호가 올바르지 않습니다."));
		;
		Pet pet = Pet.builder().user(user).kind(kind).species(petRegisterRequestDto.isSpecies())
				.name(petRegisterRequestDto.getName()).gender(petRegisterRequestDto.getGender())
				.neutralize(petRegisterRequestDto.isNeutralize()).birth(petRegisterRequestDto.getBirth())
				.weight(petRegisterRequestDto.getWeight()).animalPic(petRegisterRequestDto.getAnimal_pic())
				.death(petRegisterRequestDto.isDeath()).diseases(petRegisterRequestDto.getDiseases())
				.description(petRegisterRequestDto.getDescription()).build();
		petRepository.save(pet);
	}

	@Override
	@Transactional
	public void modifyPet(int petId, String userId, PetModifyRequestDto petModifyRequestDto) {
		User user = userRepository.findByMemberId(userId)
				.orElseThrow(() -> new IllegalArgumentException("가입하지 않은 계정입니다."));
		Pet pet = petRepository.findById(petId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 반려동물입니다."));
		Kind kind = petTypeRepository.findById(petModifyRequestDto.getKind_id())
				.orElseThrow(() -> new IllegalArgumentException("반려동물 품종 번호가 올바르지 않습니다."));
		;
		if (user.getId() != pet.getUser().getId())
			throw new AccessDeniedException("권한이 없습니다.");
		pet.modify(petModifyRequestDto, kind);
		petRepository.save(pet);

	}

	@Override
	@Transactional
	public String getPetImage(int petId) {
		Pet pet = petRepository.findById(petId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 반려동물입니다."));
		return pet.getAnimalPic();
	}

	@Override
	@Transactional
	public void deletePet(int petId, String userId) {
		User user = userRepository.findByMemberId(userId)
				.orElseThrow(() -> new IllegalArgumentException("가입하지 않은 계정입니다."));
		Pet pet = petRepository.findById(petId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 반려동물입니다."));
		if (user.getId() != pet.getUser().getId())
			throw new AccessDeniedException("권한이 없습니다.");
		petRepository.delete(pet);
		journalRepository.deleteByPetId(pet.getId());
	}

	@Override
	public List<PetListDto> getPetList(String memberId) {
		User user = userRepository.findByMemberId(memberId)
				.orElseThrow(() -> new IllegalArgumentException("가입하지 않은 계정입니다."));
		if (user.isLeft())
			throw new IllegalArgumentException("이미 탈퇴한 계정입니다.");
		List<PetListDto> petList = petRepository.findAllByUserId(user.getId());
		return petList;
	}

	@Override
	public PetDetailDto getPetDetail(int petId) {
		Pet pet = petRepository.findById(petId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 반려동물입니다."));
		PetDetailDto petdetailDto = PetDetailDto.builder().id(petId).kind_id(pet.getKind().getId())
				.species(pet.isSpecies()).name(pet.getName()).gender(pet.getGender()).neutralize(pet.isNeutralize())
				.birth(pet.getBirth()).weight(pet.getWeight()).animal_pic(pet.getAnimalPic()).death(pet.isDeath())
				.diseases(pet.getDiseases()).description(pet.getDescription()).build();
		return petdetailDto;
	}

	@Override
	public List<PetKindListDto> getPetKindList() {
		List<PetKindListDto> list = petTypeRepository.findAll()
				.stream().map(PetKindListDto::new).collect(Collectors.toList());
		return list;
	}

	@Override
	public PetKindListDto getPetKind(int kindId) {
		Kind kind = petTypeRepository.findById(kindId)
				.orElseThrow(() -> new IllegalArgumentException("잘못된 품종 번호입니다."));
		return new PetKindListDto(kind);
	}

}
