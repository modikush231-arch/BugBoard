package com.Grownited.repository;

import org.hibernate.boot.models.JpaAnnotations;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.ProjectUserEntity;

@Repository
public interface ProjectUserRepository extends JpaRepository<ProjectUserEntity,Integer>{

}