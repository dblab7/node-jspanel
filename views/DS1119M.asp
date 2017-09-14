<%
	If Request("callback") = "" then
		Response.Redirect "./no.asp"
	End if
%>
<!--#include file="./include/JSON.asp"-->
<!--#include file="./include/JSON_UTIL.asp"-->
<%	
	EMP_ID = Request("EMP_ID")
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("ConnInfo4") 

	Dim searchList()
	Dim rList  

	SQL = "SELECT MAX(DOCU_ID) AS DOCU_ID, WPA_CODE.WFU_PERSON_NM('K', MAX(ENTRY_PERSON)) AS ENTRY_PERSON_NM, (SELECT MIN(Z.FILE_NO) || ' ¿Ü ' || TO_NUMBER(COUNT(*) - 1) || '°Ç' FROM WT_E121D Z WHERE Z.AGREE_WORK_NO = A.WORK_NO) AS FILE_NO, (SELECT MAX(Z.USER_SIGN_DATE) FROM WT_ZC10D Z WHERE Z.WORK_NO = A.WORK_NO AND Z.WORK_DIV = A.WORK_DIV AND Z.SANCTION_SEQ NOT IN ('C090', 'C100', 'C120')) AS RECENT_SIGN_DATE, WPA_CODE.WFU_CD_NM2('SANCTION_DOC', A.WORK_DIV) AS REPORT_URL, ROUND((SYSDATE - (SELECT MAX(Z.USER_SIGN_DATE) FROM WT_ZC10D Z WHERE Z.WORK_NO = A.WORK_NO AND Z.WORK_DIV = A.WORK_DIV AND Z.SANCTION_SEQ NOT IN ('C090', 'C100', 'C120'))) * 24) AS DIF_HOUR FROM WT_ZC10M A JOIN WT_ZC10D B on (a.work_div = 'AC01' and a.work_no = b.work_no  and a.work_div = b.work_div  and a.next_user = b.user_id  and b.sanction_seq in ('C090', 'C100', 'C120')  and b.user_sign is null  and a.status not in ('66', '88', '99')) WHERE A.NEXT_USER LIKE '%' || '" & EMP_ID & "' || '%' AND A.WORK_DIV = 'AC01' group by a.work_no, a.work_div ORDER BY MAX(A.REG_DT) DESC"  

	Response.Write Request("callback") & "("&toJSON(QueryToJSON(Conn, SQL)) &")"
	Response.End
%>	
