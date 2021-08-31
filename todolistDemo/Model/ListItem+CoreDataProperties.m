//
//  ListItem+CoreDataProperties.m
//  todolistDemo
//
//  Created by Lgc on 2021/9/1.
//
//

#import "ListItem+CoreDataProperties.h"

@implementation ListItem (CoreDataProperties)

+ (NSFetchRequest<ListItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ListItem"];
}

@dynamic alertTime;
@dynamic cellsortID;
@dynamic contentTX;
@dynamic isDone;
@dynamic markTop;
@dynamic cellTitle;
@dynamic editTime;

@end
