using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OpenCalaisExample.Calais;
using OpenCalaisExample.Models;
using System.IO;

namespace OpenCalaisExample.Controllers
{
    public class HomeController : Controller
    {
        private string apiKey = "w39fuahdc3s8xrmb63pvxtdg";
        static string paramsRDF =
@"<c:params xmlns:c=""http://s.opencalais.com/1/pred/"" xmlns:rdf=""http://www.w3.org/1999/02/22-rdf-syntax-ns#"">
<c:processingDirectives c:allowDistribution=""true"" c:allowSearch=""true"" c:contentType=""text/txt"" c:outputFormat=""xml/rdf"">
</c:processingDirectives><c:externalMetadata></c:externalMetadata>
</c:params>";

        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(string inputData, HttpPostedFileBase file)
        {
            TransformationModel tm = new TransformationModel();
            tm.XsltPath = Server.MapPath("~/Content/index.xslt");
            if (file != null)
            {
                using (BinaryReader b = new BinaryReader(file.InputStream))
                {
                    byte[] binData = b.ReadBytes(file.ContentLength);
                    inputData = System.Text.Encoding.UTF8.GetString(binData);
                }
            }
            try
            {
                Calais.calaisSoapClient client = new calaisSoapClient();
                tm.XmlFile = client.Enlighten(apiKey, inputData, paramsRDF);
            }
            catch (Exception)
            {
                tm = null;
            }
            //return Content(tm.XmlFile, "text/xml");
            return View(tm);
        }
    }
}
