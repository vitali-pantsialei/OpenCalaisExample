using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OpenCalaisExample.Calais;
using OpenCalaisExample.Models;

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
        public ActionResult Index(string inputData)
        {
            string resp = null;
            TransformationModel tm = new TransformationModel();
            try
            {
                Calais.calaisSoapClient client = new calaisSoapClient();
                resp = client.Enlighten(apiKey, inputData, paramsRDF);
                tm.XmlFile = resp;
                tm.XsltPath = Server.MapPath("~/Content/index.xslt");
            }
            catch(Exception)
            {
                tm = null;
            }
            return View(tm);
        }
    }
}
