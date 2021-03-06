<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<!DOCTYPE html>

<html>

<head>
    <jsp:include page="../_fragments/static-content-meta.jsp"/>
    <title><spring:message code="subordinate.page_name"/> - <spring:message code="global.app_name"/></title>
    <jsp:include page="../_fragments/static-content-styles.jsp"/>
</head>

<body>
    <jsp:include page="../_fragments/header.jsp"/>


    <main>
        <div class="container">
            <div class="section">
                <h4><spring:message code="subordinate.header"/></h4>

                <c:choose>
                    <c:when test="${empty subs}">
                        <hr>
                        <h5><spring:message code="subordinate.subs_missed"/></h5>
                    </c:when>

                    <c:otherwise>
                        <div class="row">
                            <div class="input-field col s6">
                                <select id="period">
                                    <option value="" disabled selected><spring:message code="control.choose"/> <spring:message code="period.${periodNameCode}"/></option>
                                    <c:forEach var="period" items="${periods}" varStatus="loop">
                                        <c:set var="isSelected" value=""/>
                                        <c:if test="${selectedPeriodId eq loop.index}">
                                            <c:set var="isSelected" value="selected"/>
                                        </c:if>
                                        <option value="${loop.index}" ${isSelected}>${loop.index + 1}. ${period.start} - ${period.end}</option>
                                    </c:forEach>
                                </select>
                                <label><spring:message code="control.available_periods"/></label>
                            </div>

                            <div class="input-field col s6">
                                <select id="year">
                                    <option value="" disabled selected><spring:message code="control.choose_year"/></option>
                                    <c:forEach var="year" items="${availYears}">
                                        <c:set var="isSelected" value=""/>
                                        <c:if test="${selectedYear eq year}">
                                            <c:set var="isSelected" value="selected"/>
                                        </c:if>
                                        <option value="${year}" ${isSelected}>${year} <spring:message code="forms.short.year"/></option>
                                    </c:forEach>
                                </select>
                                <label><spring:message code="control.available_years"/></label>
                            </div>
                        </div>

                        <div class="input-field col s12">
                            <select id="sub">
                                <option value="" disabled selected><spring:message code="control.choose_user"/></option>
                                <c:forEach var="sub" items="${subs}">
                                    <c:set var="isSelected" value=""/>
                                    <c:if test="${selectedSubId eq sub.id}">
                                        <c:set var="isSelected" value="selected"/>
                                    </c:if>
                                    <option value="${sub.id}" ${isSelected}>${sub.form.firstName} ${sub.form.lastName}</option>
                                </c:forEach>
                            </select>
                            <label><spring:message code="control.your_subs"/></label>
                        </div>


                        <c:choose>
                            <c:when test="${not empty userIndexes}">
                                <ul class="collection">
                                    <c:forEach var="uIndex" items="${userIndexes}">
                                        <li class="collection-item avatar">
                                            <i class="material-icons circle green">insert_chart</i>
                                            <span class="title truncate truncate-card-fix">${uIndex.index.name}</span>

                                            <p>
                                                <spring:message code="subordinate.sub_mark"/>
                                                <c:choose>
                                                    <c:when test="${uIndex.selfEstimate eq -1}">
                                                        <c:set var="selfEstimateValue" value="-"/>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <c:set var="selfEstimateValue" value="${uIndex.selfEstimate}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                ${selfEstimateValue}
                                            </p>

                                            <p><span class="truncate truncate-card-fix">Отзыв: <c:out value="${uIndex.description}">-</c:out></span></p>

                                            <p><spring:message code="subordinate.your_mark"/><br>
                                                <c:choose>
                                                    <c:when test="${uIndex.leadEstimate eq -1}">
                                                        <c:set var="leadEstimateValue" value=""/>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <c:set var="leadEstimateValue" value="${uIndex.leadEstimate}"/>
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:set var="isDisabled" value=""/>
                                                <c:set var="forceDisabled" value="disabled='disabled'"/>
                                                <c:if test="${not isEdit}">
                                                    <c:set var="isDisabled" value="disabled='disabled'"/>
                                                </c:if>

                                                <input id="${uIndex.id}" name="leadEstimate" type="number" step="0.01" min="0"
                                                       max="${uIndex.index.estimate}" class="validate" value="${leadEstimateValue}"
                                                    ${isDisabled}/>
                                            </p>

                                            <a href="JavaScript:$('#additional-modal-${uIndex.id}').openModal();"
                                               class="secondary-content"><i class="material-icons">chat_bubble_outline</i></a>

                                            <!-- Additional info modal -->
                                            <div id="additional-modal-${uIndex.id}" class="modal bottom-sheet">
                                                <div class="modal-content">
                                                    <h4><spring:message code="control.additional_info"/></h4>

                                                    <hr>

                                                    <h5>${uIndex.index.name}</h5>
                                                    <p><spring:message code="index.msg.mark_message1"/> ${uIndex.index.estimate}
                                                        <c:if test="${not empty uIndex.index.workName}">
                                                            <spring:message code="index.msg.mark_message2"/> ${uIndex.index.multiplier}
                                                            ${uIndex.index.workName}
                                                        </c:if>
                                                    </p>

                                                    <div class="row">
                                                        <div class="input-field col s12">
                                                    <textarea id="${uIndex.id}" ${forceDisabled}
                                                              name="description" class="materialize-textarea"><c:out value="${uIndex.description}"/></textarea>
                                                            <label><spring:message code="control.work_description"/></label>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="file-field input-field col s12">
                                                            <c:if test="${not empty uIndex.document}">
                                                                <c:url var="fileUrl" value="/user/dashboard/download?id=${uIndex.document.id}"/>
                                                                <c:set var="fileName" value="${uIndex.document.name}"/>

                                                                <div id="download-btn-area-${uIndex.id}">
                                                                    <a id="download-link-${uIndex.id}" href="${fileUrl}" class="btn right waves-effect waves-light">
                                                                        <spring:message code="control.download"/>
                                                                    </a>
                                                                </div>
                                                                <div class="file-path-wrapper">
                                                                    <input id="${uIndex.id}" ${forceDisabled}
                                                                           class="file-path" type="text" name="document-name" value="${fileName}"/>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <a class="modal-action modal-close waves-effect waves-red btn-flat">
                                                        <spring:message code="forms.cancel"/></a>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>

                            <c:when test="${empty selectedSubId}">
                                <h6><spring:message code="subordinate.select_sub"/></h6>
                            </c:when>

                            <c:otherwise>
                                <h6><spring:message code="subordinate.indexes_missed"/></h6>
                            </c:otherwise>
                        </c:choose>


                        <c:if test="${isEdit and not empty userIndexes}">
                            <div class="fixed-action-btn" style="bottom: 45px; right: 24px;">
                                <a class="btn-floating btn-large waves-effect waves-light green" id="publish-lead-button">
                                    <i class="material-icons">publish</i></a>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>


        <!-- Hidden bundled values -->
        <div id="fieldMissingError" class="hide"><spring:message code="messages.fill_up_fields"/></div>
        <div id="unsupportedMarkError" class="hide"><spring:message code="messages.unsupported_mark"/></div>

        <form id="sendEstimateForm" class="hide" method="post" action="<c:url value="/user/subs/estimates"/>"></form>
        <form id="sendReloadRequest" class="hide" action="<c:url value="/user/subs"/>"></form>
    </main>


    <jsp:include page="../_fragments/footer.jsp"/>
    <jsp:include page="../_fragments/static-content-scripts.jsp"/>

    <!-- Custom JS for page -->
    <script src="<c:url value="/resources/js/pages/subordinate.js"/>"></script>
</body>

</html>