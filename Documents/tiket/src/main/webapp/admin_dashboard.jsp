<%
    // Ambil session role
    String userRole = (String) session.getAttribute("role");

    // Jika belum login ATAU rolenya bukan admin
    if (session.getAttribute("user_id") == null || !"admin".equals(userRole)) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
%>