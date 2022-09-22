package com.drdoc.BackEnd.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.drdoc.BackEnd.api.domain.Pet;
import com.drdoc.BackEnd.api.domain.Walk;
import com.drdoc.BackEnd.api.domain.WalkPet;

@Repository
public interface WalkPetRepository extends JpaRepository<WalkPet, Integer> {
	Optional<WalkPet> findFirstByWalkAndPet(Walk walk, Pet pet);
	Optional<List<WalkPet>> findByWalk(Walk walk);

}
