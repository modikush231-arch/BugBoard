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

<!-- Inside the table, after the Project Manager column -->
<thead>
    <tr>
        <th class="text-secondary">SrNo</th>
        <th class="text-secondary">Project</th>
        <th class="text-secondary">Project Manager</th>
        <th class="text-secondary">Project Status</th>   <!-- new column -->
        <th class="text-secondary">Assign Status</th>
        <th class="text-secondary">Actions</th>
    </tr>
</thead>
<tbody>
    <c:forEach var="pu" items="${projectUserList}" varStatus="status">
         <c:set var="projectEntity" value="" />
         <c:forEach var="p" items="${projectList}">
             <c:if test="${p.projectId == pu.projectId}">
                 <c:set var="projectEntity" value="${p}" />
             </c:if>
         </c:forEach>

         <!-- Resolve status name from projectStatusList using projectEntity.projectStatusId -->
         <c:set var="statusName" value="-" />
         <c:forEach var="ps" items="${projectStatusList}">
             <c:if test="${ps.projectStatusId == projectEntity.projectStatusId}">
                 <c:set var="statusName" value="${ps.status}" />
             </c:if>
         </c:forEach>

         <tr>
             <td class="text-white">${status.index + 1}</td>
             <td class="text-white fw-medium">${projectEntity.title}</td>
             <td class="text-white-50">
                 <c:forEach var="userEntity" items="${userList}">
                     <c:if test="${userEntity.userId == pu.userId}">
                         ${userEntity.first_name} ${userEntity.last_name}
                     </c:if>
                 </c:forEach>
             </td>
                   <td>
                <span class="badge 
                    <c:choose>
                        <c:when test="${statusName == 'Lead'}">bg-purple</c:when>
                        <c:when test="${statusName == 'NotStarted'}">bg-secondary</c:when>
                        <c:when test="${statusName == 'InProgress'}">bg-primary</c:when>
                        <c:when test="${statusName == 'Hold'}">bg-warning text-dark</c:when>
                        <c:when test="${statusName == 'Completed'}">bg-success</c:when>
                        <c:otherwise>bg-secondary</c:otherwise>
                    </c:choose>
                ">${statusName}</span>
            </td>
             <td>
                 <c:choose>
                     <c:when test="${pu.assignStatus == 1}">
                         <span class="badge bg-success">Assigned</span>
                     </c:when>
                     <c:otherwise>
                         <span class="badge bg-danger">Revoked</span>
                     </c:otherwise>
                 </c:choose>
             </td>
             <td>
                 <!-- actions buttons (View, Update, Delete) unchanged -->
                 <div class="d-flex gap-2">
                     <a href="viewProjectUser/${pu.projectUserId}" class="btn btn-sm btn-primary"><i class="bi bi-eye"></i></a>
                     <a href="editProjectUser/${pu.projectUserId}" class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i></a>
                     <a href="deleteProjectUser/${pu.projectUserId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')"><i class="bi bi-trash"></i></a>
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

<select name="projectId" class="form-select" required>
    <option value="">Select Project</option>
    <c:forEach var="project" items="${unassignedProjects}">
        <option value="${project.projectId}">${project.title}</option>
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
