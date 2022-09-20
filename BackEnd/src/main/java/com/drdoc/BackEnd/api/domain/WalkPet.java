package com.drdoc.BackEnd.api.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "walkPet")
@Entity
@Builder
@Data
public class WalkPet {

	@Id
	@Column(name = "id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@ManyToOne
    @OnDelete(action= OnDeleteAction.CASCADE)
	@JoinColumn(name = "petId", nullable = false)
	private Pet pet;

	@ManyToOne
    @OnDelete(action= OnDeleteAction.CASCADE)
	@JoinColumn(name = "walkId", nullable = false)
	private Walk walk;

	@Builder
	public WalkPet(Walk walk, Pet pet) {
		this.pet = pet;
		this.walk = walk;
	}

	public void modify(Walk walk, Pet pet) {
		this.pet = pet;
		this.walk = walk;
	}

}