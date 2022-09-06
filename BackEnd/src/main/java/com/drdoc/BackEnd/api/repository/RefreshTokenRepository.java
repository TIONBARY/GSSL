package com.drdoc.BackEnd.api.repository;


import com.drdoc.BackEnd.api.domain.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Integer> {
    Optional<RefreshToken> findByKey(int key);

    void deleteByExpireTimeLessThan(LocalDateTime now);
}