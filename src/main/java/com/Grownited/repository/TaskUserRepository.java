package com.Grownited.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.TaskUserEntity;

@Repository
public interface TaskUserRepository extends JpaRepository<TaskUserEntity, Integer>{

}
