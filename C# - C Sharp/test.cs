namespace SomeNamespace
{
	class SomeClass : LALAClass
	{
        public SomeClass() {}
        
        object _obj = null;
        object SomeProperty
        {
            set { _obj = value; }
            get { return obj; }
        }
	}
}
