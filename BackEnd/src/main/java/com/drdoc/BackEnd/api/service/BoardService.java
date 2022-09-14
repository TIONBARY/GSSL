package com.drdoc.BackEnd.api.service;

import org.springframework.data.domain.Page;

import com.drdoc.BackEnd.api.domain.dto.BoardDetailDto;
import com.drdoc.BackEnd.api.domain.dto.BoardListDto;
import com.drdoc.BackEnd.api.domain.dto.BoardModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.BoardWriteRequestDto;

public interface BoardService {
	void writeBoard(String userId, BoardWriteRequestDto boardWriteRequestDto);
	void modifyBoard(int boardId, String userId, BoardModifyRequestDto boardModifyRequestDto);
	String getBoardImage(int boardId);
	void deleteBoard(int boardId, String userId);
	Page<BoardListDto> getBoardList(int typeId, int page, int size);
	BoardDetailDto getBoardDetail(int boardId);
}
