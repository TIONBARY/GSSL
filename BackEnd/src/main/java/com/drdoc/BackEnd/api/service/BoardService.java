package com.drdoc.BackEnd.api.service;

import com.drdoc.BackEnd.api.domain.dto.BoardModifyRequestDto;
import com.drdoc.BackEnd.api.domain.dto.BoardWriteRequestDto;

public interface BoardService {
	void writeBoard(String userId, BoardWriteRequestDto boardWriteRequestDto);
	void modifyBoard(int boardId, String userId, BoardModifyRequestDto boardModifyRequestDto);
	String getBoardImage(int boardId);
	void deleteBoard(int boardId, String userId);
}
