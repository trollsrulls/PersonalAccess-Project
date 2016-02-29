<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<nav class="light-blue lighten-1" role="navigation">
    <div class="container">
        <div class="nav-wrapper">
            <a href="<c:url value="/"/>" class="brand-logo">
                <img src="<c:url value="/resources/img/logo_55x55.png"/>" class="responsive-img"
                     alt="<spring:message code="global.app_name"/>">
            </a>


            <ul class="right hide-on-med-and-down">
                <li>
                    <a href="<c:url value="/"/>"><spring:message
                            code="control.main_page"/></a>
                </li>

                <security:authorize access="isAnonymous()">
                    <li>
                        <a href="<c:url value="/login"/>"><spring:message code="control.sign_in"/></a>
                    </li>
                </security:authorize>

                <security:authorize access="hasRole('ROLE_ADMIN')">
                    <li>
                        <a href="<c:url value="/admin/dashboard"/>"><spring:message code="control.admin_dashboard"/></a>
                    </li>
                </security:authorize>

                <security:authorize access="isAuthenticated()">
                    <li>
                        <a class="dropdown-button" href="#" data-activates="reports-drops1"><spring:message
                                code="control.reports"/><i class="material-icons right">arrow_drop_down</i></a>
                    </li>
                    <li>
                        <a href="<c:url value="/user/subs"/>"><spring:message
                                code="control.subs"/></a>
                    </li>
                    <li>
                        <a href="<c:url value="/user/profile"/>"><spring:message
                                code="control.profile"/></a>
                    </li>
                    <li>
                        <a href="<c:url value="/j_spring_security_logout"/>"><spring:message
                                code="control.sign_out"/></a>
                    </li>
                </security:authorize>
            </ul>


            <ul id="nav-mobile" class="side-nav">
                <li>
                    <a href="<c:url value="/"/>"><spring:message
                            code="control.main_page"/></a>
                </li>

                <security:authorize access="isAnonymous()">
                    <li>
                        <a href="<c:url value="/login"/>"><spring:message code="control.sign_in"/></a>
                    </li>
                </security:authorize>

                <security:authorize access="hasRole('ROLE_ADMIN')">
                    <li>
                        <a href="<c:url value="/admin/dashboard"/>"><spring:message code="control.admin_dashboard"/></a>
                    </li>
                </security:authorize>

                <security:authorize access="isAuthenticated()">
                    <li>
                        <a class="dropdown-button" href="#" data-activates="reports-drops2"><spring:message
                                code="control.reports"/><i class="material-icons right">arrow_drop_down</i></a>
                    </li>
                    <li>
                        <a href="<c:url value="/user/subs"/>"><spring:message
                                code="control.subs"/></a>
                    </li>
                    <li>
                        <a href="<c:url value="/user/profile"/>"><spring:message
                                code="control.profile"/></a>
                    </li>
                    <li>
                        <a href="<c:url value="/j_spring_security_logout"/>"><spring:message
                                code="control.sign_out"/></a>
                    </li>
                </security:authorize>
            </ul>
            <a href="#" data-activates="nav-mobile" class="button-collapse"><i class="material-icons">menu</i></a>
        </div>
    </div>
</nav>

<security:authorize access="isAuthenticated()">
    <ul id="reports-drops1" class="dropdown-content">
        <li><a href="<c:url value="/user/report/employees"/>">Сотрудники</a></li>
        <li><a href="<c:url value="/user/report/indexes"/>">Показатели</a></li>
        <li><a href="<c:url value="/user/report/ranges"/>">Ранжирование</a></li>
    </ul>
    <ul id="reports-drops2" class="dropdown-content">
        <li><a href="<c:url value="/user/report/employees"/>">Сотрудники</a></li>
        <li><a href="<c:url value="/user/report/indexes"/>">Показатели</a></li>
        <li><a href="<c:url value="/user/report/ranges"/>">Ранжирование</a></li>
    </ul>
</security:authorize>