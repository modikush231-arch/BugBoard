package com.Grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.TaskEntity;

@Repository
public interface TaskRepository extends JpaRepository<TaskEntity, Integer> {

    long countByStatus(String status);

    long countByProjectIdIn(List<Integer> projectIds);
   
    long countByStatusNotInAndProjectIdIn(List<String> statuses, List<Integer> projectIds);

    long countByStatusNotIn(List<String> statuses);
 // Add to TaskRepository interface
    long countByModuleId(Integer moduleId);
    List<TaskEntity> findByModuleId(Integer moduleId);
    List<TaskEntity> findByProjectIdIn(List<Integer> projectIds);
    
    List<TaskEntity> findByTaskIdIn(List<Integer> taskIds);
    
    // ✅ NEW: Count tasks by project ID
    long countByProjectId(Integer projectId);
    
    // ✅ NEW: Find top 5 recent tasks by project IDs
    @Query("SELECT t FROM TaskEntity t WHERE t.projectId IN :projectIds ORDER BY t.taskId DESC")
    List<TaskEntity> findTop5ByProjectIdInOrderByTaskIdDesc(@Param("projectIds") List<Integer> projectIds);
    
    // ✅ NEW: Find all tasks by project ID
    List<TaskEntity> findByProjectId(Integer projectId);
}