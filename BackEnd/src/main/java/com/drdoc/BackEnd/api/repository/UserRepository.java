package com.drdoc.BackEnd.api.repository;


import com.drdoc.BackEnd.api.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByMemberId(String MemberId);
    Optional<User> findByNickname(String Nickname);    
}