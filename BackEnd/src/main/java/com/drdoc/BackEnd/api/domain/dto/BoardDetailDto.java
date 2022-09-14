package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;

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
public class BoardDetailDto {

	private int id;
	private String nickname;
	private int type_id;
	private String title;
	private String image;
	private String content;
	private LocalDateTime time;
	private int views;

	public BoardDetailDto(Board board) {
		this.id = board.getId();
		this.nickname = board.getUser().getNickname();
		this.type_id = board.getType().getId();
		this.title = board.getTitle();
		this.image = board.getImage();
		this.content = board.getContent();
		this.time = board.getCreatedTime();
		this.views = board.getViews();
	}

}
