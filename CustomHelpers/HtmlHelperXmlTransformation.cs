using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml;
using System.Xml.Xsl;

namespace OpenCalaisExample.CustomHelpers
{
    public static class HtmlHelperXmlTransformation
    {
        public static HtmlString TransformXml(this HtmlHelper helper, string xml, string xsltPath)
        {
            XslCompiledTransform t = new XslCompiledTransform();
            t.Load(xsltPath);
            using (XmlReader sr = XmlReader.Create(new StringReader(xml)))
            {
                using (StringWriter sw = new StringWriter())
                {
                    XmlWriterSettings settings = new XmlWriterSettings();
                    settings.ConformanceLevel = ConformanceLevel.Fragment;
                    using (XmlWriter xw = XmlWriter.Create(sw, settings))
                    {
                        t.Transform(sr, xw);
                    }
                    return new HtmlString(sw.ToString());
                }
            }
        }
    }
}