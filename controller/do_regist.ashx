<%@ WebHandler Language="C#" Class="do_login" %>

using System;
using System.Web;

using MySql.Data.MySqlClient;

public class do_login : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        if ( string.IsNullOrEmpty(context.Request.Form["username"]) ||
            string.IsNullOrEmpty(context.Request.Form["password"]) )
        {
            
            context.Response.Write("{'}");
            context.Response.End();
        }


        MySqlConnection hConnect = new MySqlConnection("Database=zdb_gallery;Data Source=127.0.0.1;User Id=zdb_gallery;Password=zdb;pooling=false;CharSet=utf8;port=3306");
        MySqlCommand hCommand = new MySqlCommand("insert into zdb_user(username,password,salt) values('zdb5','zdb5','zdb5')",hConnect);
        hConnect.Open();

        try {
            hCommand.ExecuteNonQuery();
            hCommand.CommandText = "SELECT LAST_INSERT_ID() AS id";
            MySqlDataReader result = hCommand.ExecuteReader();
            
            while (result.Read())
            {
                if (result.HasRows)
                {
                    //context.Response.Write(result["id"]);
                    //context.Response.Write(result.FieldCount);
                    for (int i = 0; i < result.FieldCount; i++)
                    {
                        context.Response.Write(result.GetValue(i));
                    }
                }
            }
            
        }catch (Exception e) {
            context.Response.Write(e.Message);
        }

        context.Response.Write(hConnect.State.ToString());
        hConnect.Close();
        

        
        
        context.Response.ContentType = "text/html";
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    
    
    public static MySqlConnection getSqlCon()
    {
        String mysqlStr = "Database=zdb_gallery;Data Source=127.0.0.1;User Id=zdb_gallery;Password=zdb;pooling=false;CharSet=utf8;port=3306";
        // String mySqlCon = ConfigurationManager.ConnectionStrings["MySqlCon"].ConnectionString;
        MySqlConnection mysql = new MySqlConnection(mysqlStr);
        return mysql;
    }

    public static MySqlCommand getSqlCommand(String sql, MySqlConnection mysql)
    {
        MySqlCommand mySqlCommand = new MySqlCommand(sql, mysql);
        //  MySqlCommand mySqlCommand = new MySqlCommand(sql);
        // mySqlCommand.Connection = mysql;
        return mySqlCommand;
    }

    public static void getResultset(MySqlCommand mySqlCommand)
    {
        MySqlDataReader reader = mySqlCommand.ExecuteReader();
        try
        {
            while (reader.Read())
            {
                if (reader.HasRows)
                {
                    Console.WriteLine("编号:" + reader.GetInt32(0) + "|姓名:" + reader.GetString(1) + "|年龄:" + reader.GetInt32(2) + "|学历:" + reader.GetString(3));
                }
            }
        }
        catch (Exception)
        {
            Console.WriteLine("查询失败了！");
        }
        finally
        {
            reader.Close();
        }
    }

    public static void getUpdate(MySqlCommand mySqlCommand)
    {
        try
        {
            mySqlCommand.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            String message = ex.Message;
            Console.WriteLine("修改数据失败了！" + message);
        }
    }

    public static void getDel(MySqlCommand mySqlCommand)
    {
        try
        {
            mySqlCommand.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            String message = ex.Message;
            Console.WriteLine("删除数据失败了！" + message);
        }
    }

}