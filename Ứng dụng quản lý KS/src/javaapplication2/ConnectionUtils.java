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
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.CallableStatement;

public class ConnectionUtils {
    public static Connection getMyConnection() throws SQLException,
          ClassNotFoundException {
      // gọi hàm kết nối
      return SQLServerConnUtils_SQLJDBC.getSQLServerConnection();
    }
}
