using System;

namespace BaseNamespace
{
	namespace SubSpace
	{
		class BaseClass
		{
		}
	}

	class BaseClass2
	{
		void SomeThing1()
		{
		}
		
		enum SomeThing
		{
			Value1,
			Value2
		}

		string SomeThing2
		{
			get { return SomeThing3.ToString(); }
			set { SomeThing3 = int.Parse(value); }
		}

		int SomeThing3 = 0;
	}
}

namespace BigNamespace
{
	class BaseClass
	{
	}
	
	class MiddleClass
	{
	}
	
	class BigClass : BaseClass
	{
		class SubClass
		{
		}
	}
}
