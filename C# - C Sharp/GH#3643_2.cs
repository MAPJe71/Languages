// https://github.com/notepad-plus-plus/notepad-plus-plus/issues/3643

namespace BaseClass
{
    public class Person
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public Persion(string firstName, string lastName)
        {
            // Validate the first and last names.
            if ((firstName == null) || (firstName.Length < 1))
                throw new ArgumentOutOfRangeException(
                        "firstName", firstName,
                        "FirstName must not be null or blank."
                        );
            if ((lastName == null) || (lastName.Length < 1))
                throw new ArgumentOutOfRangeException(
                        "lastName", lastName,
                        "LastName must not be null or blank."
                        );
            // Save the first and last names.
            FirstName = firstName;
            LastName = lastName;
        }
    }
    public class implement
    {
        static void Main(string[] args)
        {
            Person p = new Person("Akshay", "Chavan");
            Console.WriteLine("The first name is " + p.FirstName);
        }
    }
}
