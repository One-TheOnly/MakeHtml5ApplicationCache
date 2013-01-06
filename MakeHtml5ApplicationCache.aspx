<%@ Page Language="C#" Debug="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>MakeHtml5ApplicationCache</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%
                rootDir = Server.MapPath("../");
                //
                var cacheFile = "cache.appcache";
                //file
                var cacheList = getCacheList(rootDir);
                //make
                using (var writer = new System.IO.FileInfo(rootDir + "/" + cacheFile + "").CreateText())
                {
                    writer.WriteLine("CACHE MANIFEST");
                    writer.WriteLine("#Cache v61");
                    //
                    foreach (var item in cacheList)
                    {
                        writer.WriteLine("#" + item.Key);
                        //
                        foreach (var value in item.Value)
                        {
                            writer.WriteLine(value);
                        }
                    }
                }
            %>
        </div>
    </form>
    <script runat="server">
        //
        string rootDir = null;
        //
        new Dictionary<string, List<string>> cacheList = new Dictionary<string, List<string>>();
        //
        Dictionary<string, List<string>> getCacheList(string rootDir)
        {
            var dirs = System.IO.Directory.GetDirectories(rootDir);
            foreach (var dir in dirs)
            {
                if (dir.Replace(rootDir, null).StartsWith(".") || dir.Replace(rootDir, null).StartsWith("_"))
                {
                    continue;
                }
                //dir
                getDirs(dir);
            }
            //
            return cacheList;
        }

        void getFiles(string dir)
        {
            var name = dir.Replace(rootDir, null);
            var list = new List<string>();
            //
            foreach (var file in System.IO.Directory.GetFiles(dir))
            {
                list.Add(file.Replace(rootDir, null));
            }
            //
            Response.Write(name + "<br>");
            cacheList.Add(name, list);
        }

        void getDirs(string dir)
        {
            //file
            getFiles(dir);
            //dir
            foreach (var subDir in System.IO.Directory.GetDirectories(dir))
            {
                //dir
                getDirs(subDir);
            }
        }
    </script>
</body>
</html>
