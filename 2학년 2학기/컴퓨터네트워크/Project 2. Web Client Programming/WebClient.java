import java.io.*;
import java.net.*;
import java.util.*;

public class WebClient
{
    public String getWebContentByGet(String urlString, final String charset, int timeout) throws IOException
    {
        if(urlString == null || urlString.length() == 0)
            return null;
        urlString = (urlString.startsWith("http://") || urlString.startsWith("https://")) ? urlString : ("http://" + urlString).intern();
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("User-Agent", "2022057110/YONGJOONKIM/WebClient/ComNet");
        conn.setRequestProperty("Accept", "text/html");
        conn.setConnectTimeout(timeout);
        try
        {
            if(conn.getResponseCode() != HttpURLConnection.HTTP_OK)
                return null;
            
        }
        catch(IOException e)
        {
            e.printStackTrace();
            return null;
        }

        InputStream input = conn.getInputStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(input, charset));
        String line = null;
        StringBuffer sb = new StringBuffer();
        while((line = reader.readLine()) != null)
            sb.append(line).append("\r\n");

        if(reader != null)
            reader.close();
        if(conn != null)
            conn.disconnect();
            
        return sb.toString();
    }

    public String getWebContentByPost(String urlString, String data, final String charset, final int timeout) throws IOException
    {
        if(urlString == null || urlString.length() == 0)
            return null;
        urlString = (urlString.startsWith("http://") || urlString.startsWith("https://")) ? urlString : ("http://" + urlString).intern();
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        connection.setDoOutput(true);
        connection.setDoInput(true);
        connection.setRequestMethod("POST");

        connection.setUseCaches(false);
        connection.setInstanceFollowRedirects(true);

        connection.setRequestProperty("Content-Type", "text/xml;charset=UTF-8");

        connection.setRequestProperty("User-Agent", "2022057110/YONGJOONKIM/WebClient/ComNet");

        connection.setRequestProperty("Accept", "text/xml");
        connection.setConnectTimeout(timeout);
        connection.connect();
        DataOutputStream out = new DataOutputStream(connection.getOutputStream());

        byte[] content = data.getBytes("UTF-8");
        
        out.write(content);
        out.flush();
        out.close();

        try
        {
            if(connection.getResponseCode() != HttpURLConnection.HTTP_OK)
                return null;
        }
        catch(IOException e)
        {
            e.printStackTrace();
            return null;
        }
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), charset));
        String line;
        StringBuffer sb = new StringBuffer();
        while((line = reader.readLine()) != null)
            sb.append(line).append("\r\n");
        if(reader != null)
            reader.close();
        if(connection != null)
            connection.disconnect();

        return sb.toString();
    }

    public static void main(String[] args) throws IOException
    {
        WebClient webClient = new WebClient();
        Scanner sc = new Scanner(System.in);
        while(true)
        {
            System.out.println("Select command (1: GET, 2: POST, 0: exit): ");
            
            int command = sc.nextInt();
            if(command == 0)
            {
                System.exit(0);
                sc.close();
            }
            else if(command == 1)
            {
                System.out.println("Insert URL: ");
                String getUrl = sc.next();
                try 
                {
                    String getResponse = webClient.getWebContentByGet(getUrl, "UTF-8", 5000000);
                    if(getResponse != null)
                        System.out.println("GET Response:\n" + getResponse);
                    else 
                        System.out.println("GET Request failed");
                } 
                catch(IOException e) 
                {
                    e.printStackTrace();
                }
            }
            else if(command == 2)
            {
                System.out.println("Insert URL: ");
                String postUrl = sc.next();
                System.out.println("Insert data: ");
                String postData = sc.next();
                try 
                {
                    String postResponse = webClient.getWebContentByPost(postUrl, postData, "UTF-8", 5000000);
                    if(postResponse != null)
                        System.out.println("POST Response:\n" + postResponse);
                    else     
                        System.out.println("POST Request failed");
                }
                catch(IOException e) 
                {
                    e.printStackTrace();
                }
            }
        }
    }
}