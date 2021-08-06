//
//  ListItem+CoreDataProperties.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/31.
//
//

#import "ListItem+CoreDataProperties.h"

@implementation ListItem (CoreDataProperties)

+ (NSFetchRequest<ListItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ListItem"];
}

@dynamic markTop;
@dynamic cellsortID;
@dynamic isDone;
@dynamic contentTX;
@dynamic alertTime;

@end
