package com.drdoc.BackEnd.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.drdoc.BackEnd.api.domain.WalkPet;

@Repository
public interface WalkPetRepository extends JpaRepository<WalkPet, Integer>{

}
