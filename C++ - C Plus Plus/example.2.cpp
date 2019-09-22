
/* Ok */

CParentObject::CParentObject()
{
}

/* False */

CMyObject::CMyObject():CParentObject()
{
}

// Ok

void CMyObject::SomeFunction()
{
}

// Ok

virtual CMyObject::~CMyObject()
{
}