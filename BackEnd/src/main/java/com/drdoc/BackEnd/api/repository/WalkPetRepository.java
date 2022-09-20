package com.drdoc.BackEnd.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.drdoc.BackEnd.api.domain.Pet;
import com.drdoc.BackEnd.api.domain.Walk;
import com.drdoc.BackEnd.api.domain.WalkPet;

@Repository
public interface WalkPetRepository extends JpaRepository<WalkPet, Integer> {
	WalkPet findFirstByWalkAndPet(Walk walk, Pet pet);
	List<WalkPet> findByWalk(Walk walk);

}
