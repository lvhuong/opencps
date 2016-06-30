<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%
/**
 * OpenCPS is the open source Core Public Services software
 * Copyright (C) 2016-present OpenCPS community
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
%>
<%@ include file="init.jsp"%>
<%@page import="org.opencps.dossiermgt.service.ServiceConfigLocalServiceUtil"%>
<%@page import="org.opencps.dossiermgt.model.ServiceConfig"%>
<%@page import="org.opencps.util.DictItemUtil"%>
<%@page import="org.opencps.servicemgt.service.ServiceInfoLocalServiceUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.opencps.servicemgt.model.ServiceInfo"%>
<%@page import="java.util.List"%>
<liferay-util:include page='<%= templatePath + "toolbar.jsp"%>' servletContext="<%=application %>" />
<%
	String administrationCode = ParamUtil.getString(request, "administrationCode");

	String domainCode = ParamUtil.getString(request, "domainCode");


	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath", templatePath + "submitinstruction.jsp");
	iteratorURL.setParameter("administrationCode", administrationCode);
	iteratorURL.setParameter("domainCode", domainCode);
	
	List<ServiceInfo> serviceInfos = new ArrayList<ServiceInfo>();
	List<ServiceInfo> serviceInfoUses = new ArrayList<ServiceInfo>();
	int totalCount = 0;
	System.out.print("keyword" + keyword);
	
%>

<liferay-ui:search-container 
		emptyResultsMessage="no-serviceinfo-were-found"
		iteratorURL="<%=iteratorURL %>"
		delta="<%=20 %>"
		deltaConfigurable="true"
	>
	
	<liferay-ui:search-container-results>
		<%
			serviceInfos = ServiceInfoLocalServiceUtil.searchService(scopeGroupId, keyword,
				administrationCode, domainCode, 
				searchContainer.getStart(), searchContainer.getEnd());
			
			totalCount = serviceInfoUses.size();
			results = serviceInfos;
			total = totalCount;
			pageContext.setAttribute("results", results);
			pageContext.setAttribute("total", total);
		%>
	</liferay-ui:search-container-results>
	
	<liferay-ui:search-container-row 
		className="org.opencps.servicemgt.model.ServiceInfo" 
		modelVar="service" 
		keyProperty="serviceinfoId"
	>
		<% 
			int level = 0;
			String levelName = StringPool.BLANK;
			ServiceConfig serviceConfig = null;
			try {
				serviceConfig = ServiceConfigLocalServiceUtil
								.getServiceConfigByG_S(scopeGroupId, service.getServiceinfoId());
				level = serviceConfig.getServiceLevel();
				levelName = String.valueOf(level);
			} catch (Exception e) {
				//nothing to do
			}
			
			PortletURL submitOnlineURL = renderResponse.createRenderURL();
			submitOnlineURL.setParameter("mvcPath", templatePath + "dossier_submit_online.jsp");
			submitOnlineURL.setParameter("serviceinfoId", String.valueOf(service.getServiceinfoId()));
			submitOnlineURL.setParameter("onlineURL", service.getOnlineUrl());
			submitOnlineURL.setParameter("backURL", currentURL);
			
			final String hrefFix = "location.href='" + submitOnlineURL .toString()+"'";
		%>
	
		<liferay-ui:search-container-column-text 
			name="row-no" 
			value="<%=String.valueOf(row.getPos() + 1) %>"
		/>
		
		<liferay-ui:search-container-column-text 
			name="service-name" 
			value="<%=service.getServiceName() %>"
		/>
		
		<liferay-ui:search-container-column-text 
			name="service-domain" 
			value="<%=DictItemUtil.getNameDictItem(service.getDomainCode())%>"
		/>
		
		<liferay-ui:search-container-column-text 
			name="service-administrator" 
			value="<%=DictItemUtil.getNameDictItem(service.getAdministrationCode())%>"
		/>
		
		<c:choose>
			<c:when test="<%=levelName.equals(StringPool.BLANK) %>">
				<liferay-ui:search-container-column-text 
					name="level" 
					value='<%=LanguageUtil.get(portletConfig ,themeDisplay.getLocale(), "under-level-3") %>'
				/>
			</c:when>
			<c:otherwise>
				<liferay-ui:search-container-column-text 
					name="level" 
					value="<%=levelName %>"
				/>
			</c:otherwise>
		</c:choose>
		
		<liferay-ui:search-container-column-button 
			name="description"
			href="<%=hrefFix %>"
		/>
			
	</liferay-ui:search-container-row>
		
	<liferay-ui:search-iterator/>

</liferay-ui:search-container>