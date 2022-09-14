package com.drdoc.BackEnd.api.domain;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.CreationTimestamp;

import com.drdoc.BackEnd.api.domain.dto.JournalRequestDto;
import com.drdoc.BackEnd.api.util.SecurityUtil;

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

    @Column(name = "memberId", nullable = false)
    private String memberId;

    @Column(name = "petId", nullable = false)
    private int petId;
    
    @Column(name = "picture", nullable = false, length = 256)
    private String picture;
    
    @Column(name = "part", nullable = false, length = 10)
    private String part;
    
  @Column(name = "result", nullable = true, length = 10)
  private String result;
    
    @CreationTimestamp
    @Column(name = "created_date", nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    private LocalDateTime created_date;    

    @Builder
    public Journal(JournalRequestDto request) {    	
        this.memberId = SecurityUtil.getCurrentUsername();
        this.petId = request.getPetId();
        this.picture = request.getPicture();
        this.part = request.getPart();
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
        if("".equals(request.getResult()) == false && request.getResult()!=null){
            this.result = request.getResult();
        }
        if(request.getPetId() != this.petId){
            this.petId = request.getPetId();
        }
    }
    
    
    
}