package com.drdoc.BackEnd.api.service;

import com.drdoc.BackEnd.api.domain.dto.BoardWriteRequestDto;

public interface BoardService {
	void writeBoard(String userId, BoardWriteRequestDto boardWriteRequestDto);
}
