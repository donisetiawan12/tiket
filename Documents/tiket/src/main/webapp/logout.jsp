<%
    // 1. Hapus semua data session (biar user beneran keluar)
    session.invalidate(); 
    
    // 2. Arahkan balik ke index.jsp (Halaman utama/Landing Page)
    response.sendRedirect("index.jsp");
%>