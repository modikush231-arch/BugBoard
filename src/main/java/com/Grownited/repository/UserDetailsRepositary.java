package com.Grownited.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.UserDetailsEntity;

@Repository
public interface UserDetailsRepositary extends JpaRepository<UserDetailsEntity, Integer> {

}
