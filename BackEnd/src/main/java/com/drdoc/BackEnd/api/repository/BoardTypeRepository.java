package com.drdoc.BackEnd.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.drdoc.BackEnd.api.domain.BoardType;

public interface BoardTypeRepository extends JpaRepository<BoardType, Integer> {

}
