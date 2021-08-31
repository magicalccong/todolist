//
//  ListItem+CoreDataProperties.h
//  todolistDemo
//
//  Created by Lgc on 2021/9/1.
//
//

#import "ListItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ListItem (CoreDataProperties)

+ (NSFetchRequest<ListItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *alertTime;
@property (nonatomic) int64_t cellsortID;
@property (nullable, nonatomic, copy) NSString *contentTX;
@property (nonatomic) BOOL isDone;
@property (nonatomic) BOOL markTop;
@property (nullable, nonatomic, copy) NSString *cellTitle;
@property (nullable, nonatomic, copy) NSDate *editTime;

@end

NS_ASSUME_NONNULL_END
