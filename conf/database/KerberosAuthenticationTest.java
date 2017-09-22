import java.sql.*;

public class KerberosAuthenticationTest {
  static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
  static final String DB_URL = "jdbc:sqlserver://$Server.$Domain:$Port;DatabaseName=master;integratedSecurity=true;authenticationScheme=JavaKerberos;serverSpn=MSSQLSvc/$Server.$Domain:$Port";
  
  public static void main(String[] args) {
    Connection conn = null;
    Statement stmt = null;
    
    try {
      Class.forName(JDBC_DRIVER);
      System.out.println("Connecting to database...");
      conn = DriverManager.getConnection(DB_URL);
      stmt = conn.createStatement();
      String sql;
      sql = "select auth_scheme from sys.dm_exec_connections where session_id=@@spid";
      ResultSet rs = stmt.executeQuery(sql);
      while(rs.next()) {
        String value = rs.getString(1);
        System.out.println("Authentication Scheme: " + value);
      }
      rs.close();
      stmt.close();
      conn.close();
    } catch(SQLException se) {
      se.printStackTrace();
    } catch(Exception e) {
      e.printStackTrace();
    } finally {
      try {
        if(stmt!=null) stmt.close();
      } 
      catch(SQLException se2) { 
      } //Do nothing
      try {
        if(conn!=null) conn.close();
      } 
      catch(SQLException se3) { 
        se3.printStackTrace(); 
      }
    }

    System.out.println("Disconnected from database.");
    
  }
}
