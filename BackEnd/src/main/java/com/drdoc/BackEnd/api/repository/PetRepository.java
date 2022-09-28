package com.drdoc.BackEnd.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.drdoc.BackEnd.api.domain.Pet;
import com.drdoc.BackEnd.api.domain.dto.PetListDto;

@Repository
public interface PetRepository extends JpaRepository<Pet, Integer> {
	 List<PetListDto> findAllByUserId(int userId);
}
