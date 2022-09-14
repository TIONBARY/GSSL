package com.drdoc.BackEnd.api.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.drdoc.BackEnd.api.domain.Journal;

@Repository
public interface JournalRepository extends JpaRepository<Journal, Integer> {
    Journal findById(int id);
}