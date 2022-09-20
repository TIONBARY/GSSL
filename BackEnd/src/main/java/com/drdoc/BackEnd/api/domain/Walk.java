package com.drdoc.BackEnd.api.domain;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import com.drdoc.BackEnd.api.domain.dto.WalkRegisterRequestDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "walk")
@Entity
@Builder
public class Walk {

	@Id
	@Column(name = "id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(name = "distance", nullable = false)
	private int distance;

	@Column(name = "start_time", nullable = false)
	private LocalDateTime start_time;

	@Column(name = "end_time", nullable = false)
	private LocalDateTime end_time;

	@Builder
	public Walk(WalkRegisterRequestDto request) {
		this.start_time = request.getStart_time();
		this.end_time = request.getEnd_time();
		this.distance = request.getDistance();
	}

	public void modify(WalkRegisterRequestDto request) {
		this.start_time = request.getStart_time();
		this.end_time = request.getEnd_time();
		this.distance = request.getDistance();
	}

}