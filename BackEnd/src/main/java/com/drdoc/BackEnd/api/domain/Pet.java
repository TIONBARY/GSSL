package com.drdoc.BackEnd.api.domain;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "pet")
@Entity
@Builder
public class Pet {
	
	@Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
	
	@ManyToOne
	@JoinColumn(name = "user_id")
	private User user;

	@ManyToOne
	@JoinColumn(name = "kine_id")
	private Kind kind;
	
	@Column(name = "species", nullable = false)
	private boolean species;
	
	@Column(name = "name", nullable = false, length = 10)
    private String name;
	
    @Column(name = "gender", nullable = false, length = 1)
    private String gender;
    
    @Column(name = "neutralize", nullable = false)
    private boolean neutralize;
    
    @Column(name = "birth", nullable = false)
    private LocalDateTime birth;
    
    @Column(name = "weight", nullable = true)
    private float weight;
    
    @Column(name = "animalPic", nullable = true, length = 256)
    private String animalPic;
    
    @Column(name = "death", nullable = false, columnDefinition = "boolean default false")
    private boolean death;
    
    @Column(name = "diseases", nullable = true, length = 15)
    private String diseases;
    
    @Column(name = "description", nullable = true, length = 50)
    private String description;

}
