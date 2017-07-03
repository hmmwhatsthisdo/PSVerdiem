using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSVerdiem
{
    public class attributeDeviceFilter : abstractDeviceFilter
    {
        public attributeDeviceFilter()
        {

        }

        public string literal;
        //public string @operator;
        public string attributeName;

        public attributeDeviceFilter(string literal, string @operator, string attributeName) {
            this.attributeName = attributeName;
            this.literal = literal;
            this.@operator = @operator;
        }

    }
}
