<%@ taglib uri="/WEB-INF/lib/pgfTags.tld" prefix="pgf" %> 
<%@ page import="com.ups.gec.common.constants.ViewConstants" %>
<%@ page import="com.ups.gec.common.modelobj.MetaData" %>
<%@ page import="com.ups.gec.common.session.RequestConstants" %>
<%@ page import="com.ups.gec.common.session.SessionConstants" %>
<%@ page import="com.ups.gec.common.constants.GECConstants" %>
<%@ page import="com.ups.gec.common.modelobj.GecUserInfo" %>
<%@ page import="com.ups.gec.common.modelobj.API_Name_ValueVO" %>
<%@ page import="com.ups.webappcommon.HTMLEncoder"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.HashMap" %> 
<%@ page import="java.util.Iterator" %> 
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.Map.Entry" %>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="javax.servlet.http.HttpSession" %> 
<%@ page import="com.ups.gec.util.StringUtils" %> 
<%@ page import="com.ups.gec.common.GECProperties" %>
<%@ page import="com.ups.gec.common.GECTranslationComponent" %>


<pgf:useBean keyName="<%=SessionConstants.META_DATA%>"        
        applicationId="<%=GECProperties.getAppId()%>"       
        id="metaData"
        scope="request"
        className="com.ups.gec.common.modelobj.MetaData"
/>

<pgf:useBean keyName="<%=SessionConstants.REQUEST_ACCESS_KEY_CONFIRMATION_CONTAINER%>"        
        applicationId="<%=GECProperties.getAppId()%>"       
        id="requestAccessKeyConfirmationContainer"
        scope="request"
        className="com.ups.gec.common.modelobj.RequestAccessKeyConfirmationContainer"
/> 

<pgf:useBean keyName="<%=SessionConstants.CSRFTOKEN%>"        
        applicationId="<%=GECProperties.getAppId()%>"       
        id="CSRFData"
        scope="request"
        className="com.ups.gec.common.modelobj.CSRFData"
/> 


<%

String CSRFToken = ""; // hailstorm fix chinmoy
if(CSRFData != null)
{
	CSRFToken= CSRFData.getCSRFToken();
}
	
String loc = "en_US";
	loc = String.valueOf(metaData.getLocale());    
	//Added for xlocale rfc 9022 change starts
	String xLoc =String.valueOf(metaData.getxLocale());
	Locale metadataLocale= metaData.getLocale();
	 	if (null == loc)
	 	{
	 		loc = String.valueOf(Locale.US);
	 	}
	 	if((xLoc != null) && (xLoc.trim().length() ==5) )
		{
				
				loc= xLoc;
				metadataLocale= metaData.getxLocale();
			 
		}
	 	//changes ends
    
String  url= "/"+ViewConstants.CONTEXT_PATH+"/OLTRequestAccessConfForm?loc=" + loc;  




int intCounter=0;
boolean hasErrors = true;
boolean requiresProdAccess = false;
String javascriptURL = "";
//String errorMsg = "";
//String strAdditionalContactInfo = "";
//String strAccessKey = "";
//GecUserInfo  profileAddress = new GecUserInfo();
//GecUserInfo  secondaryAddress = new GecUserInfo();
java.util.List<API_Name_ValueVO> apiList = new java.util.ArrayList<API_Name_ValueVO>() ;



GecUserInfo profileAddress = requestAccessKeyConfirmationContainer.getProfileAddress();
GecUserInfo secondaryAddress = requestAccessKeyConfirmationContainer.getSecondaryAddress();
apiList =requestAccessKeyConfirmationContainer.getApis();
String strAccessKey = requestAccessKeyConfirmationContainer.getAccessKey();
String strAdditionalContactInfo = requestAccessKeyConfirmationContainer.getUpsAccountNumber();
String errorMsg = requestAccessKeyConfirmationContainer.getErrorMessage();
String environment = GECTranslationComponent.getEnvironment();

