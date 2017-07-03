using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;


namespace PSVerdiem
{
    public class StatefulTypeResolver : JavaScriptTypeResolver
    {
        private SimpleTypeResolver FallbackResolver;

        private Dictionary<string, Type> RegisteredTypes;

        public StatefulTypeResolver() {
            RegisteredTypes = new Dictionary<string, Type>();
            FallbackResolver = new SimpleTypeResolver();
            AllowFallback = true;
            FallbackFirst = false;
        }

        public StatefulTypeResolver(IDictionary<string, Type> TypesToRegister, bool ShouldAllowFallback = true, bool ShouldFallbackFirst = false) {
            RegisteredTypes = new Dictionary<string, Type>(TypesToRegister);
            AllowFallback = ShouldAllowFallback;
            FallbackFirst = ShouldFallbackFirst;
        }

        private bool AllowFallback;

        private bool FallbackFirst;

        public void RegisterType(string id, Type type) {
            RegisteredTypes.Add(id, type);
        }

        public override string ResolveTypeId(Type type) {
            string result = null;

            if (FallbackFirst && AllowFallback) {
                result = FallbackResolver.ResolveTypeId(type);
                if (result != null) {
                    return result;
                }
            }

            if (RegisteredTypes.ContainsValue(type)) {
                result = RegisteredTypes.First(x => (x.Value == type)).Key;
            }

            return result;
        }

        public override Type ResolveType(string id) {

            Type result = null;

            if (FallbackFirst && AllowFallback) {
                result = FallbackResolver.ResolveType(id);
                if (result != null) {
                    return result;
                }
            }

            if (RegisteredTypes.ContainsKey(id)) {
                result = RegisteredTypes[id];
            }

            if (!FallbackFirst && AllowFallback && result == null) {
                result = FallbackResolver.ResolveType(id);
            }

            return result;

        }  
    }
}
