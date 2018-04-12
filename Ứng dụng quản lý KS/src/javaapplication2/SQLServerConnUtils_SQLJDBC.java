/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication2;

/**
 *
 * @author NhoxToong
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLServerConnUtils_SQLJDBC {
    public static Connection getSQLServerConnection()
         throws SQLException, ClassNotFoundException {
     String hostName = "DESKTOP-1TK54IB";
     String sqlInstanceName = "SQLEXPRESS";
     String database = "QuanLyWebsiteDatKhachSan";
     String userName = "sa";
     String password = "1234";
 
     return getSQLServerConnection(hostName, sqlInstanceName,
             database, userName, password);
    }
    
    public static Connection getSQLServerConnection(String hostName,
         String sqlInstanceName, String database, String userName,
         String password) throws ClassNotFoundException, SQLException {
     // Khai báo class Driver cho DB SQLServer
     Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
 
     // Cấu trúc URL Connection dành cho SQLServer
     // Ví dụ:
     // jdbc:sqlserver://ServerIp:49522/SQLEXPRESS;databaseName=simplehr
     String connectionURL = "jdbc:sqlserver://" + hostName + ":49522"
             + ";instance=" + sqlInstanceName + ";databaseName=" + database;
 
     Connection conn = DriverManager.getConnection(connectionURL, userName,
             password);
     return conn;
 }
}
