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

        public compoundDeviceFilter(IEnumerable<abstractDeviceFilter> filters) {
            this.filters = new List<abstractDeviceFilter>(filters);
        }
    }
}
