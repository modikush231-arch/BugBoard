package com.Grownited.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.ProjectStatusEntity;

@Repository
public interface ProjectStatusRepositary extends JpaRepository<ProjectStatusEntity, Integer>{
	   // Find a status record by its status name (e.g. "Completed")
    ProjectStatusEntity findByStatus(String status);
}
