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

import org.hibernate.annotations.CreationTimestamp;

import com.drdoc.BackEnd.api.domain.dto.JournalRequestDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "journal")
@Entity
@Builder
public class Journal {
	
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

	@ManyToOne
	@JoinColumn(name = "userId")
	private User user;

    @Column(name = "pet_id", nullable = false)
    private int pet_id;
    
    @Column(name = "picture", nullable = false, length = 256)
    private String picture;
    
    @Column(name = "part", nullable = false, length = 10)
    private String part;

    @Column(name = "symptom", nullable = true, length = 10)
    private String symptom;
    
    @Column(name = "result", nullable = false, length = 10)
    private String result;
    
    @CreationTimestamp
    @Column(name = "created_date", nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    private LocalDateTime created_date;    

    @Builder
    public Journal(JournalRequestDto request, User user) {
    	this.user = user;
        this.pet_id = request.getPet_id();
        this.picture = request.getPicture();
        this.part = request.getPart();
        this.symptom = request.getSymptom();
        this.result = request.getResult();
        this.created_date = LocalDateTime.now();
    }

    public void modify(JournalRequestDto request){
        if("".equals(request.getPart()) == false && request.getPart()!=null){
            this.part = request.getPart();
        }
        if("".equals(request.getPicture()) == false && request.getPicture()!=null){
            this.picture = request.getPicture();
        }
        if("".equals(request.getSymptom()) == false && request.getSymptom()!=null){
            this.symptom = request.getSymptom();
        }
        if("".equals(request.getResult()) == false && request.getResult()!=null){
            this.result = request.getResult();
        }
        if(request.getPet_id() != this.pet_id){
            this.pet_id = request.getPet_id();
        }
    }
    
    
    
}