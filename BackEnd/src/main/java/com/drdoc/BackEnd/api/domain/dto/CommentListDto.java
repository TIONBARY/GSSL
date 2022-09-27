package com.drdoc.BackEnd.api.domain.dto;

import java.time.LocalDateTime;

import com.drdoc.BackEnd.api.domain.Comment;

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
public class CommentListDto {
	
	private int id;
	private String nickname;
	private String content;
	private LocalDateTime time;

	public CommentListDto(Comment comment) {
		this.id = comment.getId();
		this.nickname = comment.getUser().getNickname();
		this.content = comment.getContent();
		this.time = comment.getCreatedTime();
	}
}
