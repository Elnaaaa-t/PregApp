<%-- 
    Document   : ViewAppointments
    Created on : Apr 3, 2024, 11:48:29 PM
    Author     : asus
--%>

<%@page import="java.sql.ResultSet"%>
<jsp:useBean class="DB.ConnectionClass" id="con"></jsp:useBean>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>BabyGlow : Appointments List</title>
    </head>
    <body>
        <%@include file="Header.jsp" %>
        <%    if (request.getParameter("acc") != null) {
                String UpQry = "update tbl_scheduleslots set scheduleslots_count=scheduleslots_count-1 where scheduleslots_id='" + request.getParameter("ss") + "'";
                boolean d = con.executeCommand(UpQry);
                String UpQry1 = "update tbl_appointments set appointments_cancel=1  where appointments_id='" + request.getParameter("acc") + "'";
                boolean s = con.executeCommand(UpQry1);
                if (s == true && d == true) {

        %>
        <script>
            alert("Cancellation Request Accpeted");
            window.location = "ViewAppointments.jsp";
        </script>
        <% }
        } else if (request.getParameter("rej") != null) {
            String delQrya = "update tbl_appointments set appointments_cancel=2  where appointments_id='" + request.getParameter("rej") + "'";
            con.executeCommand(delQrya);
        %>
        <script>
            alert("Cancellation Request Rejected");
            window.location = "ViewAppointments.jsp";
        </script>
        <%  }
        %>

        <form name="frmUserlist" method="post">
            <table  align="center" width="1300px" border="1">
                <tr>
                    <th colspan="9" align="center">My Appointments</th>
                </tr>
                <tr>
                    <th>Sl No.</th>
                    <th>Date</th>
                    <th>Time Slot</th>
                    <th>Online/Offline</th>
                    <th>Patient Name</th>
                    <th>Doctor</th>
                    <th>Service</th>
                    <!--<th>Action</th>-->
                    <%  int i = 0, rowCount = 0;
                        String selQry1 = "select distinct appointments_date from tbl_appointments where hospital_id='" + session.getAttribute("hid") + "'";
                        ResultSet rs1 = con.selectCommand(selQry1);
                        while (rs1.next()) {
                            String selQry = "select a.scheduleslots_id,a.appointments_online,a.appointments_id,a.appointments_cancel,a.appointments_date ,d.doctors_name, h.user_name, sl.slots_fromtime, sl.slots_totime, sr.services_name from tbl_appointments a, tbl_user h, tbl_doctors d, tbl_services sr, tbl_hospitalservices hs, tbl_scheduleslots ss, tbl_slots sl where a.hospital_id='" + session.getAttribute("hid") + "' and a.appointments_date='" + rs1.getString("appointments_date") + "' and a.doctors_id=d.doctors_id and a.hospital_id=h.user_id and d.hospitalservices_id=hs.hospitalservices_id and hs.service_id=sr.services_id and a.scheduleslots_id=ss.scheduleslots_id and ss.slots_id=sl.slots_id";
                            ResultSet rs = con.selectCommand(selQry);
                            while (rs.next()) {
                                if (rs.last()) {
                                    rowCount = rs.getRow();
                                }
                            }
                            rs.beforeFirst();
                            ++i;


                    %>
                <tr align="center">
                    <td rowspan="<%=rowCount%>"><%=i%></td>
                    <td rowspan="<%=rowCount%>"><%=rs1.getString("appointments_date")%></td>
                    <%  while (rs.next()) {%>
                    <td><%=rs.getString("slots_fromtime")%> to <%=rs.getString("slots_totime")%></td>
                    <td><% if (rs.getInt("appointments_online") == 0) { %>Offline <% } else { %>Online<% }%></td>
                    <td><%=rs.getString("user_name")%></td>
                    <td><%=rs.getString("doctors_name")%></td>
                    <td><%=rs.getString("services_name")%></td>
                    <% if (rs.getString("appointments_cancel") == null) { %>
                    <td align="center">-</td>
                    <% } else if (rs.getInt("appointments_cancel") == 0) {%>
                    <td align="center">Cancellation Requested <a style=" color: #DE0592 ;  text-decoration: underline"  href="ViewAppointments.jsp?acc=<%=rs.getString("appointments_id")%>&ss=<%=rs.getString("scheduleslots_id")%>">Accept</a> <a style=" color: #DE0592 ;  text-decoration: underline"  href="ViewAppointments.jsp?rej=<%=rs.getString("appointments_id")%>">Reject</a>
                    </td>
                    <% } else if (rs.getInt("appointments_cancel") == 1) {%>
                    <td>Cancellation Accepted</td>
                    <% } else if (rs.getInt("appointments_cancel") == 2) {%>
                    <td>Cancellation Rejected</td>
                    <% } %>
                </tr>
                <tr align="center">
                    <% }
                        }%>
            </table>
        </form>
    </body>
    <%@include file="Footer.jsp" %>
</html>
