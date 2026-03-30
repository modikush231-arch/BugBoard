<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Project Manager Assignment" scope="request" />
<c:set var="activeNav" value="projectUser" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h2 text-white mb-0">
        <i class="bi bi-person-badge me-2" style="color: var(--primary-color);"></i>
        Manager Assignment
    </h1>

    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#assignModal">
        <i class="bi bi-plus-circle me-2"></i>Assign Manager
    </button>
</div>

<!-- Search Box -->
<div class="mb-4 d-flex justify-content-end">

    <div class="col-md-4">
        <div class="input-group">
            <span class="input-group-text bg-transparent border-secondary text-secondary">
                <i class="bi bi-search"></i>
            </span>

            <input type="text"
                   id="searchInput"
                   class="form-control bg-transparent text-white border-secondary"
                   placeholder="Search..."
                   onkeyup="filterTable()">
        </div>
    </div>
</div>

<!-- Assignment Table -->
<div class="glass-card p-4">

    <div class="table-responsive">

        <table id="projectTable"
               class="table table-hover mb-0"
               style="--bs-table-bg: transparent;">

            <thead>
                <tr>
                    <th class="text-secondary">SrNo</th>
                    <th class="text-secondary">Project</th>
                    <th class="text-secondary">Project Manager</th>
                    <th class="text-secondary">Assign Status</th>
                    <th class="text-secondary">Actions</th>
                </tr>
            </thead>

            <tbody>

                <c:forEach var="pu" items="${projectUserList}" varStatus="status">

                    <tr>

                        <td class="text-white">
                            ${status.index + 1}
                        </td>

                        <!-- Project Name -->
                        <td class="text-white fw-medium">

                            <c:forEach var="projectEntity" items="${projectList}">

                                <c:if test="${projectEntity.projectId == pu.projectId}">
                                    ${projectEntity.title}
                                </c:if>

                            </c:forEach>

                        </td>

                        <!-- Manager Name -->
                        <td class="text-white-50">

                            <c:forEach var="userEntity" items="${userList}">

                                <c:if test="${userEntity.userId == pu.userId}">
                                    ${userEntity.first_name} ${userEntity.last_name}
                                </c:if>

                            </c:forEach>

                        </td>

                        <!-- Status -->
                        <td>

                            <c:choose>

                                <c:when test="${pu.assignStatus == 1}">
                                    <span class="badge bg-success">
                                        Assigned
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="badge bg-danger">
                                        Revoked
                                    </span>
                                </c:otherwise>

                            </c:choose>

                        </td>

                        <!-- Actions -->
                       <td>
                                    <div class="d-flex gap-2 justify-content">
                                        <a href="viewProjectUser/${pu.projectUserId}" 
                                           class="btn btn-sm btn-primary btn-custom">
                                            <i class="bi bi-eye"></i> View
                                        </a>
                                        <a href="editProjectUser/${pu.projectUserId}" 
                                           class="btn btn-sm btn-warning btn-custom">
                                            <i class="bi bi-pencil"></i> Update
                                        </a>
                                        <a href="deleteProjectUser/${pu.projectUserId}" 
                                           class="btn btn-sm btn-danger btn-custom"
                                           onclick="return confirm('Are you sure you want to delete this task?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                    </tr>

                </c:forEach>

            </tbody>

        </table>

    </div>

</div>


<!-- Assign Modal -->

<div class="modal fade"
     id="assignModal"
     tabindex="-1">

    <div class="modal-dialog">

        <div class="modal-content bg-dark text-white">

            <div class="modal-header">

                <h5 class="modal-title">

                    Assign Manager to Project

                </h5>

                <button type="button"
                        class="btn-close btn-close-white"
                        data-bs-dismiss="modal">
                </button>

            </div>


            <form action="saveProjectUser"
                  method="post">

                <div class="modal-body">


                    <!-- Project -->
                    <div class="mb-3">

                        <label class="form-label">
                            Project
                        </label>

                        <select name="projectId"
                                class="form-select"
                                required>

                            <option value="">
                                Select Project
                            </option>

                            <c:forEach var="project"
                                       items="${projectList}">

                                <option value="${project.projectId}">
                                    ${project.title}
                                </option>

                            </c:forEach>

                        </select>

                    </div>


                    <!-- Manager -->
                    <div class="mb-3">

                        <label class="form-label">
                            User
                        </label>

                        <select name="userId"
                                class="form-select"
                                required>

                            <option value="">
                                Select Project Manager
                            </option>

                            <c:forEach var="user"
                                       items="${userList}">

                                <option value="${user.userId}">
                                    ${user.first_name} ${user.last_name}
                                </option>

                            </c:forEach>

                        </select>

                    </div>


                    <!-- Status -->
                    <div class="mb-3">

                        <label class="form-label">
                            Assignment Status
                        </label>

                      <select name="assignStatus" class="form-select" required>

    <option value="1">Assign</option>

    <option value="0">Revoke</option>

</select>

                    </div>


                </div>


                <div class="modal-footer">

                    <button type="submit"
                            class="btn btn-success">

                        Save

                    </button>

                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">

                        Cancel

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

</main>

<jsp:include page="adminfooter.jsp" />

<script>

function filterTable()
{
    const input =
        document.getElementById("searchInput")
        .value
        .toLowerCase();

    const table =
        document.getElementById("projectTable");

    const rows =
        table.getElementsByTagName("tr");

    for (let i = 1; i < rows.length; i++)
    {
        const text =
            rows[i].innerText.toLowerCase();

        rows[i].style.display =
            text.includes(input) ? "" : "none";
    }
}

</script>
