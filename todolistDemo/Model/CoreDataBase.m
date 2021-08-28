//
//  CoreDataBase.m
//  todolistDemo
//
//  Created by Lgc on 2021/8/1.
//

#import "CoreDataBase.h"

@implementation CoreDataBase
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "iii.BBB" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SaveModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"listItem.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
//增
- (void)insertCoreData:(NSDictionary *)model
{
    NSManagedObjectContext *context = [self managedObjectContext];
    ListItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"ListItem" inManagedObjectContext:context];
    item.alertTime = [model valueForKey:@"alertTime"];
    item.cellsortID = [[model valueForKey:@"cellsortID"] integerValue];
    item.contentTX = [model valueForKey:@"contentTX"];
    item.isDone = [[model valueForKey:@"isDone"] boolValue];
    item.markTop = [[model valueForKey:@"markTop"] boolValue];
    item.cellTitle = [model valueForKey:@"cellTitle"];
//    item.alertTime = model.alertTime;
//    item.cellsortID = model.cellsortID;
//    item.contentTX = model.contentTX;
//    item.isDone = model.isDone;
//    item.markTop = model.markTop;
    [context save:nil];
}
//删
-(void)deleCoreDataWithpred:(NSString *)predicateStr{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    //设置要查询的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate * perdicate = [NSPredicate predicateWithFormat:@"%@",predicateStr];
    request.predicate = perdicate;
    NSArray * arr = [context executeFetchRequest:request error:nil];
    if (arr.count) {
        for (ListItem * tmp in arr) {
            [context deleteObject:tmp];
        }
        [context save:nil];
    }
    
}
-(void)deleMOWithID:(NSManagedObjectID *)moID {
    NSManagedObjectContext *context = [self managedObjectContext];
   
    ListItem * tmp = [context objectWithID:moID];
    if (tmp) {
        [context deleteObject:tmp];
        [context save:nil];
    }
}
-(void)deleMOAll {
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    //设置要查询的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:context];
    request.entity = entity;
    NSArray *arr = [context executeFetchRequest:request error:nil];
    if (arr.count) {
        for (ListItem * tmp in arr) {
            [context deleteObject:tmp];
        }
        [context save:nil];
    }
    
}
//改
-(void)changeMOWithID:(NSManagedObjectID *)moID changeData:(ListItem *)model {
    NSManagedObjectContext * context = [self managedObjectContext];
    ListItem * tmp = [context objectWithID:moID];
    if (tmp) {
        tmp = model;
        [context save:nil];
    }
   
}
//查询
- (NSArray *)queryCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    //设置要查询的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:context];
    request.entity = entity;
    NSArray *arr = [context executeFetchRequest:request error:nil];
    NSLog(@"arr %@",arr);
    return arr;
}
@end
