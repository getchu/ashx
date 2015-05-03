<%@ WebHandler Language="C#" Class="login" %>

using System;
using System.Web;

public class login : IHttpHandler{
    
    public void ProcessRequest (HttpContext context) {
        if (null == context.Request.Cookies["uid"] || context.Request.Cookies["uid"].Value == "")
        {
            context.Response.Redirect("/login.html",true);
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}