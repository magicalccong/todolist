//
//  ListItem+CoreDataProperties.h
//  todolistDemo
//
//  Created by Lgc on 2021/7/31.
//
//

#import "ListItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ListItem (CoreDataProperties)

+ (NSFetchRequest<ListItem *> *)fetchRequest;

@property (nonatomic) BOOL markTop;
@property (nonatomic) int64_t cellsortID;
@property (nonatomic) BOOL isDone;
@property (nullable, nonatomic, copy) NSString *contentTX;
@property (nullable, nonatomic, copy) NSDate *alertTime;

@end

NS_ASSUME_NONNULL_END
