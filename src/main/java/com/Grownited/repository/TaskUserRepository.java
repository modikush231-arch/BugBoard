package com.Grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.TaskUserEntity;
import jakarta.transaction.Transactional;

@Repository
public interface TaskUserRepository extends JpaRepository<TaskUserEntity, Integer> {

    @Transactional
    @Modifying
    void deleteByTaskId(Integer taskId);

    List<TaskUserEntity> findByUserId(Integer userId);

    List<TaskUserEntity> findByTaskIdIn(List<Integer> taskIds);

    List<TaskUserEntity> findByTaskId(Integer taskId);

    // ✅ NEW: Find top 10 most recently updated assignments
    List<TaskUserEntity> findTop10ByOrderByUpdatedDateDesc();
    
   
        List<TaskUserEntity> findByTaskIdAndUserId(Integer taskId, Integer userId);
        // or if you have a method to delete directly:
        void deleteByTaskIdAndUserId(Integer taskId, Integer userId);
 }