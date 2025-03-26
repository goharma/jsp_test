import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.net.ssl.HttpsURLConnection;
import java.security.cert.Certificate;
import java.util.Scanner;

public class SSLRequestConsoleApp {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter URL: ");
        String urlString = scanner.nextLine();
        scanner.close();

        StringBuilder sslInfo = new StringBuilder();
        StringBuilder responseContent = new StringBuilder();
        int responseCode = -1;

        try {
            if (urlString != null && !urlString.trim().isEmpty()) {
                URL url = new URL(urlString);
                if (url.getProtocol().equalsIgnoreCase("https")) {
                    HttpsURLConnection httpsConn = (HttpsURLConnection) url.openConnection();
                    httpsConn.setRequestMethod("GET");
                    httpsConn.connect();

                    System.out.println("\nSSL Certificates:");
                    for (Certificate cert : httpsConn.getServerCertificates()) {
                        System.out.println("Type: " + cert.getType());
                        System.out.println("Public Key: " + cert.getPublicKey().toString());
                        System.out.println("Encoded: " + new String(cert.getEncoded()));
                        System.out.println();
                    }

                    responseCode = httpsConn.getResponseCode();
                    BufferedReader in = new BufferedReader(new InputStreamReader(httpsConn.getInputStream()));
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        responseContent.append(inputLine).append("\n");
                    }
                    in.close();
                } else {
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    responseCode = conn.getResponseCode();
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        responseContent.append(inputLine).append("\n");
                    }
                    in.close();
                }
            }
        } catch (Exception e) {
            responseContent.append("Error: ").append(e.getMessage());
        }

        System.out.println("\nResponse Status Code: " + responseCode);
        System.out.println("\nResponse Received:\n" + responseContent.toString());
    }
}
