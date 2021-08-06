//
//  CoreDataBase.h
//  todolistDemo
//
//  Created by Lgc on 2021/8/1.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ListItem+CoreDataClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface CoreDataBase : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertCoreData:(NSDictionary *)model;
- (NSArray *)queryCoreData;
- (void)deleCoreDataWithpred:(NSString *)predicateStr;
- (void)deleMOWithID:(NSManagedObjectID *)moID;
- (void)deleMOAll;
- (void)changeMOWithID:(NSManagedObjectID *)moID changeData:(ListItem *)model;
@end

NS_ASSUME_NONNULL_END
