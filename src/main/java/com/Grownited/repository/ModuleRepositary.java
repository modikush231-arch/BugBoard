package com.Grownited.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.ModuleEntity;

@Repository
public interface ModuleRepositary extends JpaRepository<ModuleEntity, Integer> {
	
}
