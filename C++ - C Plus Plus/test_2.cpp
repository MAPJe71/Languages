void SomeFunc(int someArg);

void SomeFunc(int someArg)
{
  int someLocal = 0;

  SomeClass *sc1 = new SomeClass();
  sc1->SomeMethod();
  sc1->SomeMethod(i);
  sc1->SomeMethod(SomeOtherCall());

  SomeClass sc2();
  sc2.SomeMethod();
  sc2.SomeMethod(i);
  sc2.SomeMethod(SomeOtherCall());
}
