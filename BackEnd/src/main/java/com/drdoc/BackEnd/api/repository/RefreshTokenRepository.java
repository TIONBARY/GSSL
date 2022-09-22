package com.drdoc.BackEnd.api.repository;


import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.drdoc.BackEnd.api.domain.RefreshToken;

@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Integer> {
    Optional<RefreshToken> findByKey(String string);
    
    Optional<RefreshToken> findByValue(String string);

    void deleteByExpireTimeLessThan(LocalDateTime now);

	void deleteByValue(String refresh_token);
}