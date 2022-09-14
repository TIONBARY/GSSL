package com.drdoc.BackEnd.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.drdoc.BackEnd.api.domain.Board;

public interface BoardRepository extends JpaRepository<Board, Integer> {

}
