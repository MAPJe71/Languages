//Parameters.h
#import <defobj/Arguments.h>

@interface MyParameters: Arguments_c
{
  int numBugs;
}

- (int)getBugArg;
@end

//Parameters.m

#import "MyParameters.h"
#import <stdlib.h>

@implementation MyParameters

+ createBegin: aZone
{
 static struct argp_option options[] = {
     {"numBugs",'n',"N", 0, "Set numBugs", 5},
     { 0 }
 };

 MyParameters *obj = [super createBegin: aZone];

 [obj addOptions: options];

 return obj;
}


- (int)parseKey: (int)key arg: (const char*)arg
{
  if (key == 'n')
  {
    numBugs = atoi(arg);
    return 0;
  }
  else
  return [super parseKey: key arg: arg];
}

- (int) getBugArg
{
 if (numBugs)
  return numBugs;
 else 
  return -1;
}

@end