System.out.println(" environment value in  jsp------->"+ environment);
System.out.println(" csrftoken value in  jsp------->"+ CSRFToken);
try
{
if(profileAddress ==null || secondaryAddress==null ||apiList==null )
{
	response.sendRedirect("https://www.ups.com/upsdeveloperkit?loc=" + loc);
}
if(StringUtils.isEmpty(errorMsg))
{
	hasErrors = false;
}
if((environment.equalsIgnoreCase("MAHWAH")) || (environment.equalsIgnoreCase("WINDWARD")))
{
	 javascriptURL =  "https://fp.ups.com/fp/tags.js?org_id=13slif0w&session_id=" +CSRFToken;
}else 
{
	 javascriptURL =  "https://fp.ups.com/fp/tags.js?org_id=24p9o0oh&session_id=" +CSRFToken;
}
System.out.println(" url laoded for js ---------->"+ javascriptURL);
}catch(Exception e)
{
	 
} 
%>  
<script src="<%=javascriptURL%>" language="JavaScript1.2" type="text/javascript">
function submitActionRequest(strVal)
{
	if (document.OLTRequestAccessConfForm.submitRequest.value == "FALSE")
	{
     		document.OLTRequestAccessConfForm.submitRequest.value="TRUE";
     		document.OLTRequestAccessConfForm.selected.value=strVal; 
     		// Prepare redirect URL     		 
     		strTagetURL = '/<%=ViewConstants.CONTEXT_PATH%>/'+strVal+'?loc=<%=loc%>';
     		document.OLTRequestAccessConfForm.action=strTagetURL;      		 		 	 
     		document.OLTRequestAccessConfForm.submit();
	}
}
function openModalDialogue()
{ 
     		var strTagetURL = '/<%=ViewConstants.CONTEXT_PATH%>/popupModalopener'+'?loc=<%=loc%>+&formName=OLTRequestAccessConfForm&accessKeyForProduction=<%=strAccessKey%>&<%=ViewConstants.ORIGIN_REQUEST_FROM%>=<%=ViewConstants.ORIGIN_REQUEST_ACCESS_KEY_CONF%>';
     		dialog = $( "#dialog-confirm" ).dialog({
                modal: true,
                width: 470,
                position: {my: "center top", at:"center top", of: window },
                dialogClass: 'modal',
                buttons: [
                          {
                              text: '<%=GECProperties.getProperty(GECConstants.CONTEXT_GEC_CONTENT, "UI_TEXT_CANCEL",metadataLocale) %>',
                              "class": 'btn',
                              click: function() {
                                   dialog.dialog( "close" );
                              }
                          },
                          {
                              text: '<%=GECProperties.getProperty(GECConstants.CONTEXT_GEC_CONTENT, "UI_TEXT_CONTINUE",metadataLocale)%>',
                              "class": 'btn',
                              click: function() {
                       			var strTagetURL = '/<%=ViewConstants.CONTEXT_PATH%>/requestproductionAccessKeyContinue'+'?loc=<%=loc%>';     			
                     			document.OLTRequestAccessConfForm.action = strTagetURL;
                 				document.OLTRequestAccessConfForm.selected.value = '<%=ViewConstants.UI_TEXT_CONTINUE%>'; 
                 				document.OLTRequestAccessConfForm.btnClickIdentifier.value='accessKeyForProduction';
                 				document.OLTRequestAccessConfForm.accessKeyProduction.value='<%=strAccessKey%>';
                 				document.OLTRequestAccessConfForm.submitRequest.value="TRUE";		
                				document.OLTRequestAccessConfForm.submit();
                              }
                          }
                      ]
            }).load(strTagetURL);

}
function submitOnce()
{
	
	if (document.OLTRequestAccessConfForm.submitRequest.value == "FALSE")
	{
		return true;
	}
	else
	{
		return false;
	}
} 
</script>
<style>
.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {
    text-align: center;
    float: none !important;
} 

.ui-dialog .ui-dialog-buttonpane button {
	margin: 0 10px 0 0 !important;
}

.ui-button-text-only .ui-button-text {
    padding: 2.4 !important;
}

.ui-dialog .ui-dialog-content {
    padding: 0 0 6 !important;
}
</style>
 
