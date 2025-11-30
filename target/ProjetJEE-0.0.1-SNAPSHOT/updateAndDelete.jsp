<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.List" %>
    <%@ page import="com.rsv.model.Projet" %>
    <%@ page import="com.rsv.model.Employe" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="row">
	<% List<Projet> projets =(List<Projet>) request.getAttribute("projets"); 
	if(projets !=null){
		for (Projet projet : projets){%>
			<div class="col-3">
			<h5><%=projet.getId()%></h5>
			<% for(Employe employe : projet.getEquipe()){%>
				<div class="employe-item">
					<img src="img/employe.jpg" alt="employe">
					<%=employe.getId() %><br><small><%=employe.getNom() %></small>
					<br><small><%=employe.getGrade() %></small>
				</div>
			<%}%>
			<br><p><%=projet.getEcheance() %></p>
			<br><small><%=projet.getÉtat() %></small>
			</div>
			<%}%>
		<%}%>
	}
	%>
</div>

</body>
</html>