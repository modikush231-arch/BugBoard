package com.Grownited.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="userDetails")
public class UserDetailsEntity {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer userDetailId;
	private String userId;
	private String qualification;
	private String city;
	private String state;
	private String country;
	private Integer userTypeId;
	
	public Integer getUserDetailId() {
		return userDetailId;
	}
	public void setUserDetailId(Integer userDetailId) {
		this.userDetailId = userDetailId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getQualification() {
		return qualification;
	}
	public void setQualification(String qualification) {
		this.qualification = qualification;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public Integer getUserTypeId() {
		return userTypeId;
	}
	public void setUserTypeId(Integer userTypeId) {
		this.userTypeId = userTypeId;
	}
	
	
	
}
