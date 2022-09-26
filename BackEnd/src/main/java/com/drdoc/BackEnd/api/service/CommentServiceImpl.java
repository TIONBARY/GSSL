package com.drdoc.BackEnd.api.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import com.drdoc.BackEnd.api.domain.Board;
import com.drdoc.BackEnd.api.domain.Comment;
import com.drdoc.BackEnd.api.domain.User;
import com.drdoc.BackEnd.api.domain.dto.CommentListDto;
import com.drdoc.BackEnd.api.domain.dto.CommentModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.CommentWriteRequestDto;
import com.drdoc.BackEnd.api.repository.BoardRepository;
import com.drdoc.BackEnd.api.repository.CommentRepository;
import com.drdoc.BackEnd.api.repository.UserRepository;

@Service
public class CommentServiceImpl implements CommentService {
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private CommentRepository commentRepository;

	@Override
	public void writeComment(String memberId, CommentWriteRequestDto requestDto) {
		User user = userRepository.findByMemberId(memberId)
				.orElseThrow(() -> new IllegalArgumentException("가입하지 않은 계정입니다."));
		Board board = boardRepository.findById(requestDto.getBoard_id())
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 게시글입니다."));
		Comment comment = Comment.builder().user(user).board(board).
				content(requestDto.getContent()).createdTime(LocalDateTime.now()).build();
		commentRepository.save(comment);
	}

	@Override
	public void modifyComment(int commentId, String memberId, CommentModifyRequestDto requestDto) {
		User user = userRepository.findByMemberId(memberId)
				.orElseThrow(() -> new IllegalArgumentException("가입하지 않은 계정입니다."));
		Comment comment = commentRepository.findById(commentId)
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 댓글입니다."));
		if (user.getId() != comment.getUser().getId())
			throw new AccessDeniedException("권한이 없습니다.");
		comment.modify(requestDto.getContent());
		commentRepository.save(comment);
	}

	@Override
	public void deleteComment(int commentId, String memberId) {
		// TODO Auto-generated method stub

	}

	@Override
	public List<CommentListDto> getCommentList(int boardId) {
		// TODO Auto-generated method stub
		return null;
	}

}