<pgf:setBundle basename="content_config"/>
<div id="main">
	<h1><pgf:message key="UI_TITLE_UPS_DEVELOPER_KIT"/></h1>
	<!-- Begin Module -->	
	<!-- Begin Error Display part -->
	 <% if (hasErrors) { %>
	 	<p class="error"> 
	 		  <pgf:message key="<%=errorMsg%>"/>  
	 	</p> 
	 <%}%>   
	<!-- End Error Display part -->			
	<form ACTION="<%=url%>" onsubmit="return submitOnce()" METHOD="POST" name="OLTRequestAccessConfForm" id="OLTRequestAccessConf">
		<INPUT Type="hidden" name="selected" value="<%=ViewConstants.UI_TEXT_CONTINUE %>" >	
		<INPUT Type="hidden" name="submitRequest" value="FALSE" >
		<INPUT Type="hidden" name="btnClickIdentifier" value="FALSE" >
		<INPUT Type="hidden" name="accessKeyProduction" value="FALSE" >
		<INPUT Type="hidden" name="pageid" value="5" > 
		<INPUT Type="hidden" name="CSRFToken" value="<%=CSRFToken%>">
		<INPUT Type="hidden" name="<%=ViewConstants.ORIGIN_REQUEST_FROM%>" value="<%=ViewConstants.ORIGIN_REQUEST_ACCESS_KEY_CONF%>">	
		<fieldset>
		<legend>{legend text}</legend>
		<div class="appLvl mod">
			<div class="appHead clearfix">
				<h2><pgf:message key="UI_HEADER_REQUEST_ACCESS_KEY_CONFIRMATION"/></h2>
				<ul>
					<li><a href="#" onclick="JavaScript:window.print()"><pgf:message key="UI_TEXT_PRINT"/></a></li>
				</ul>			
			</div>
			<div class="appBody">
			<div id="dialog-confirm" ></div>
					<p><pgf:message key="UI_TEXT_THANK_YOU_FOR_ACCESS_KEY"/></p>
					<dl class="inline clearfix">
						<dt>
							<label><pgf:message key="UI_LABEL_ACCESS_KEY"/><strong> <%=strAccessKey%></strong></label>
						</dt>
						<dd></dd>
					</dl>
					<%if(apiList!=null && !apiList.isEmpty() ) { %>
					<dl class="inline clearfix">
					<dt>
					
					<table class="dataTable" cellspacing="0" cellpadding="0" border="0">
					<tr valign="top">
					<td>
					
							<label><pgf:message key="UI_LABEL_PROVIDES_ACCESS_TO"/>:</label>
					</td>
					<td valign="top">	
						<dd>
							<table class="dataTable" cellspacing="0" cellpadding="0" border="0">
								<tr>
									<th><pgf:message key="UI_LABEL_DEVELOPER_RESOURCE"/> </th>
									<th><pgf:message key="UI_TEXT_ACCESS_TYPE"/>  </th>
								</tr>
								<%
								for (int counter =0 ;counter<apiList.size();counter++)
								{
									 
									String key =   StringUtils.setBlank(apiList.get(counter).getToolNameInLocale()) ;
									String value =  StringUtils.setBlank(apiList.get(counter).getToolAccessInLocale()) ;
									
									if(requiresProdAccess == false && StringUtils.setBlank(apiList.get(counter).getToolAccessInEnglish()).toLowerCase().equals("test"))
									{
										requiresProdAccess = true;
									}
									if(!key.equals("")){
									intCounter++;
								%>
								<tr <%if(intCounter%2==1){%>class="odd" <%}%> >
									<td><%if(!StringUtils.isNullOrEmpty(key)){%><%=key%><%}%></td>
									<td><%if(!StringUtils.isNullOrEmpty(value)){%><%=value%><%}%></td>
								</tr>
								 <%}} %>								 
							</table>
						</dd>
						</td> 
						
						</tr>
						</table>
						</dt>
					</dl>
					<%} %>
					<dl>
						<dt>
							<label><pgf:message key="UI_TEXT_NOTES"/>:</label>
						</dt>
						<dd>
							<ul>
								<li> <pgf:message key="UI_TEXT_IF_YOU_HAVE_PRODUCTION_ACCESS"/></li> 
								<%if(requiresProdAccess){ %>
								 <li><pgf:message key="UI_TEXT_IF_YOU_HAVE_TEST_ACCESS_1"/> <a href="#" target="_self" onClick="openModalDialogue()" class="btnlnkR lockIconR"><pgf:message key="UI_TEXT_IF_YOU_HAVE_TEST_ACCESS_2"/></a> <pgf:message key="UI_TEXT_IF_YOU_HAVE_TEST_ACCESS_3"/></li>
								<%}%>
							</ul>
						</dd>
						<dt>
							<label><pgf:message key="UI_LABEL_PRIMARY_CONTACT_INFORMATION"/>:</label>
						</dt>
						<dd>
							<%if(!StringUtils.setBlank(profileAddress.getStrCompanyName()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrCompanyName()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrFirstName()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrFirstName()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrAddressLine1()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrAddressLine1()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrAddressLine2()).equals("")) { %>
							<%=StringUtils.setBlank(profileAddress.getStrAddressLine2()) %> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrAddressLine3()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrAddressLine3()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrCity()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrCity()))%>,
							<%}%> 
							<%if(!StringUtils.setBlank(profileAddress.getStrStateProv()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrStateProv()))%>
							<%}%>  
							<%if(!StringUtils.setBlank(profileAddress.getStrPostalCode()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrPostalCode()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrCountryCode()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrCountryCode()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrTelephoneNumber()).equals("")) { %>
							<pgf:message key="UI_LABEL_TELEPHONE"/>: <%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrTelephoneNumber()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrTelephoneExtension()).equals("")) { %>
							<pgf:message key="UI_LABEL_EXTENSION"/>: <%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrTelephoneExtension()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(profileAddress.getStrEMail()).equals("")) { %>
							<pgf:message key="UI_LABEL_EMAIL_ADDRESS"/>: <%=HTMLEncoder.encodeHTML(StringUtils.setBlank(profileAddress.getStrEMail()))%>
							<%}%>  
							</dd>
							<%if(secondaryAddress!=null && (!StringUtils.setBlank(secondaryAddress.getStrCompanyName()).equals("") && !StringUtils.setBlank(secondaryAddress.getStrTelephoneNumber()).equals("") && !StringUtils.setBlank(secondaryAddress.getStrEMail()).equals(""))){ %>
						<dt>
							<label><pgf:message key="UI_LABEL_SECONDARY_CONTACT_INFORMATION"/>:</label>
						</dt>
						<dd> 
							<%if(!StringUtils.setBlank(secondaryAddress.getStrCompanyName()).equals("")) { %>
							<%=HTMLEncoder.encodeHTML(StringUtils.setBlank(secondaryAddress.getStrCompanyName()))%> <br>
							<%}%>
							<%if(!StringUtils.setBlank(secondaryAddress.getStrTelephoneNumber()).equals("")) { %>
							<pgf:message key="UI_LABEL_TELEPHONE"/>: <%=HTMLEncoder.encodeHTML(StringUtils.setBlank(secondaryAddress.getStrTelephoneNumber()))%>  <br>
							<%}%>
							<%if(!StringUtils.setBlank(secondaryAddress.getStrEMail()).equals("")) { %>							
							<pgf:message key="UI_LABEL_EMAIL_ADDRESS"/>: <%=HTMLEncoder.encodeHTML(StringUtils.setBlank(secondaryAddress.getStrEMail()))%>  
							<%}%>
							</dd>
						<%}%>
						<%if(!StringUtils.isNullOrEmpty(strAdditionalContactInfo)){ %>
						<dt>
							<label><pgf:message key="UI_LABEL_ADDITIONAL_REGISTRATION_INFORMATION"/>:</label>
						</dt>
						<dd><pgf:message key="UI_LABEL_UPS_ACCOUNT"/>: <%=strAdditionalContactInfo%></dd>
						<%}%>
					</dl>
				</div>
			<div class="appFooter"></div>
			<!-- End Module -->
		</div>
	<div class="note">
			<input type="button" ID="BACK_TO_PREVIOUS" onClick="submitActionRequest('<%=ViewConstants.UI_TEXT_BACK_TO_PREVIOUS%>')" ID="BACK" value="<pgf:message key="UI_TEXT_BACK_TO_UPS_DEVELOPER_KIT"/>" class="btnlnkL arrowBackIcon" name="repl_name">
	</div>
		</fieldset>
	</form>
</div>
 
