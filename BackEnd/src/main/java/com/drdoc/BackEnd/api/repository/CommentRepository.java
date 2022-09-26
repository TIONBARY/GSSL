package com.drdoc.BackEnd.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.drdoc.BackEnd.api.domain.Comment;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
	List<Comment> findByBoardId(int boardId);
}
