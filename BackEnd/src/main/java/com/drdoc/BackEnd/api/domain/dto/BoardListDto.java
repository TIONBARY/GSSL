package com.drdoc.BackEnd.api.domain.dto;

import com.drdoc.BackEnd.api.domain.Board;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BoardListDto {

	private int id;
	private String nickname;
	private String title;
	private String image;

	public BoardListDto(Board board) {
		this.id = board.getId();
		this.nickname = board.getUser().getNickname();
		this.title = board.getTitle();
		this.image = board.getImage();
	}

}
