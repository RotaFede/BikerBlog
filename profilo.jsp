<!--  ~\Desktop\java\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\BikerBlog -->
<html>
	<head>
		<title>Profilo</title>
		<link rel="stylesheet" href="style.css">
	</head>
	<body>
	<%@ page import="java.io.*" %>
	<%@ page import="java.sql.*" %>
	<%@ page import="javax.servlet.ServletException" %>
	<%@ page import="javax.servlet.annotation.WebServlet" %>
	<%@ page import="javax.servlet.http.*" %>
	
	
		<% if(session.getAttribute("nome") == null)
				response.sendRedirect(request.getContextPath() + "/index.jsp");
			else{
				out.println("<ul>");
				out.println("<li><a href='home.jsp'>BikerBlog</a></li>");
				out.println("<li><a href='Gestione?operazione=crea'>Crea nuovo post</a></li>");
				out.println("<li><a href='Gestione?operazione=user'>Cambia moto</a></li>");
				out.println("<li><a href='Logout'>Esci</a></li>");
				out.println("</ul><br><br><br><br>");
				try {
		            Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
		        } catch (ClassNotFoundException e) {
		            out.println("<p>Errore: Impossibile caricare il Driver Ucanaccess</p>");
		        }
		        Connection connection = null;
		        try{
		            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "user.accdb");
		            Statement st = connection.createStatement();
		            session = request.getSession();
		            String query = "SELECT * FROM Post WHERE Utente='" + session.getAttribute("user") +"' ORDER BY DataCreazione DESC;"; 
		            ResultSet rs = st.executeQuery(query);
		            out.println("<table><th>Titolo</th><th>Descrizione</th><th>Operazione</th>");
		            while(rs.next()) {
		    			out.println("<tr>");
		            	out.println("<td>" + rs.getString(3) + "</td>");
		            	out.println("<td>" + rs.getString(4) + "</td>");
		            	out.println("<td> <a href='Gestione?operazione=modifica&id="+rs.getString(1)+"'>Modifica</a>");
		            	out.println("<a href='Gestione?operazione=elimina&id="+rs.getString(1)+"'>Elimina</a></td>");
		            	out.println("</tr>");
		            }
		            out.println("</table>");
		        }
		        catch (SQLException ex) {
		            out.println("<p>" + ex +"</p>");
		        }
		        finally{
		            if(connection != null){
		                try{
		                    connection.close();
		                }catch(Exception e){System.out.println(e);}
		            }
		        }
				
			}
		%>
	</body>
</html>