package com.drdoc.BackEnd.api.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Email;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "user")
@Entity
@Builder
public class User {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "memberId", nullable = false, unique = true, length = 20)
    private String memberId;
    
    @Column(name = "password", nullable = false, length = 256)
    private String password;
    
    @Column(name = "nickname", nullable = false, unique = true, length = 10)
    private String nickname;
    
    @Column(name = "gender", nullable = false, length = 1)
    private String gender;
    
    @Column(name = "phone", nullable = false, length = 11)
    private String phone;
    
    @Email
    @Column(name = "email", nullable = false, length = 50)
    private String email;
    
    @Column(name = "profilePic", nullable = true, length = 256)
    private String profilePic;
    
    @Column(name = "introduce", nullable = true, length = 50)
    private String introduce;
    
    @Column(name = "isLeft", nullable = false, columnDefinition = "boolean default false")
    private boolean isLeft;
    
    @Column(name = "pet_id", nullable = true)
    private int pet_id;
}