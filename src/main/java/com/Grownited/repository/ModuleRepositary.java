package com.Grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.ModuleEntity;

@Repository
public interface ModuleRepositary extends JpaRepository<ModuleEntity, Integer> {
	List<ModuleEntity> findByProjectIdIn(List<Integer> projectIds);
	List<ModuleEntity> findByModuleIdIn(List<Integer> moduleIds);
	// Add to ModuleRepositary interface
	List<ModuleEntity> findByProjectId(Integer projectId);
}
