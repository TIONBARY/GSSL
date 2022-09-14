package com.drdoc.BackEnd.api.domain;

import java.time.LocalDateTime;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.ColumnDefault;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "board")
@Entity
@Builder
public class Board {
	
	@Id
	@Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
	
	@ManyToOne
	@JoinColumn(name = "user_id")
	private User user;
	
	@ManyToOne
	@JoinColumn(name = "type_id")
	private BoardType type;
	
	@Column(name = "title", length = 20, nullable = false)
	private String title;
	
	@Column(name = "image", length = 256, nullable = true)
	private String image;
	
	@Column(name = "content", length = 1000, nullable = false)
	private String content;
	
	@Column(name = "created_time", nullable = false)
	private LocalDateTime createdTime;
	
	@Column(name = "views", nullable = false)
	@ColumnDefault("0")
	private int views;
	
	@OneToMany(mappedBy = "board")
	private List<Comment> comments;
	
}
