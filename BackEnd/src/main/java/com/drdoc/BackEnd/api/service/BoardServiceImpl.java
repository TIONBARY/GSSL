package com.drdoc.BackEnd.api.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.drdoc.BackEnd.api.domain.Board;
import com.drdoc.BackEnd.api.domain.BoardType;
import com.drdoc.BackEnd.api.domain.User;
import com.drdoc.BackEnd.api.domain.dto.BoardWriteRequestDto;
import com.drdoc.BackEnd.api.repository.BoardRepository;
import com.drdoc.BackEnd.api.repository.BoardTypeRepository;
import com.drdoc.BackEnd.api.repository.UserRepository;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private BoardTypeRepository boardTypeRepository;
	
	@Autowired
	private BoardRepository boardRepository;
	
	@Override
	@Transactional
	public void writeBoard(String userId, BoardWriteRequestDto boardWriteRequestDto) {
		Optional<User> opUser = userRepository.findByMemberId(userId);
		if (!opUser.isPresent()) throw new IllegalArgumentException("가입하지 않은 계정입니다.");
		Optional<BoardType> opBoardType = boardTypeRepository.findById(boardWriteRequestDto.getType_id());
		if (!opBoardType.isPresent()) throw new IllegalArgumentException("게시글 유형 번호가 올바르지 않습니다.");
		User user = opUser.get();
		BoardType boardType = opBoardType.get();
		Board board = Board.builder()
				.user(user)
				.type(boardType)
				.title(boardWriteRequestDto.getTitle())
				.content(boardWriteRequestDto.getContent())
				.image(boardWriteRequestDto.getImage())
				.createdTime(LocalDateTime.now())
				.comments(new ArrayList<>())
				.build();
		boardRepository.save(board);
	}

}
