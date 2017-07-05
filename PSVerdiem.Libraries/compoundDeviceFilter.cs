using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSVerdiem
{
    public class compoundDeviceFilter : abstractDeviceFilter
    {
        public List<abstractDeviceFilter> filters;
        public compoundDeviceFilter() {
            filters = new List<abstractDeviceFilter>();
        }

        public compoundDeviceFilter(IEnumerable<abstractDeviceFilter> filters, string @operator) {
            if (filters.Count() <= 1) {
                throw new ArgumentException("Compound device filters require at least 2 subfilters.");
            }
            this.filters = new List<abstractDeviceFilter>(filters);
            this.@operator = @operator;
        }
    }
}
