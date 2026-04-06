package com.Grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.ProjectEntity;

@Repository
public interface ProjectRepository extends JpaRepository<ProjectEntity, Integer> {

    long countByProjectStatusId(int projectStatusId);
    
    long countByProjectIdIn(List<Integer> projectIds);

    long countByProjectStatusIdAndProjectIdIn(Integer statusId, List<Integer> projectIds);

    long countByProjectStatusIdIn(List<Integer> statusIds);

    long countByProjectStatusIdInAndProjectIdIn(List<Integer> statusIds, List<Integer> projectIds);

    List<ProjectEntity> findByProjectIdIn(List<Integer> projectIds);
    
    // ✅ NEW: Find top 5 recent projects by project IDs
    @Query("SELECT p FROM ProjectEntity p WHERE p.projectId IN :projectIds ORDER BY p.projectId DESC")
    List<ProjectEntity> findTop5ByProjectIdInOrderByProjectIdDesc(@Param("projectIds") List<Integer> projectIds);
    
    // ✅ NEW: Find top 5 recent projects (all projects, ordered by ID descending)
    List<ProjectEntity> findTop5ByOrderByProjectIdDesc();
    
    // ✅ NEW: Find all projects by status ID
    List<ProjectEntity> findByProjectStatusId(Integer statusId);
}