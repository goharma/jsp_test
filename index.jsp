<%@ page import="java.io.*, java.net.*, java.security.cert.*, javax.net.ssl.*" %>
<%
    String targetUrl = request.getParameter("url");
%>

<form method="GET">
    <label>Enter URL: <input type="text" name="url" value="<%= targetUrl != null ? targetUrl : "" %>"></label>
    <input type="submit" value="Check SSL">
</form>

<%
    if (targetUrl != null && !targetUrl.isEmpty()) {
        try {
            // Create a TrustManager that ignores certificate validation
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { return null; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) { }
                    public void checkServerTrusted(X509Certificate[] certs, String authType) { }
                }
            };
            
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
            
            // Open connection
            URL url = new URL(targetUrl);
            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setHostnameVerifier(new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            }); // Ignore hostname verification
            conn.connect();
            
            // Retrieve certificates
            out.println("<h2>SSL Certificates for " + targetUrl + "</h2>");
            for (Certificate cert : conn.getServerCertificates()) {
                X509Certificate xcert = (X509Certificate) cert;
                out.println("<pre>" + xcert.toString() + "</pre>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p>Please provide a URL.</p>");
    }
%>
